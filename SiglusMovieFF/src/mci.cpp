#include "mci.h"
#include <algorithm>

// ---------------------------------------------------------------------------
// Command grammar helpers
// ---------------------------------------------------------------------------

namespace {

std::wstring toLower(const std::wstring& s) {
    std::wstring r = s;
    for (wchar_t& c : r) c = (wchar_t)towlower(c);
    return r;
}

std::wstring trim(const std::wstring& s) {
    size_t a = 0, b = s.size();
    while (a < b && iswspace(s[a])) ++a;
    while (b > a && iswspace(s[b - 1])) --b;
    return s.substr(a, b - a);
}

// MCI command strings look like:  open "path" type mpegvideo alias X wait
// We only need a loose tokeniser that understands double-quoted strings.
struct Token {
    std::wstring text;
    bool quoted = false;
};

std::vector<Token> tokenize(const std::wstring& cmd) {
    std::vector<Token> out;
    size_t i = 0;
    const size_t n = cmd.size();
    while (i < n) {
        while (i < n && iswspace(cmd[i])) ++i;
        if (i >= n) break;
        if (cmd[i] == L'"') {
            ++i;
            std::wstring s;
            while (i < n && cmd[i] != L'"') s += cmd[i++];
            if (i < n) ++i;
            out.push_back({ s, true });
        } else if (cmd[i] == L'\'') {
            ++i;
            std::wstring s;
            while (i < n && cmd[i] != L'\'') s += cmd[i++];
            if (i < n) ++i;
            out.push_back({ s, true });
        } else {
            std::wstring s;
            while (i < n && !iswspace(cmd[i])) s += cmd[i++];
            out.push_back({ s, false });
        }
    }
    return out;
}

const std::wstring* valueAfter(const std::vector<Token>& t, const wchar_t* key) {
    for (size_t i = 0; i + 1 < t.size(); ++i) {
        if (toLower(t[i].text) == key) return &t[i + 1].text;
    }
    return nullptr;
}

bool hasWord(const std::vector<Token>& t, const wchar_t* key, size_t from = 0) {
    for (size_t i = from; i < t.size(); ++i)
        if (toLower(t[i].text) == key) return true;
    return false;
}

uint64_t parseInt(const std::wstring& s, uint64_t def = 0) {
    wchar_t* end = nullptr;
    unsigned long long v = _wcstoui64(s.c_str(), &end, 10);
    if (end == s.c_str()) return def;
    return v;
}

std::wstring format(const wchar_t* fmt, ...) {
    wchar_t buf[512];
    va_list ap;
    va_start(ap, fmt);
    int n = _vsnwprintf_s(buf, _countof(buf), _TRUNCATE, fmt, ap);
    va_end(ap);
    if (n < 0) {
        // Truncated or failed: make sure the buffer is terminated and usable.
        buf[_countof(buf) - 1] = 0;
    }
    return std::wstring(buf);
}

// Copies a wide string into an MCI output buffer, tolerating a zero length and
// always terminating.
void copyOut(wchar_t* dst, UINT len, const wchar_t* src) {
    if (!dst || len == 0) return;
    if (!src) { dst[0] = 0; return; }
    size_t n = wcslen(src);
    if (n >= len) n = (size_t)len - 1;
    if (n) memcpy(dst, src, n * sizeof(wchar_t));
    dst[n] = 0;
}

} // namespace

// ---------------------------------------------------------------------------

SmfMci& SmfMci::instance() {
    static SmfMci inst;
    return inst;
}

SmfMci::Track* SmfMci::find(const std::wstring& alias) {
    std::wstring a = toLower(alias);
    for (Track* t : m_tracks)
        if (toLower(t->alias) == a) return t;
    return nullptr;
}

void SmfMci::shutdown() {
    std::lock_guard<std::mutex> lk(m_mtx);
    for (Track* t : m_tracks) closeTrack(t);
    m_tracks.clear();
}

void SmfMci::closeTrack(Track* t) {
    if (!t) return;
    if (t->player) { t->player->close(); delete t->player; t->player = nullptr; }
    if (t->video)  { t->video->destroy(); delete t->video; t->video = nullptr; }
    delete t;
}

