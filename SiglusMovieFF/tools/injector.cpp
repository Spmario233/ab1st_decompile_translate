// DllInjector - start a process and load a DLL into it.
//
//   DllInjector.exe <dll-path> <exe-path> [args...]
//
// Starts the target suspended, then runs LoadLibraryW inside it through a small
// hand-written stub built in the injector's own image.  Using our own stub
// avoids relying on a matching kernel32 base in the target and gives a precise
// return value, which is what the earlier CreateRemoteThread attempt lacked.
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

namespace {

// Fills `code` with a stub that runs inside the target:
//
//   SetDllDirectoryW(dir);
//   *(DWORD*)resultSlot = (DWORD)LoadLibraryW(path);   // nonzero = module base
//
// The result is written to a memory slot we read back with ReadProcessMemory, so
// the stub never has to return a value through the thread exit code.
//
// Hand-assembled x86 (all __stdcall calls, callee pops the arguments):
//   68 imm32        push dir
//   B8 imm32        mov  eax, SetDllDirectoryW
//   FF D0           call eax
//   68 imm32        push path
//   B8 imm32        mov  eax, LoadLibraryW
//   FF D0           call eax
//   A3 imm32        mov  [resultSlot], eax
//   B8 imm32        mov  eax, ExitThread
//   6A 00           push 0
//   FF D0           call eax
//   CC              int3
size_t buildStub(BYTE* code, DWORD pathRemote, DWORD dirRemote, DWORD resultRemote,
                 void* pSetDllDirectoryW, void* pLoadLibraryW, void* pExitThread) {
    BYTE* p = code;
    *p++ = 0x68; *(DWORD*)p = dirRemote; p += 4;
    *p++ = 0xB8; *(DWORD*)p = (DWORD)(uintptr_t)pSetDllDirectoryW; p += 4;
    *p++ = 0xFF; *p++ = 0xD0;
    *p++ = 0x68; *(DWORD*)p = pathRemote; p += 4;
    *p++ = 0xB8; *(DWORD*)p = (DWORD)(uintptr_t)pLoadLibraryW; p += 4;
    *p++ = 0xFF; *p++ = 0xD0;
    *p++ = 0xA3; *(DWORD*)p = resultRemote; p += 4;             // mov [result], eax
    *p++ = 0xB8; *(DWORD*)p = (DWORD)(uintptr_t)pExitThread; p += 4;
    *p++ = 0x6A; *p++ = 0x00;                                   // push 0
    *p++ = 0xFF; *p++ = 0xD0;
    *p++ = 0xCC;
    return (size_t)(p - code);
}

} // namespace

