#include "common.h"
#include <stdarg.h>

// The log is written through a Win32 handle opened with FILE_SHARE_READ so it can
// be inspected while the game is still running (fopen_s takes an exclusive lock).
static HANDLE          g_logHandle = INVALID_HANDLE_VALUE;
static std::mutex      g_logMutex;
static std::atomic<int> g_logLevel{ SMF_LOG_INFO };
static std::atomic<bool> g_logEnabled{ false };
static wchar_t         g_logPath[MAX_PATH] = { 0 };

// Logging is a debugging aid and must leave no trace in a released patch.
// It is only enabled when the game folder contains SiglusDebugger3.dll, the
// debugger used while working on the translation.  The marker is looked up next
// to the host executable (the game folder), not in the current working
// directory, so launching the game from a shortcut cannot change the outcome.
static bool debuggerMarkerPresent(const wchar_t* moduleDir) {
    std::wstring dir;
    wchar_t host[MAX_PATH] = { 0 };
    DWORD n = GetModuleFileNameW(nullptr, host, _countof(host));
    if (n > 0 && n < _countof(host)) {
        dir.assign(host, n);
        size_t p = dir.find_last_of(L"\\/");
        if (p != std::wstring::npos) dir.resize(p);
    }
    // GetModuleFileNameW should never fail for the main module; keep a sane
    // fallback for unusual hosts.
    if (dir.empty() && moduleDir) dir = moduleDir;
    if (dir.empty()) return false;

    std::wstring marker = dir + L"\\SiglusDebugger3.dll";
    DWORD attrs = GetFileAttributesW(marker.c_str());
    return attrs != INVALID_FILE_ATTRIBUTES &&
           (attrs & FILE_ATTRIBUTE_DIRECTORY) == 0;
}

bool SmfLogIsEnabled() {
    return g_logEnabled.load(std::memory_order_relaxed);
}

static void makeDirFor(const wchar_t* file) {
    wchar_t buf[MAX_PATH];
    wcsncpy_s(buf, file, _TRUNCATE);
    for (wchar_t* p = buf; *p; ++p) {
        if (*p == L'\\' || *p == L'/') {
            wchar_t saved = *p;
            *p = 0;
            if (wcslen(buf) > 3) CreateDirectoryW(buf, nullptr);
            *p = saved;
        }
    }
}

void SmfLogInit(const wchar_t* moduleDir) {
    std::lock_guard<std::mutex> lk(g_logMutex);
    if (g_logHandle != INVALID_HANDLE_VALUE) return;

    // Without the debugger marker: do not create a log file, and do not append
    // anything to a log left over from an earlier debug session.
    if (!debuggerMarkerPresent(moduleDir)) {
        g_logEnabled.store(false, std::memory_order_relaxed);
        return;
    }
    g_logEnabled.store(true, std::memory_order_relaxed);

    // NOTE: this is a wide format string, so the argument must be %ls.  Using %s
    // here makes swprintf_s read the UTF-16 argument as ANSI, which overruns the
    // destination and corrupted memory at load time.
    swprintf_s(g_logPath, _countof(g_logPath), L"%ls\\SiglusMovieFF.log", moduleDir);
    makeDirFor(g_logPath);

    // FILE_SHARE_READ lets the log be inspected while the game is still running.
    g_logHandle = CreateFileW(g_logPath, FILE_APPEND_DATA | GENERIC_WRITE,
                              FILE_SHARE_READ | FILE_SHARE_WRITE, nullptr,
                              OPEN_ALWAYS, FILE_ATTRIBUTE_NORMAL, nullptr);
    if (g_logHandle == INVALID_HANDLE_VALUE) {
        OutputDebugStringW(L"SiglusMovieFF: could not open the log file\n");
        return;
    }
    SetFilePointer(g_logHandle, 0, nullptr, FILE_END);

    SYSTEMTIME st;
    GetLocalTime(&st);
    char head[256];
    _snprintf_s(head, sizeof(head), _TRUNCATE,
                "\n===== SiglusMovieFF %ls session %04d-%02d-%02d %02d:%02d:%02d =====\n",
                SMF_VERSION, st.wYear, st.wMonth, st.wDay, st.wHour, st.wMinute, st.wSecond);
    DWORD wrote = 0;
    WriteFile(g_logHandle, head, (DWORD)strlen(head), &wrote, nullptr);
}

void SmfLogShutdown() {
    std::lock_guard<std::mutex> lk(g_logMutex);
    if (g_logHandle != INVALID_HANDLE_VALUE) {
        CloseHandle(g_logHandle);
        g_logHandle = INVALID_HANDLE_VALUE;
    }
}

void SmfLogSetLevel(SmfLogLevel level) { g_logLevel.store(level); }

