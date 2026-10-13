// SiglusMovieFF - IAT proxy for SiglusEngine's WINMM MCI imports.
//
// The module is loaded into the game process.  At attach time it walks the main
// module's import table and rewrites the IAT slots for the MCI entry points it
// implements so that every engine call reaches us instead of winmm.
#include "common.h"
#include "mci.h"

#pragma comment(lib, "winmm.lib")

namespace {

HMODULE      g_self = nullptr;
std::wstring g_moduleDir;
std::wstring g_modulePath;
volatile LONG g_hooked = 0;


// Names we take over, and the address of our replacement.
struct HookEntry {
    const char* name;
    void*       replacement;
};

extern "C" MCIERROR WINAPI Smf_mciSendStringW(const wchar_t*, wchar_t*, UINT, HWND);
extern "C" BOOL     WINAPI Smf_mciGetErrorStringW(MCIERROR, wchar_t*, UINT);

const HookEntry kHooks[] = {
    { "mciSendStringW",      (void*)&Smf_mciSendStringW },
    { "mciGetErrorStringW",  (void*)&Smf_mciGetErrorStringW },
};

// Describes what was replaced, for the log.
struct HookReport {
    int  iatPatched = 0;
    int  eatPatched = 0;
};

// Patch the real winmm exports (affects GetProcAddress users and our own
// fallbacks).  This is done with VirtualProtect + a relative jump.
void* patchExport(HMODULE mod, const char* name, void* replacement) {
    if (!mod) return nullptr;
    BYTE* fn = (BYTE*)GetProcAddress(mod, name);
    if (!fn) return nullptr;

    // Build: mov eax, imm32 ; jmp eax   (7 bytes)
    BYTE patch[7];
    patch[0] = 0xB8;                                    // mov eax, imm32
    *(DWORD*)(patch + 1) = (DWORD)(uintptr_t)replacement;
    patch[5] = 0xFF; patch[6] = 0xE0;                   // jmp eax

    DWORD old = 0;
    if (!VirtualProtect(fn, sizeof(patch), PAGE_EXECUTE_READWRITE, &old)) {
        SMF_WARN("patchExport(%s): VirtualProtect failed (%lu)", name, GetLastError());
        return nullptr;
    }
    BYTE* tramp = (BYTE*)VirtualAlloc(nullptr, 16, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    if (tramp) {
        memcpy(tramp, fn, sizeof(patch));
        // jump back to the original code right after our patch
        tramp[7] = 0xE9;
        *(DWORD*)(tramp + 8) = (DWORD)((fn + sizeof(patch)) - (tramp + 12));
    }
    memcpy(fn, patch, sizeof(patch));
    VirtualProtect(fn, sizeof(patch), old, &old);
    FlushInstructionCache(GetCurrentProcess(), fn, sizeof(patch));
    SMF_INFO("patched winmm export '%s' at %p (trampoline %p)", name, fn, tramp);
    return tramp;
}

// Rewrite one IAT slot.  Slots may still point at the import-by-name thunk or
// already at the resolved function (we are usually loaded after the loader has
// resolved imports), so we accept either.
bool patchIatSlot(HMODULE target, const char* name, void* replacement) {
    if (!target) return false;
    BYTE* base = (BYTE*)target;
    IMAGE_DOS_HEADER* dos = (IMAGE_DOS_HEADER*)base;
    if (dos->e_magic != IMAGE_DOS_SIGNATURE) return false;
    IMAGE_NT_HEADERS* nt = (IMAGE_NT_HEADERS*)(base + dos->e_lfanew);
    if (nt->Signature != IMAGE_NT_SIGNATURE) return false;

    IMAGE_DATA_DIRECTORY& dir = nt->OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_IMPORT];
    if (!dir.VirtualAddress) return false;

    bool patched = false;
    IMAGE_IMPORT_DESCRIPTOR* imp = (IMAGE_IMPORT_DESCRIPTOR*)(base + dir.VirtualAddress);
    for (; imp->Name; ++imp) {
        const char* dll = (const char*)(base + imp->Name);
        if (_stricmp(dll, "winmm.dll") != 0) continue;

        IMAGE_THUNK_DATA* oft = imp->OriginalFirstThunk
            ? (IMAGE_THUNK_DATA*)(base + imp->OriginalFirstThunk) : nullptr;
        IMAGE_THUNK_DATA* ft = (IMAGE_THUNK_DATA*)(base + imp->FirstThunk);
        for (; ft->u1.Function; ++ft, oft ? ++oft : oft) {
            bool match = false;
            if (oft && !IMAGE_SNAP_BY_ORDINAL(oft->u1.Ordinal)) {
                IMAGE_IMPORT_BY_NAME* ibn = (IMAGE_IMPORT_BY_NAME*)(base + oft->u1.AddressOfData);
                if (strcmp((const char*)ibn->Name, name) == 0) match = true;
            }
            if (!match) continue;

            DWORD old = 0;
            if (VirtualProtect(&ft->u1.Function, sizeof(void*), PAGE_EXECUTE_READWRITE, &old)) {
                void* before = (void*)(uintptr_t)ft->u1.Function;
                ft->u1.Function = (uintptr_t)replacement;
                VirtualProtect(&ft->u1.Function, sizeof(void*), old, &old);
                SMF_INFO("IAT %s!%s: %p -> %p", dll, name, before, replacement);
                patched = true;
            } else {
                SMF_WARN("IAT %s!%s: VirtualProtect failed (%lu)", dll, name, GetLastError());
            }
        }
    }
    return patched;
}

void installHooks() {
    HMODULE winmm = GetModuleHandleW(L"winmm.dll");
    if (!winmm) winmm = LoadLibraryW(L"winmm.dll");

    HMODULE target = GetModuleHandleW(nullptr);
    char exe[MAX_PATH] = { 0 };
    GetModuleFileNameA(nullptr, exe, MAX_PATH);
    SMF_INFO("host module: %s (base %p)", exe, (void*)target);

    for (const HookEntry& h : kHooks) {
        patchIatSlot(target, h.name, h.replacement);
    }
    // Also take over the real exports so anything that resolves them later
    // (including our own mciGetErrorStringW fallback) reaches us.
    for (const HookEntry& h : kHooks) {
        patchExport(winmm, h.name, h.replacement);
    }
}

DWORD WINAPI initThread(LPVOID) {
    // When this module is pulled in by the executable's import table, DllMain runs
    // inside the loader lock, before the host's CRT (and ours) has finished coming
    // up.  This thread waits for the loader to let go and the process to be up
    // before touching anything.
    Sleep(800);

    SmfLogInit(g_moduleDir.c_str());
    SMF_INFO("==== SiglusMovieFF %ls loaded ====", SMF_VERSION);
    SMF_INFO("module: %ls", g_modulePath.c_str());
    if (FILE* f = _wfopen((g_moduleDir + L"\\SiglusMovieFF.debug").c_str(), L"rb")) {
        fclose(f);
        SmfLogSetLevel(SMF_LOG_DEBUG);
        SMF_INFO("debug logging enabled");
    }
    wchar_t host[MAX_PATH] = { 0 };
    GetModuleFileNameW(nullptr, host, MAX_PATH);
    SMF_INFO("host module: %ls (base %p)", host, (void*)GetModuleHandleW(nullptr));
    installHooks();
    SMF_INFO("hook installation finished");
    return 0;
}

} // namespace

