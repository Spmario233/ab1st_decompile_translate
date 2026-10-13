// Crash diagnostics for the harness: writes a minidump and prints the faulting
// address / module so we can locate faults in the proxy or in FFmpeg.
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <dbghelp.h>
#include <stdio.h>
#include <string>
#include <vector>

#pragma comment(lib, "dbghelp.lib")

static std::wstring toHex(DWORD64 v) {
    wchar_t b[32];
    swprintf_s(b, L"0x%llX", (unsigned long long)v);
    return b;
}

static void probeDump();

static LONG WINAPI filter(EXCEPTION_POINTERS* ep) {
    DWORD code = ep->ExceptionRecord->ExceptionCode;
    void* addr = ep->ExceptionRecord->ExceptionAddress;

    HMODULE h = nullptr;
    wchar_t modName[MAX_PATH] = L"(unknown)";
    if (GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                           GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                           (LPCWSTR)addr, &h) && h) {
        GetModuleFileNameW(h, modName, MAX_PATH);
        const wchar_t* p = wcsrchr(modName, L'\\');
        if (p) wmemmove(modName, p + 1, wcslen(p));
    }

    wchar_t line[1024];
    swprintf_s(line, L"\n*** EXCEPTION code=0x%08lX at %p (module %ls + 0x%llX)\n",
               code, addr, modName,
               (unsigned long long)((DWORD64)addr - (DWORD64)h));
    fputws(line, stdout); fflush(stdout);
    OutputDebugStringW(line);
    probeDump();

    // Walk the stack and print return addresses.
    CONTEXT ctx = *ep->ContextRecord;
    STACKFRAME64 sf = { 0 };
    sf.AddrPC.Offset = ctx.Eip; sf.AddrPC.Mode = AddrModeFlat;
    sf.AddrStack.Offset = ctx.Esp; sf.AddrStack.Mode = AddrModeFlat;
    sf.AddrFrame.Offset = ctx.Ebp; sf.AddrFrame.Mode = AddrModeFlat;

    HANDLE proc = GetCurrentProcess();
    HANDLE thr = GetCurrentThread();
    SymInitialize(proc, nullptr, TRUE);

    fputws(L"    stack:\n", stdout);
    for (int i = 0; i < 24; ++i) {
        if (!StackWalk64(IMAGE_FILE_MACHINE_I386, proc, thr, &sf, &ctx, nullptr,
                         SymFunctionTableAccess64, SymGetModuleBase64, nullptr))
            break;
        DWORD64 a = sf.AddrPC.Offset;
        if (!a) break;

        wchar_t mname[MAX_PATH] = L"(?)";
        HMODULE mh = nullptr;
        DWORD64 base = 0;
        if (GetModuleHandleExW(GET_MODULE_HANDLE_EX_FLAG_FROM_ADDRESS |
                               GET_MODULE_HANDLE_EX_FLAG_UNCHANGED_REFCOUNT,
                               (LPCWSTR)a, &mh) && mh) {
            base = (DWORD64)mh;
            GetModuleFileNameW(mh, mname, MAX_PATH);
            const wchar_t* p = wcsrchr(mname, L'\\');
            if (p) wmemmove(mname, p + 1, wcslen(p));
        }
        wchar_t l2[512];
        swprintf_s(l2, L"      %02d  %p  %ls+0x%llX\n", i, (void*)a, mname, a - base);
        fputws(l2, stdout);
    }
    fflush(stdout);

    // Minidump next to the exe.
    wchar_t dump[MAX_PATH] = { 0 };
    GetModuleFileNameW(nullptr, dump, MAX_PATH);
    wchar_t* dot = wcsrchr(dump, L'.');
    if (dot) *dot = 0;
    wcscat_s(dump, L".dmp");

    HANDLE f = CreateFileW(dump, GENERIC_WRITE, 0, nullptr, CREATE_ALWAYS,
                           FILE_ATTRIBUTE_NORMAL, nullptr);
    if (f != INVALID_HANDLE_VALUE) {
        MINIDUMP_EXCEPTION_INFORMATION mei = { 0 };
        mei.ThreadId = GetCurrentThreadId();
        mei.ExceptionPointers = ep;
        mei.ClientPointers = FALSE;
        MiniDumpWriteDump(proc, GetCurrentProcessId(), f,
                          (MINIDUMP_TYPE)(MiniDumpNormal | MiniDumpWithThreadInfo |
                                          MiniDumpWithIndirectlyReferencedMemory),
                          &mei, nullptr, nullptr);
        CloseHandle(f);
        fwprintf(stdout, L"    minidump: %ls\n", dump);
        fflush(stdout);
    }
    return EXCEPTION_EXECUTE_HANDLER;
}