SmfMci::Track* SmfMci::open(const std::wstring& path, const std::wstring& type,
                            const std::wstring& alias, MCIERROR* err) {
    *err = 0;

    // If a track with this alias already exists, close it first (MCI semantics:
    // opening an existing alias is an error, but being forgiving here is safer
    // for a game that reopens the same movie).
    if (Track* old = find(alias)) {
        m_tracks.erase(std::remove(m_tracks.begin(), m_tracks.end(), old), m_tracks.end());
        closeTrack(old);
    }

    DWORD attrs = GetFileAttributesW(path.c_str());
    if (attrs == INVALID_FILE_ATTRIBUTES) {
        SMF_ERR("open: file not found: %ls", path.c_str());
        *err = MCIERR_FILE_NOT_FOUND;
        return nullptr;
    }
    if (attrs & FILE_ATTRIBUTE_DIRECTORY) {
        SMF_ERR("open: path is a directory: %ls", path.c_str());
        *err = MCIERR_FILE_NOT_FOUND;
        return nullptr;
    }

    Track* t = new Track();
    t->alias = alias;
    t->path = path;

    // Map the MCI "type" to a device index the way the engine's own switch does:
    //   avivideo -> 1, mpegvideo -> 2, and the remaining exotic devices -> 3/4.
    std::wstring ty = toLower(type);
    if (ty == L"avivideo")       t->deviceParam = 1;
    else if (ty == L"mpegvideo") t->deviceParam = 2;
    else if (ty == L"digitalvideo") t->deviceParam = 3;
    else                          t->deviceParam = 4;

    t->player = new SmfPlayer();
    std::string e;
    if (!t->player->open(path, &e)) {
        SMF_ERR("open failed: %ls: %s", path.c_str(), e.c_str());
        delete t->player; delete t;
        *err = MCIERR_DEVICE_OPEN;
        return nullptr;
    }
    // start() opens the container/codecs on the reader thread and waits for the
    // result, so the frame size is known before "window ... handle" arrives.
    if (!t->player->start()) {
        SMF_ERR("open: failed to start decoder threads: %s", t->player->lastError().c_str());
        delete t->player; delete t;
        *err = MCIERR_DEVICE_OPEN;
        return nullptr;
    }

    // The video backend is created lazily in "window ... handle" once we know the
    // real frame size; a placeholder is allocated here so the pointer is valid.
    t->video = new SmfVideoOut();
    t->player->setVideoOut(t->video);
    t->opened = true;
    m_tracks.push_back(t);

    SMF_INFO("open ok: '%ls' type=%ls (device %d) alias=%ls  %dx%d %.3f fps %lld ms",
             path.c_str(), type.c_str(), t->deviceParam, alias.c_str(),
             t->player->width(), t->player->height(), t->player->frameRate(),
             (long long)t->player->durationMs());
    return t;
}

SmfMci::Track* SmfMci::openFromCmdline(const std::wstring& spec, const std::wstring& type,
                                       MCIERROR* err) {
    // spec is either a plain filename or a "c:\dir\file.wmv" style path.
    std::wstring path = spec;
    if (path.find(L':') == std::wstring::npos && path.find(L'\\') == std::wstring::npos) {
        // Bare name: let MCI's usual search find it next to the executable.
        wchar_t exe[MAX_PATH] = { 0 };
        GetModuleFileNameW(nullptr, exe, MAX_PATH);
        std::wstring dir(exe);
        size_t p = dir.find_last_of(L'\\');
        if (p != std::wstring::npos) dir = dir.substr(0, p + 1);
        path = dir + spec;
    }
    return open(path, type, L"", err);
}

// ---------------------------------------------------------------------------
// mciSendStringW
// ---------------------------------------------------------------------------

