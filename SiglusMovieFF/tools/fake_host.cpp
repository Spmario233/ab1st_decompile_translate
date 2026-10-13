// FakeMovieHost - standalone harness that exercises SiglusMovieFF exactly the
// way SiglusEngine does, without needing the game.
//
//   FakeMovieHost.exe <video-file> [seconds]
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <mmsystem.h>
#include <stdio.h>
#include <string>
#include <vector>

typedef MCIERROR (WINAPI *PFN_mciSendStringW)(const wchar_t*, wchar_t*, UINT, HWND);
typedef BOOL     (WINAPI *PFN_mciGetErrorStringW)(MCIERROR, wchar_t*, UINT);

void InstallCrashFilter();

static PFN_mciSendStringW      pSend = nullptr;
static PFN_mciGetErrorStringW  pErr  = nullptr;

static void mci(const wchar_t* fmt, ...) {
    wchar_t cmd[2048];
    va_list ap; va_start(ap, fmt);
    _vsnwprintf_s(cmd, _TRUNCATE, fmt, ap);
    va_end(ap);

    wchar_t ret[512] = { 0 };
    MCIERROR e = pSend(cmd, ret, 512, nullptr);
    wprintf(L"mci> %ls\n", cmd);
    if (e) {
        wchar_t msg[512] = { 0 };
        if (pErr) pErr(e, msg, 512);
        wprintf(L"     ERROR %u: %ls\n", (unsigned)e, msg);
    } else if (ret[0]) {
        wprintf(L"     ret = %ls\n", ret);
    }
}

static LRESULT CALLBACK wndProc(HWND h, UINT m, WPARAM w, LPARAM l) {
    if (m == WM_DESTROY) { PostQuitMessage(0); return 0; }
    return DefWindowProcW(h, m, w, l);
}

int wmain(int argc, wchar_t** argv) {
    if (argc < 2) {
        wprintf(L"usage: FakeMovieHost.exe <video-file> [play-seconds]\n");
        return 2;
    }
    const wchar_t* file = argv[1];
    double seconds = (argc > 2) ? _wtof(argv[2]) : 6.0;
    InstallCrashFilter();

    // ---- load the proxy explicitly (same entry points the engine imports) ----
    HMODULE dll = LoadLibraryW(L"SiglusMovieFF.dll");
    if (!dll) {
        wprintf(L"LoadLibraryW(SiglusMovieFF.dll) failed: %lu\n", GetLastError());
        wprintf(L"(run this from the directory that contains the DLL and the FFmpeg DLLs)\n");
        return 3;
    }
    pSend = (PFN_mciSendStringW)GetProcAddress(dll, "Smf_mciSendStringW");
    pErr  = (PFN_mciGetErrorStringW)GetProcAddress(dll, "Smf_mciGetErrorStringW");
    if (!pSend || !pErr) {
        wprintf(L"missing exports in SiglusMovieFF.dll\n");
        return 4;
    }
    wprintf(L"proxy loaded: %p\n", (void*)dll);

    // ---- create the same kind of child window the engine hands to MCI ----
    WNDCLASSEXW wc = { 0 };
    wc.cbSize = sizeof(wc);
    wc.lpfnWndProc = wndProc;
    wc.hInstance = GetModuleHandleW(nullptr);
    wc.lpszClassName = L"FakeMovieHostWnd";
    wc.hCursor = LoadCursorW(nullptr, (LPCWSTR)IDC_ARROW);    wc.hbrBackground = (HBRUSH)GetStockObject(BLACK_BRUSH);
    RegisterClassExW(&wc);

    HWND hwnd = CreateWindowExW(0, wc.lpszClassName, L"FakeMovieHost - SiglusMovieFF",
                                WS_OVERLAPPEDWINDOW,
                                CW_USEDEFAULT, CW_USEDEFAULT, 1000, 600,
                                nullptr, nullptr, wc.hInstance, nullptr);
    if (!hwnd) { wprintf(L"CreateWindowExW failed\n"); return 5; }
    ShowWindow(hwnd, SW_SHOW);
    UpdateWindow(hwnd);

    // ---- drive MCI the way the engine does ----
    // The engine builds "<base>\\mov\\<name>.<ext>" and passes it to open with a
    // device type selected from #MOVIE_TYPE (1 -> MPEGVideo in this build).
    mci(L"open \"%ls\" type MPEGVideo alias SiglusMCIMovie wait", file);
    mci(L"window SiglusMCIMovie handle %llu wait", (unsigned long long)(uintptr_t)hwnd);
    mci(L"put SiglusMCIMovie destination at 0 0 1000 600 wait");
    mci(L"setaudio SiglusMCIMovie left volume to 1000");
    mci(L"setaudio SiglusMCIMovie right volume to 1000");
    mci(L"play SiglusMCIMovie");

    // ---- pump messages and poll status like the engine's wait loop ----
    const DWORD t0 = GetTickCount();
    double lastReport = -1.0;
    while ((GetTickCount() - t0) < (DWORD)(seconds * 1000)) {
        MSG msg;
        while (PeekMessageW(&msg, nullptr, 0, 0, PM_REMOVE)) {
            TranslateMessage(&msg);
            DispatchMessageW(&msg);
        }
        double el = (GetTickCount() - t0) / 1000.0;
        if (el - lastReport >= 0.5) {
            lastReport = el;
            wchar_t mode[64] = { 0 }, pos[64] = { 0 }, len[64] = { 0 };
            pSend(L"status SiglusMCIMovie mode wait", mode, 64, nullptr);
            pSend(L"status SiglusMCIMovie position", pos, 64, nullptr);
            pSend(L"status SiglusMCIMovie length", len, 64, nullptr);
            wprintf(L"  t=%5.1fs  mode=%-9ls position=%-7ls length=%ls\n", el, mode, pos, len);
        }
        Sleep(10);
    }

    mci(L"status SiglusMCIMovie mode wait");
    mci(L"close SiglusMCIMovie wait");

    DestroyWindow(hwnd);
    FreeLibrary(dll);
    wprintf(L"done\n");
    return 0;
}
