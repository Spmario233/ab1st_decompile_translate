// FFmpeg-backed movie player: demux + decode threads, A/V sync, seek, volume.
#pragma once
#include "common.h"
#include "audio_out.h"
#include "video_out.h"
#include "thread_util.h"

#include <iostream>
#include <fstream>
#include <chrono>
#include <sstream>

enum class SmfState { Idle, Opening, Playing, Paused, Stopped, EndOfStream, Error };

class SmfPlayer {
public:
    SmfPlayer();
    ~SmfPlayer();

    bool open(const std::wstring& path, std::string* error);
    void close();

    // Opens the container and codecs.  Called from the MCI "open" command, which
    // happens on the engine's main thread; it is synchronous so that the frame
    // size is known before the movie window is attached.
    bool openCodecs(std::string* error);

    // Brings up the decode thread and waits until the container open attempt has
    // finished, so the frame size is known on return.  Used by MCI "open".
    bool start();

    void readerLoopThread();            // open + signal + read, all on one thread

    // Starts / resumes playback.
    void play();
    void pause();
    void stop();                       // stop and rewind to the beginning
    void seekMs(int64_t ms);

    void setVolume(float v);
    float volume() const { return m_audio.volume(); }

    void setVideoOut(SmfVideoOut* vo) { m_vout = vo; }

    // Brings up the video backend.  Must be called after openCodecs() so the real
    // frame size is known.
    bool attachVideo(HWND hwnd, int dstX, int dstY, int dstW, int dstH);
    void setDestination(int x, int y, int w, int h);
    bool hasVideoOut() const;
    HWND videoWindow() const;

    SmfState state() const { return m_state.load(); }
    bool  isPlaying() const {
        SmfState s = m_state.load();
        return s == SmfState::Playing;
    }
    bool  atEnd() const { return m_state.load() == SmfState::EndOfStream; }

    int64_t positionMs() const;
    int64_t durationMs() const { return m_durationMs; }
    int     width() const { return m_width; }
    int     height() const { return m_height; }
    double  frameRate() const { return m_frameRate; }

    const std::wstring& path() const { return m_path; }
    std::string lastError() const { return m_lastError; }

private:
    struct VFrame {
        std::vector<uint8_t> data;      // BGRA
        int64_t ptsMs = 0;
        int     serial = 0;
    };
    struct APacket {
        std::vector<uint8_t> pcm;       // interleaved PCM16 @ out rate
        int64_t ptsMs = 0;
        int     serial = 0;
        int     frames = 0;
    };

    void readerLoop();
    void presenterLoop();
    void audioFeedLoop();

    // Static trampolines for the CRT threads.
    static unsigned __stdcall readerEntry(void* self);
    static unsigned __stdcall presenterEntry(void* self);
    static unsigned __stdcall feederEntry(void* self);
    void flushQueues();

    int64_t masterClockMs() const;
    bool    decodeVideo(AVFrame* f, int serial, std::vector<uint8_t>& out, int64_t* ptsMs);

    // ---- containers / codecs ----
    AVFormatContext* m_fmt = nullptr;
    AVCodecContext*  m_vdec = nullptr;
    AVCodecContext*  m_adec = nullptr;
    int              m_vstream = -1;
    int              m_astream = -1;
    SwsContext*      m_sws = nullptr;
    SwrContext*      m_swr = nullptr;
    AVFrame*         m_vframe = nullptr;
    AVFrame*         m_aframe = nullptr;
    AVPacket*        m_pkt = nullptr;

    int              m_width = 0, m_height = 0;
    double           m_frameRate = 0.0;
    int64_t          m_durationMs = 0;
    AVRational       m_vtimeBase = { 0, 1 };
    AVRational       m_atimeBase = { 0, 1 };

    // ---- outputs ----
    SmfVideoOut      m_voutLocal;       // used when no external sink is set
    SmfVideoOut*     m_vout = nullptr;
    SmfAudioOut      m_audio;

    // ---- queues ----
    mutable std::mutex      m_qmtx;
    std::condition_variable m_qcvEmpty;   // signalled when a queue slot frees
    std::condition_variable m_qcvFull;    // signalled when data arrives
    std::condition_variable m_readyCv;    // signalled when the open attempt ends
    std::deque<VFrame>      m_vq;
    std::deque<APacket>     m_aq;
    static const size_t kMaxVideoQueue = 24;
    static const size_t kMaxAudioQueue = 24;

    std::vector<uint8_t>    m_convBuf;
    int                     m_ptsSerial = -1;   // for synthesised PTS
    int64_t                 m_ptsCounter = 0;
    int64_t                 m_decodedFrames = 0;
    int64_t                 m_pktCount = 0;

    // ---- threading / state ----
    SmfThread         m_reader;
    SmfThread         m_presenter;
    SmfThread         m_feeder;
    // FFmpeg's video decoders use a lot of stack (the MinGW builds especially).
    // A default 1 MB worker stack is not enough and the decoder faults on the
    // guard page, which surfaces as an access violation deep inside avcodec.
    static const size_t kDecoderStackBytes  = 32u * 1024u * 1024u;
    static const size_t kDefaultStackBytes  = 2u * 1024u * 1024u;
    std::atomic<bool> m_run{ false };
    std::atomic<SmfState> m_state{ SmfState::Idle };
    std::atomic<int>  m_serial{ 0 };
    std::atomic<int64_t> m_seekTargetMs{ -1 };
    std::atomic<int64_t> m_baseMs{ 0 };       // media time of the last flush
    std::atomic<int64_t> m_playedFrames{ 0 }; // audio frames played in this serial
    std::atomic<bool> m_eof{ false };
    std::atomic<bool> m_feederStarted{ false };

    // Wall-clock fallback used when there is no audio clock.  wallClockMs() is
    // the number of milliseconds the current serial has actually been running,
    // excluding paused time.
    LARGE_INTEGER m_qpcFreq{ {0} };
    std::atomic<int64_t> m_wallBaseQpc{ 0 };
    std::atomic<int64_t> m_pausedAtQpc{ 0 };

    int64_t qpcNow() const;
    int64_t wallClockMs() const;
    void    wallClockReset();
    void    wallClockPause();
    void    wallClockResume();
    int64_t wallClockQpcBase() const { return m_wallBaseQpc.load(); }
    void    setWallBase(int64_t v) { m_wallBaseQpc = v; }

    std::wstring m_path;
    std::string  m_lastError;
    bool         m_codecsReady = false;
    bool         m_openFailed = false;
    bool         m_shuttingDown = false;
};
