// Audio output.
//
// Backend is DirectSound (the same API SiglusEngine itself uses): a small
// circular secondary buffer is kept topped up by a feeder thread, and the
// buffer's play cursor provides the audio clock used for A/V synchronisation.
//
// waveOut was tried first and rejected: in this environment it routes through
// wdmaud and the combination of waveOutWrite/waveOutUnprepareHeader from a
// feeder thread corrupted memory intermittently (see SmfAudioOut history).
#pragma once
#include "common.h"

struct IDirectSound8;
struct IDirectSoundBuffer;

class SmfAudioOut {
public:
    SmfAudioOut();
    ~SmfAudioOut();

    // Opens the device for interleaved PCM16 at the given rate.
    bool open(int sampleRate = 48000, int channels = 2, int bytesPerSample = 2);
    void close();

    bool isOpen() const { return m_ds != nullptr; }

    // Queues PCM16 interleaved data.  Returns false when the ring has no room.
    bool push(const void* data, size_t bytes);

    // Drops all queued and unplayed audio (used on seek / stop).
    void clear();

    // Frames (per-channel samples) the device has played since the last clear.
    int64_t playedFrames() const;
    size_t  bufferedBytes() const;

    void setVolume(float v);          // 0.0 .. 1.0
    float volume() const { return m_volume; }
    void setPaused(bool paused);
    bool isPaused() const { return m_paused; }

    const char* backendName() const { return "DirectSound"; }

private:
    bool pump();                      // top the hardware buffer up; caller holds no lock
    void feederLoop();

    IDirectSound8*     m_ds = nullptr;
    IDirectSoundBuffer* m_buf = nullptr;

    int      m_rate = 48000;
    int      m_channels = 2;
    int      m_blockAlign = 4;

    // Ring geometry, all in bytes.
    DWORD    m_bufBytes = 0;          // hardware buffer size (multiple of 4)
    DWORD    m_writePos = 0;          // where we will write next
    DWORD    m_primed = 0;            // bytes written since the last rewind
    std::atomic<int64_t> m_writtenBytes{ 0 };   // total bytes pushed since clear
    std::atomic<int64_t> m_cursorBaseBytes{ 0 };// device position at last rewind

    mutable std::mutex      m_mtx;
    std::condition_variable m_cv;
    std::deque<char>        m_queue;  // PCM not yet copied into the ring
    std::thread             m_thread;
    std::atomic<bool>       m_run{ false };
    std::atomic<bool>       m_paused{ false };
    std::atomic<int>        m_clearReq{ 0 };
    std::atomic<int>        m_restartReq{ 0 };
    std::atomic<float>      m_volume{ 1.0f };
    std::atomic<int64_t>    m_playedFrames{ 0 };
};
