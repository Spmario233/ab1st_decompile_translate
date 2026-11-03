// SiglusMovieFF - IAT proxy for SiglusEngine's WINMM MCI imports, plus a
// CreateFontW face redirect for the engine's editbox controls.
//
// The module is loaded into the game process.  At attach time it walks the main
// module's import table and rewrites the IAT slots for the entry points it
// implements so that every engine call reaches us instead of the system DLL.
#include "common.h"
#include "mci.h"
#include <intrin.h>

#pragma comment(lib, "winmm.lib")
#pragma comment(lib, "gdi32.lib")

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

// ---------------------------------------------------------------------------
// Editbox font redirection.
//
// The engine's editbox creates its HFONT with a hard-coded Japanese face name
// ("ＭＳ ゴシック") and then sends WM_SETFONT to the standard EDIT control.
// Gameexe's #CONFIG.FONT.NAME (KaiGenSP in this build) is only used by the
// engine's own text renderer, so the save-comment box ends up in MS Gothic.
// Intercept CreateFontW and swap that one face name for the bundled font.
// ---------------------------------------------------------------------------
using CreateFontWFn = HFONT (WINAPI*)(int, int, int, int, int,
                                      DWORD, DWORD, DWORD, DWORD,
                                      DWORD, DWORD, DWORD, DWORD,
                                      LPCWSTR);

CreateFontWFn g_origCreateFontW = nullptr;
uintptr_t g_hostBase = 0;
volatile LONG g_fontSubstitutions = 0;

bool isEditboxFace(const wchar_t* face) {
    if (!face) return false;
    // Full-width Japanese name used by the engine; also accept the ASCII
    // spelling in case another build passes it.
    return wcscmp(face, L"ＭＳ ゴシック") == 0 ||
           _wcsicmp(face, L"MS Gothic") == 0;
}

const char* faceTag(const wchar_t* face) {
    if (!face) return "null";
    if (isEditboxFace(face)) return "MS Gothic";
    if (_wcsicmp(face, L"KaiGenSP") == 0) return "KaiGenSP";
    if (_wcsicmp(face, L"SimSun") == 0) return "SimSun";
    if (_wcsicmp(face, L"SimHei") == 0) return "SimHei";
    return "other";
}

HFONT WINAPI Smf_CreateFontW(int cHeight, int cWidth, int cEscapement,
                             int cOrientation, int cWeight, DWORD bItalic,
                             DWORD bUnderline, DWORD bStrikeOut, DWORD iCharSet,
                             DWORD iOutPrecision, DWORD iClipPrecision,
                             DWORD iQuality, DWORD iPitchAndFamily,
                             LPCWSTR pszFaceName) {
    LPCWSTR face = pszFaceName;
    if (isEditboxFace(face)) {
        face = L"KaiGenSP";
        LONG n = InterlockedIncrement(&g_fontSubstitutions);
        void* caller = _ReturnAddress();
        unsigned long rva = (unsigned long)((uintptr_t)caller - g_hostBase);
        // Startup pre-creates #EDITBOX.CNT editboxes with height 0; log only the
        // first few of those.  A real create() has a non-zero height and is always
        // logged so the save-comment box is easy to spot in the log.
        if (cHeight != 0 || n <= 4) {
            SMF_INFO("CreateFontW: editbox face -> KaiGenSP (height=%d weight=%d charset=%lu caller=%p rva=0x%lX)",
                     cHeight, cWeight, (unsigned long)iCharSet, caller, rva);
        } else {
            SMF_DBG("CreateFontW: editbox face -> KaiGenSP (#%ld height=%d caller=%p rva=0x%lX)",
                    n, cHeight, caller, rva);
        }
    }
    if (!g_origCreateFontW) {
        // installHooks() resolves this before patching the IAT; keep a fallback
        // so an unexpectedly early call still works.
        HMODULE gdi = GetModuleHandleW(L"gdi32.dll");
        if (!gdi) gdi = LoadLibraryW(L"gdi32.dll");
        g_origCreateFontW = gdi
            ? (CreateFontWFn)GetProcAddress(gdi, "CreateFontW") : nullptr;
    }
    if (!g_origCreateFontW) return nullptr;
    return g_origCreateFontW(cHeight, cWidth, cEscapement, cOrientation, cWeight,
                             bItalic, bUnderline, bStrikeOut, iCharSet,
                             iOutPrecision, iClipPrecision, iQuality,
                             iPitchAndFamily, face);
}