int wmain(int argc, wchar_t** argv) {
    if (argc < 3) {
        wprintf(L"usage: DllInjector.exe <dll-path> <exe-path> [args...]\n");
        return 2;
    }

    wchar_t dllFull[MAX_PATH] = { 0 };
    if (!GetFullPathNameW(argv[1], MAX_PATH, dllFull, nullptr) ||
        GetFileAttributesW(dllFull) == INVALID_FILE_ATTRIBUTES) {
        wprintf(L"dll not found: %ls\n", argv[1]);
        return 2;
    }

    wchar_t cmd[MAX_PATH * 4] = { 0 };
    wcsncpy_s(cmd, argv[2], _TRUNCATE);
    for (int i = 3; i < argc; ++i) { wcscat_s(cmd, L" "); wcscat_s(cmd, argv[i]); }

    wchar_t cwd[MAX_PATH] = { 0 };
    wcsncpy_s(cwd, argv[2], _TRUNCATE);
    wchar_t* slash = wcsrchr(cwd, L'\\');
    if (slash) *slash = 0; else wcscpy_s(cwd, L".");

    // Directory holding the DLL: passed to the target's SetDllDirectoryW so the
    // DLL's own dependencies (the FFmpeg libraries) resolve.
    wchar_t dllDir[MAX_PATH] = { 0 };
    wcsncpy_s(dllDir, dllFull, _TRUNCATE);
    wchar_t* ds = wcsrchr(dllDir, L'\\');
    if (ds) *ds = 0;

    STARTUPINFOW si = { 0 };
    PROCESS_INFORMATION pi = { 0 };
    si.cb = sizeof(si);

    if (!CreateProcessW(argv[2], cmd, nullptr, nullptr, FALSE,
                        CREATE_SUSPENDED, nullptr, cwd, &si, &pi)) {
        wprintf(L"CreateProcessW failed: %lu\n", GetLastError());
        return 3;
    }
    wprintf(L"target created suspended: pid=%lu tid=%lu\n",
            (unsigned long)pi.dwProcessId, (unsigned long)pi.dwThreadId);

    const SIZE_T pathBytes = (wcslen(dllFull) + 1) * sizeof(wchar_t);
    const SIZE_T dirBytes = (wcslen(dllDir) + 1) * sizeof(wchar_t);
    const SIZE_T total = pathBytes + dirBytes + sizeof(DWORD) + 4096;
    BYTE* remote = (BYTE*)VirtualAllocEx(pi.hProcess, nullptr, total,
                                         MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    if (!remote) {
        wprintf(L"VirtualAllocEx failed: %lu\n", GetLastError());
        TerminateProcess(pi.hProcess, 1);
        return 4;
    }
    BYTE* dirRemote = remote + pathBytes;
    BYTE* resultRemote = dirRemote + dirBytes;
    BYTE* stubRemote = resultRemote + sizeof(DWORD);

    DWORD zero = 0;
    if (!WriteProcessMemory(pi.hProcess, remote, dllFull, pathBytes, nullptr) ||
        !WriteProcessMemory(pi.hProcess, dirRemote, dllDir, dirBytes, nullptr) ||
        !WriteProcessMemory(pi.hProcess, resultRemote, &zero, sizeof(zero), nullptr)) {
        wprintf(L"WriteProcessMemory(paths) failed: %lu\n", GetLastError());
        TerminateProcess(pi.hProcess, 1);
        return 4;
    }

    BYTE stub[128];
    HMODULE k32 = GetModuleHandleW(L"kernel32.dll");
    size_t stubSize = buildStub(stub, (DWORD)(uintptr_t)remote, (DWORD)(uintptr_t)dirRemote,
                                (DWORD)(uintptr_t)resultRemote,
                                (void*)GetProcAddress(k32, "SetDllDirectoryW"),
                                (void*)GetProcAddress(k32, "LoadLibraryW"),
                                (void*)GetProcAddress(k32, "ExitThread"));
    if (!WriteProcessMemory(pi.hProcess, stubRemote, stub, stubSize, nullptr)) {
        wprintf(L"WriteProcessMemory(stub) failed: %lu\n", GetLastError());
        TerminateProcess(pi.hProcess, 1);
        return 4;
    }

    HANDLE th = CreateRemoteThread(pi.hProcess, nullptr, 0,
                                   (LPTHREAD_START_ROUTINE)stubRemote,
                                   nullptr, 0, nullptr);
    if (!th) {
        wprintf(L"CreateRemoteThread failed: %lu\n", GetLastError());
        TerminateProcess(pi.hProcess, 1);
        return 5;
    }
    DWORD w = WaitForSingleObject(th, 60000);
    DWORD rc = 0;
    GetExitCodeThread(th, &rc);
    CloseHandle(th);

    // The stub stores the LoadLibraryW result in the remote slot.
    DWORD hmod = 0;
    ReadProcessMemory(pi.hProcess, resultRemote, &hmod, sizeof(hmod), nullptr);
    wprintf(L"remote stub: wait=0x%lX thread_exit=%lu module=0x%08lX\n",
            (unsigned long)w, (unsigned long)rc, (unsigned long)hmod);
    if (!hmod) {
        wprintf(L"LoadLibraryW inside the target did not return a module handle\n");
        TerminateProcess(pi.hProcess, 1);
        return 6;
    }

    ResumeThread(pi.hThread);
    wprintf(L"injected; target running (kill the game to stop)\n");
    WaitForSingleObject(pi.hProcess, INFINITE);
    DWORD code = 0;
    GetExitCodeProcess(pi.hProcess, &code);
    wprintf(L"target exited with %lu\n", (unsigned long)code);
    CloseHandle(pi.hThread);
    CloseHandle(pi.hProcess);
    return (int)code;
}
