// MCI emulation: parses the mciSendStringW command grammar that SiglusEngine
// uses and drives SmfPlayer instances instead of winmm's MCI drivers.
#pragma once
#include "common.h"
#include "player.h"
#include "video_out.h"

class SmfMci {
public:
    static SmfMci& instance();

    // Drop-in replacement for winmm!mciSendStringW.
    MCIERROR sendString(const wchar_t* command, wchar_t* ret, UINT retLen, HWND cbWnd);

    // Drop-in replacement for winmm!mciGetErrorStringW.
    BOOL getErrorString(MCIERROR err, wchar_t* buf, UINT len);

    // Release everything (called on DLL unload / process exit / engine reset).
    void shutdown();

    // Optional: engine-side hook so we can learn the game window.
    void setEngineWindow(HWND h) { m_engineWindow = h; }

private:
    SmfMci() = default;
    ~SmfMci() { shutdown(); }
    SmfMci(const SmfMci&) = delete;
    SmfMci& operator=(const SmfMci&) = delete;

    struct Track {
        std::wstring alias;
        std::wstring path;
        SmfPlayer*   player = nullptr;
        SmfVideoOut* video = nullptr;
        int          deviceParam = 0;      // from the "type <t>" clause
        bool         opened = false;
        bool         ended = false;        // playback ran to the end
    };

    Track* find(const std::wstring& alias);
    Track* open(const std::wstring& path, const std::wstring& type,
                const std::wstring& alias, MCIERROR* err);
    Track* openFromCmdline(const std::wstring& spec, const std::wstring& type, MCIERROR* err);
    void closeTrack(Track* t);

    std::mutex             m_mtx;
    std::vector<Track*>    m_tracks;
    HWND                   m_engineWindow = nullptr;
    int                    m_deviceHint = 0;
};