// ---------------------------------------------------------------------------
// Exported API
// ---------------------------------------------------------------------------

extern "C" MCIERROR WINAPI Smf_mciSendStringW(const wchar_t* cmd, wchar_t* ret, UINT len, HWND wnd) {
    return SmfMci::instance().sendString(cmd, ret, len, wnd);
}

extern "C" BOOL WINAPI Smf_mciGetErrorStringW(MCIERROR err, wchar_t* buf, UINT len) {
    return SmfMci::instance().getErrorString(err, buf, len);
}

// Trivial CBT hook used only as an injection vehicle: when the injector installs
// it for the game's main thread, Windows maps this module into the game, and our
// DllMain runs the install.  The hook itself does nothing.
extern "C" LRESULT CALLBACK SmfInjectionHook(int code, WPARAM wp, LPARAM lp) {
    return CallNextHookEx(nullptr, code, wp, lp);
}

// Placeholder import target.  The patched executable imports exactly one symbol
// from this module; the loader requires it to exist, but it is never called.
extern "C" __declspec(dllexport) void SmfImportAnchor(void) {}

// ---------------------------------------------------------------------------
// DllMain
// ---------------------------------------------------------------------------

BOOL APIENTRY DllMain(HMODULE self, DWORD reason, LPVOID) {
    switch (reason) {
    case DLL_PROCESS_ATTACH: {
        g_self = self;
        DisableThreadLibraryCalls(self);
        wchar_t path[MAX_PATH] = { 0 };
        GetModuleFileNameW(self, path, MAX_PATH);
        g_modulePath = path;
        g_moduleDir = path;
        size_t p = g_moduleDir.find_last_of(L'\\');
        if (p != std::wstring::npos) g_moduleDir = g_moduleDir.substr(0, p);
        // Do the heavy lifting on our own thread: loader lock safety.
        HANDLE h = CreateThread(nullptr, 0, initThread, nullptr, 0, nullptr);
        if (h) CloseHandle(h);
        break;
    }
    case DLL_PROCESS_DETACH:
        if (reason == DLL_PROCESS_DETACH) {
            // Only tear down on explicit unload; during process exit the loader
            // lock makes it unsafe to wait on our worker threads.
            // (libmpv/FFmpeg globals are freed by the OS at that point.)
        }
        break;
    default:
        break;
    }
    return TRUE;
}