// ---------------------------------------------------------------------------
// WM_SETFONT fallback/observer.
//
// The editbox sends WM_SETFONT after creating its HFONT.  If the font did not
// come through our CreateFontW hook (created before the hook was installed, via
// CreateFontIndirect, or from another module), this catches it at the last
// moment.  It also logs the actual face/height the EDIT control receives, which
// is the quickest way to tell whether the visible editbox really is KaiGenSP.
// ---------------------------------------------------------------------------
using SendMessageWFn = LRESULT (WINAPI*)(HWND, UINT, WPARAM, LPARAM);
SendMessageWFn g_origSendMessageW = nullptr;

LRESULT WINAPI Smf_SendMessageW(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    if (msg == WM_SETFONT && wParam && hWnd) {
        HFONT hf = (HFONT)wParam;
        LOGFONTW lf = {};
        if (GetObjectW(hf, sizeof(lf), &lf)) {
            wchar_t cls[64] = {};
            GetClassNameW(hWnd, cls, _countof(cls));
            if (_wcsicmp(cls, L"Edit") == 0) {
                SMF_INFO("WM_SETFONT Edit: face=%s height=%ld weight=%ld",
                         faceTag(lf.lfFaceName), lf.lfHeight, lf.lfWeight);
            }
            if (isEditboxFace(lf.lfFaceName)) {
                wcsncpy_s(lf.lfFaceName, LF_FACESIZE, L"KaiGenSP", _TRUNCATE);
                HFONT nf = CreateFontIndirectW(&lf);
                if (nf) {
                    SMF_INFO("WM_SETFONT: MS Gothic -> KaiGenSP (class=%ls height=%ld)",
                             cls, lf.lfHeight);
                    wParam = (WPARAM)nf;
                }
            }
        }
    }
    if (!g_origSendMessageW) {
        HMODULE user32 = GetModuleHandleW(L"user32.dll");
        if (!user32) user32 = LoadLibraryW(L"user32.dll");
        g_origSendMessageW = user32
            ? (SendMessageWFn)GetProcAddress(user32, "SendMessageW") : nullptr;
    }
    if (!g_origSendMessageW) return 0;
    return g_origSendMessageW(hWnd, msg, wParam, lParam);
}

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
bool patchIatSlot(HMODULE target, const char* moduleName, const char* name, void* replacement) {
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
        if (_stricmp(dll, moduleName) != 0) continue;

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
    g_hostBase = (uintptr_t)target;
    SMF_INFO("host module: %s (base %p)", exe, (void*)target);

    for (const HookEntry& h : kHooks) {
        patchIatSlot(target, "winmm.dll", h.name, h.replacement);
    }
    // Also take over the real exports so anything that resolves them later
    // (including our own mciGetErrorStringW fallback) reaches us.
    for (const HookEntry& h : kHooks) {
        patchExport(winmm, h.name, h.replacement);
    }

    // Editbox font: the engine imports GDI32!CreateFontW directly.  Resolve the
    // real function first, then redirect the host IAT slot to our wrapper.
    HMODULE gdi = GetModuleHandleW(L"gdi32.dll");
    if (!gdi) gdi = LoadLibraryW(L"gdi32.dll");
    g_origCreateFontW = gdi
        ? (CreateFontWFn)GetProcAddress(gdi, "CreateFontW") : nullptr;
    if (!g_origCreateFontW) {
        SMF_WARN("CreateFontW hook: cannot resolve gdi32!CreateFontW (%lu)",
                 GetLastError());
    } else if (patchIatSlot(target, "gdi32.dll", "CreateFontW",
                            (void*)&Smf_CreateFontW)) {
        SMF_INFO("CreateFontW hook installed (editbox face -> KaiGenSP)");
    } else {
        SMF_WARN("CreateFontW hook: gdi32!CreateFontW IAT slot not found");
    }

    // Last-resort WM_SETFONT hook: observes the exact face/height the EDIT
    // control receives, and substitutes KaiGenSP if the HFONT did not go through
    // CreateFontW (e.g. created by CreateFontIndirect or before hook install).
    HMODULE user32 = GetModuleHandleW(L"user32.dll");
    if (!user32) user32 = LoadLibraryW(L"user32.dll");
    g_origSendMessageW = user32
        ? (SendMessageWFn)GetProcAddress(user32, "SendMessageW") : nullptr;
    if (!g_origSendMessageW) {
        SMF_WARN("SendMessageW hook: cannot resolve user32!SendMessageW (%lu)",
                 GetLastError());
    } else if (patchIatSlot(target, "user32.dll", "SendMessageW",
                            (void*)&Smf_SendMessageW)) {
        SMF_INFO("SendMessageW hook installed (WM_SETFONT observer/fallback)");
    } else {
        SMF_WARN("SendMessageW hook: user32!SendMessageW IAT slot not found");
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