void InstallCrashFilter() {
    // No WER dialog / no blocking: we handle the fault ourselves.
    SetErrorMode(SEM_FAILCRITICALERRORS | SEM_NOGPFAULTERRORBOX | SEM_NOOPENFILEERRORBOX);
    SetUnhandledExceptionFilter(filter);
}

// ---------------------------------------------------------------------------
// Targeted memory probe: records the last (dst, src, bytes) passed to a memcpy
// wrapper and reports it from the crash filter, so a faulting copy is identified
// by its arguments instead of by a debugger.
// ---------------------------------------------------------------------------
static volatile LONG  g_probeActive = 0;
static volatile DWORD g_probeWhere = 0;
static volatile DWORD g_probeDst = 0;
static volatile DWORD g_probeSrc = 0;
static volatile DWORD g_probeLen = 0;

// 0=ok 1=null 2=size 3=dst 4=src
static int probeCheck(DWORD dst, DWORD src, DWORD len) {
    if (!dst || !src) return 1;
    if (len > 0x10000000u) return 2;
    for (int which = 0; which < 2; ++which) {
        DWORD p = which ? src : dst;
        MEMORY_BASIC_INFORMATION mbi;
        if (!VirtualQuery((LPCVOID)p, &mbi, sizeof(mbi))) return which ? 4 : 3;
        if (mbi.State != MEM_COMMIT) return which ? 4 : 3;
        if (mbi.Protect & (PAGE_NOACCESS | PAGE_GUARD)) return which ? 4 : 3;
        if (which == 0 && !(mbi.Protect & (PAGE_READWRITE | PAGE_WRITECOPY |
                                           PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY)))
            return 3;
        // Last byte must be in the same committed region as the first byte.
        MEMORY_BASIC_INFORMATION e;
        if (!VirtualQuery((LPCVOID)(p + len - 1), &e, sizeof(e))) return which ? 4 : 3;
        if ((DWORD)e.BaseAddress != (DWORD)mbi.BaseAddress) return which ? 4 : 3;
    }
    return 0;
}

static void probeDump() {
    if (!g_probeActive) return;
    wchar_t buf[512];
    int st = probeCheck(g_probeDst, g_probeSrc, g_probeLen);
    swprintf_s(buf, L"*** last memcpy: where=%lu dst=0x%08lX src=0x%08lX bytes=%lu check=%d\n",
               g_probeWhere, g_probeDst, g_probeSrc, g_probeLen, st);
    fputws(buf, stdout);
    fflush(stdout);
    OutputDebugStringW(buf);
    FILE* f = nullptr;
    if (fopen_s(&f, "memprobe.log", "a") == 0 && f) {
        fwprintf(f, L"%ls", buf);
        fclose(f);
    }
}

// Recorded by the DLL through GetProcAddress("SmfProbeHook") on the host.
extern "C" __declspec(dllexport) void __cdecl SmfProbeHook(unsigned where,
                                                          const void* dst,
                                                          const void* src,
                                                          size_t bytes) {
    g_probeActive = 1;
    g_probeWhere = where;
    g_probeDst = (DWORD)(uintptr_t)dst;
    g_probeSrc = (DWORD)(uintptr_t)src;
    g_probeLen = (DWORD)bytes;
}