MCIERROR SmfMci::sendString(const wchar_t* command, wchar_t* ret, UINT retLen, HWND cbWnd) {
    SMF_DBG("MCICALL: %ls", command ? command : L"(null)");
    if (ret && retLen) ret[0] = 0;
    if (!command) return MCIERR_NULL_PARAMETER_BLOCK;

    std::wstring cmd = trim(command);
    if (cmd.empty()) return MCIERR_NULL_PARAMETER_BLOCK;

    std::vector<Token> tok = tokenize(cmd);
    if (tok.empty()) return MCIERR_NULL_PARAMETER_BLOCK;

    const std::wstring verb = toLower(tok[0].text);
    SMF_DBG("mci: %ls", cmd.c_str());

    std::lock_guard<std::mutex> lk(m_mtx);

    // ---------------------------------------------------------------- open ---
    if (verb == L"open") {
        if (tok.size() < 2) return MCIERR_MISSING_PARAMETER;

        // MCI allows: open "file" [type T] [alias A] [wait] [shareable]
        // and also   open new type waveaudio alias A  (not used by Siglus).
        std::wstring spec = tok[1].text;
        if (toLower(spec) == L"new") {
            SMF_WARN("mci open new ... is not supported");
            return MCIERR_UNSUPPORTED_FUNCTION;
        }
        const std::wstring* type = valueAfter(tok, L"type");
        std::wstring ty = type ? *type : L"";
        const std::wstring* alias = valueAfter(tok, L"alias");
        std::wstring al = alias ? *alias : L"";

        MCIERROR err = 0;
        if (!open(spec, ty, al, &err) && err == 0) err = MCIERR_DEVICE_OPEN;
        return err;
    }

    // Everything else addresses an existing alias.
    const std::wstring& alias = tok[1].text;
    Track* t = find(alias);
    if (!t) {
        // Not ours: this may be an MCI command for a device the game opened
        // through real MCI before we hooked in.  Return an error rather than
        // silently doing nothing.
        SMF_WARN("mci: unknown alias '%ls' for command '%ls'", alias.c_str(), cmd.c_str());
        return MCIERR_DEVICE_NOT_INSTALLED;
    }

    // -------------------------------------------------------------- window ---
    if (verb == L"window") {
        // window <alias> handle <hwnd> [wait]   |   window <alias> state show
        if (tok.size() >= 4 && toLower(tok[2].text) == L"handle") {
            HWND hwnd = (HWND)(uintptr_t)parseInt(tok[3].text);
            if (!IsWindow(hwnd)) { SMF_ERR("window: bad hwnd %p", (void*)hwnd); return MCIERR_INVALID_DEVICE_ID; }
            if (!t->player->attachVideo(hwnd, 0, 0, 0, 0)) { SMF_ERR("window: attachVideo failed"); return MCIERR_NO_WINDOW; }
            return 0;
        }
        if (hasWord(tok, L"state")) return 0;      // we are always "show"n
        return 0;
    }

    // ----------------------------------------------------------------- put ---
    if (verb == L"put") {
        // put <alias> destination at X Y W H [wait]
        if (toLower(tok[2].text) == L"destination") {
            std::vector<uint64_t> nums;
            for (size_t i = 3; i < tok.size(); ++i) {
                const std::wstring& w = tok[i].text;
                if (!w.empty() && (iswdigit(w[0]) || w[0] == L'-'))
                    nums.push_back(parseInt(w));
            }
            if (nums.size() >= 4) {
                t->player->setDestination((int)nums[0], (int)nums[1], (int)nums[2], (int)nums[3]);
            } else if (nums.size() == 2) {
                t->player->setDestination((int)nums[0], (int)nums[1], 0, 0);
            }
            return 0;
        }
        if (hasWord(tok, L"source")) return 0;     // not used
        return 0;
    }

    // ---------------------------------------------------------------- play ---
    if (verb == L"play") {
        if (!t->player->hasVideoOut()) {
            // The engine normally sends "window ... handle" first; if it has not,
            // fall back to a top-level window so something still shows.
            HWND h = m_engineWindow;
            if (!h) h = GetActiveWindow();
            if (h) {
                SMF_WARN("play before window assignment; using fallback window %p", (void*)h);
                t->player->attachVideo(h, 0, 0, 0, 0);
            } else {
                SMF_ERR("play: no window available");
                return MCIERR_NO_WINDOW;
            }
        }
        // Optional "from N" / "to N" clauses (milliseconds in MCI).
        const std::wstring* from = valueAfter(tok, L"from");
        if (from) t->player->seekMs((int64_t)parseInt(*from));
        t->ended = false;
        t->player->play();
        return 0;
    }

    // ---------------------------------------------------------------- stop ---
    if (verb == L"stop") {
        t->player->stop();
        t->ended = true;
        return 0;
    }

    // --------------------------------------------------------------- pause ---
    if (verb == L"pause" || verb == L"resume") {
        if (verb == L"pause") t->player->pause();
        else                  t->player->play();
        return 0;
    }

    // ---------------------------------------------------------------- seek ---
    if (verb == L"seek") {
        const std::wstring* to = valueAfter(tok, L"to");
        if (to) {
            uint64_t v = parseInt(*to);
            if (hasWord(tok, L"start"))      t->player->seekMs((int64_t)v);
            else if (hasWord(tok, L"end") || hasWord(tok, L"stop"))
                                             t->player->seekMs(t->player->durationMs() - (int64_t)v);
            else                             t->player->seekMs((int64_t)v);
        }
        return 0;
    }

    // --------------------------------------------------------- setaudio etc ---
    if (verb == L"setaudio") {
        const std::wstring* to = valueAfter(tok, L"to");
        if (to) {
            // MCI volume is 0..1000; our mixer wants 0..1.
            uint64_t v = parseInt(*to);
            if (v > 1000) v = 1000;
            t->player->setVolume((float)v / 1000.0f);
        }
        return 0;
    }
    if (verb == L"set" || verb == L"setvideo") {
        const std::wstring* audio = valueAfter(tok, L"audio");
        if (audio && *audio == L"off") t->player->setVolume(0.0f);
        return 0;
    }

    // -------------------------------------------------------------- status ---
    if (verb == L"status") {
        if (tok.size() < 3) {
            SMF_WARN("mci: malformed status command '%ls'", cmd.c_str());
            copyOut(ret, retLen, L"");
            return 0;
        }
        const std::wstring what = toLower(tok[2].text);
        SMF_DBG("mci: status '%ls' (ret=%p len=%u)", what.c_str(), (void*)ret, retLen);
        if (what == L"mode") {
            std::wstring m;
            switch (t->player->state()) {
            case SmfState::Playing:     m = L"playing";   break;
            case SmfState::Paused:      m = L"paused";    break;
            case SmfState::EndOfStream: m = L"stopped";   break;
            case SmfState::Opening:     m = L"not ready"; break;
            case SmfState::Stopped:
            case SmfState::Idle:
            default:                    m = L"stopped";   break;
            }
            copyOut(ret, retLen, m.c_str());
            return 0;
        }
        if (what == L"length" || what == L"position") {
            int64_t v = (what == L"length") ? t->player->durationMs() : t->player->positionMs();
            wchar_t tmp[64];
            _snwprintf_s(tmp, _countof(tmp), _TRUNCATE, L"%lld", (long long)v);
            copyOut(ret, retLen, tmp);
            return 0;
        }
        if (what == L"ready") {
            copyOut(ret, retLen, L"true");
            return 0;
        }
        if (what == L"window") {
            wchar_t tmp[64];
            _snwprintf_s(tmp, _countof(tmp), _TRUNCATE, L"%llu",
                         (unsigned long long)(uintptr_t)t->player->videoWindow());
            copyOut(ret, retLen, tmp);
            return 0;
        }
        copyOut(ret, retLen, L"");
        return 0;
    }

    // --------------------------------------------------------------- close ---
    if (verb == L"close") {
        m_tracks.erase(std::remove(m_tracks.begin(), m_tracks.end(), t), m_tracks.end());
        closeTrack(t);
        SMF_INFO("close alias '%ls'", alias.c_str());
        return 0;
    }

    // -------------------------------------------------------------- others ---
    if (verb == L"info") {
        const std::wstring what = toLower(tok[2].text);
        wchar_t tmp[64] = { 0 };
        if (what == L"width") {
            _snwprintf_s(tmp, _countof(tmp), _TRUNCATE, L"%d", t->player->width());
            copyOut(ret, retLen, tmp);
        } else if (what == L"height") {
            _snwprintf_s(tmp, _countof(tmp), _TRUNCATE, L"%d", t->player->height());
            copyOut(ret, retLen, tmp);
        } else if (what == L"filename") {
            copyOut(ret, retLen, t->path.c_str());
        } else {
            copyOut(ret, retLen, L"");
        }
        return 0;
    }

    if (verb == L"capability" || verb == L"where" || verb == L"update") return 0;

    SMF_WARN("mci: unhandled command '%ls'", cmd.c_str());
    return MCIERR_UNSUPPORTED_FUNCTION;
}

BOOL SmfMci::getErrorString(MCIERROR err, wchar_t* buf, UINT len) {
    if (!buf || !len) return FALSE;
    buf[0] = 0;
    if (err == 0) { copyOut(buf, len, L"No error"); return TRUE; }

    // Let winmm supply the canonical text for standard MCI error codes.
    HMODULE h = GetModuleHandleW(L"winmm.dll");
    if (h) {
        typedef BOOL (WINAPI* PFN)(MCIERROR, wchar_t*, UINT);
        PFN p = (PFN)GetProcAddress(h, "mciGetErrorStringW");
        if (p && p(err, buf, len)) return TRUE;
    }
    wchar_t tmp[64];
    _snwprintf_s(tmp, _countof(tmp), _TRUNCATE, L"MCI error %u", (unsigned)err);
    copyOut(buf, len, tmp);
    return TRUE;
}