// Probes the first and last byte of a range without faulting: if the page is not
// accessible the original location is restored and we report failure.
static bool probeBytes(const void* p, size_t bytes, bool write) {
    if (!bytes) return true;
    if (!p) return false;
    char* base = (char*)p;
    char* spots[2] = { base, base + bytes - 1 };
    for (int i = 0; i < 2; ++i) {
        char* s = spots[i];
        MEMORY_BASIC_INFORMATION mbi;
        if (!VirtualQuery(s, &mbi, sizeof(mbi))) return false;
        if (mbi.State != MEM_COMMIT) return false;
        if (mbi.Protect & (PAGE_NOACCESS | PAGE_GUARD)) return false;
        if (write && !(mbi.Protect & (PAGE_READWRITE | PAGE_WRITECOPY |
                                      PAGE_EXECUTE_READWRITE | PAGE_EXECUTE_WRITECOPY)))
            return false;
    }
    return true;
}

// Optional host-provided probe (the test harness exports SmfProbeHook).  It lets
// a faulting copy be identified by its arguments without a debugger.
typedef void(__cdecl* SmfProbeFn)(unsigned where, const void* dst, const void* src, size_t bytes);
static SmfProbeFn g_probeFn = nullptr;
static LONG g_probeResolved = 0;

static void probeNotify(unsigned site, const void* dst, const void* src, size_t bytes) {
    if (InterlockedCompareExchange(&g_probeResolved, 1, 0) == 0) {
        HMODULE h = GetModuleHandleW(nullptr);
        g_probeFn = (SmfProbeFn)GetProcAddress(h, "SmfProbeHook");
    }
    if (g_probeFn) g_probeFn(site, dst, src, bytes);
    // Persist the arguments of the most recent copy so that, after a fault in
    // memcpy, the offending call site can be read from disk.
    static bool enabled = [] {
        wchar_t v[8] = { 0 };
        return GetEnvironmentVariableW(L"SIGLUSMF_MEMLOG", v, 8) && v[0] == L'1';
    }();
    if (enabled && SmfLogIsEnabled()) {
        FILE* f = nullptr;
        if (fopen_s(&f, "memcpy_last.log", "wb") == 0 && f) {
            fprintf(f, "site=%u(%s) dst=%p src=%p bytes=%llu\n",
                    site, SmfMemcpySiteName(site), dst, src, (unsigned long long)bytes);
            fclose(f);
        }
    }
}

void* SmfCheckedMemcpySite(void* dst, const void* src, size_t bytes, unsigned site) {
    probeNotify(site, dst, src, bytes);
    const char* where = SmfMemcpySiteName(site);
    if (bytes) {
        if (!dst || !src) {
            SmfLog(SMF_LOG_ERROR, "memcpy(%s): null pointer dst=%p src=%p bytes=%llu",
                   where, dst, src, (unsigned long long)bytes);
            return dst;
        }
        if (bytes > (size_t)256 * 1024 * 1024) {
            SmfLog(SMF_LOG_ERROR, "memcpy(%s): absurd size %llu (dst=%p src=%p)",
                   where, (unsigned long long)bytes, dst, src);
            return dst;
        }
        if (!probeBytes(dst, bytes, true) || !probeBytes(src, bytes, false)) {
            SmfLog(SMF_LOG_ERROR,
                   "memcpy(%s): inaccessible range dst=%p(w=%d) src=%p(r=%d) bytes=%llu",
                   where, dst, (int)probeBytes(dst, bytes, true),
                   src, (int)probeBytes(src, bytes, false), (unsigned long long)bytes);
            return dst;
        }
    }
    return memcpy(dst, src, bytes);
}

const char* SmfMemcpySiteName(unsigned site) {
    switch (site) {
    case SMF_CPY_AUDIO_FEEDER: return "audio-feeder";
    case SMF_CPY_D3D_TEXTURE:  return "d3d-texture";
    case SMF_CPY_GDI_FULL:     return "gdi-full";
    case SMF_CPY_GDI_ROW:      return "gdi-row";
    case SMF_CPY_D3D_ROW:      return "d3d-row";
    case SMF_CPY_HOST_PATCH:   return "host-patch";
    default:                   return "unknown";
    }
}

static const char* levelName(SmfLogLevel l) {
    switch (l) {
    case SMF_LOG_ERROR: return "E";
    case SMF_LOG_WARN:  return "W";
    case SMF_LOG_INFO:  return "I";
    default:            return "D";
    }
}

void SmfLog(SmfLogLevel level, const char* fmt, ...) {
    // Complete no-op when the debugger marker is absent: no file is opened or
    // written, and no debug string is emitted either.
    if (!SmfLogIsEnabled()) return;
    if (level > g_logLevel.load()) return;
    char body[2048];
    va_list ap;
    va_start(ap, fmt);
    vsnprintf_s(body, sizeof(body), _TRUNCATE, fmt, ap);
    va_end(ap);

    SYSTEMTIME st;
    GetLocalTime(&st);
    char line[2304];
    _snprintf_s(line, sizeof(line), _TRUNCATE, "[%02d:%02d:%02d.%03d][%s][t%05lu] %s\n",
                st.wHour, st.wMinute, st.wSecond, st.wMilliseconds, levelName(level),
                (unsigned long)GetCurrentThreadId(), body);

    {
        std::lock_guard<std::mutex> lk(g_logMutex);
        if (g_logHandle != INVALID_HANDLE_VALUE) {
            DWORD wrote = 0;
            WriteFile(g_logHandle, line, (DWORD)strlen(line), &wrote, nullptr);
        }
    }
    OutputDebugStringA(line);
}
