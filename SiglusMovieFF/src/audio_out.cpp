// Audio output.
//
// Backend is DirectSound (the same API SiglusEngine itself uses): a small
// circular secondary buffer is kept topped up by a feeder thread, and the
// buffer's play cursor provides the audio clock used for A/V synchronisation.
//
// waveOut was tried first and rejected: in this environment it routes through
// wdmaud, and driving waveOutWrite/waveOutUnprepareHeader from a feeder thread
// corrupted memory intermittently (the fault landed in the CRT's memcpy).
#include "audio_out.h"

#define DIRECTSOUND_VERSION 0x0800
#define INITGUID
#include <dsound.h>

#pragma comment(lib, "dsound.lib")
#pragma comment(lib, "ole32.lib")

namespace {

const DWORD kRingBytes  = 48000 * 4 / 2;   // 0.5 s of 48 kHz stereo PCM16
const DWORD kChunkBytes = 4800 * 4;        // 100 ms per refill
const DWORD kLowWater   = 4800 * 4;        // refill when under 100 ms remain

int64_t bytesToFrames(int64_t bytes, int blockAlign) {
    return blockAlign ? bytes / blockAlign : 0;
}

} // namespace

SmfAudioOut::SmfAudioOut() {}

SmfAudioOut::~SmfAudioOut() { close(); }

bool SmfAudioOut::open(int sampleRate, int channels, int bytesPerSample) {
    if (m_ds) return true;
    if (channels != 2 || bytesPerSample != 2) {
        SMF_WARN("audio: only 16-bit stereo is supported (asked %d ch / %d bytes)",
                 channels, bytesPerSample);
    }

    m_rate = sampleRate;
    m_channels = channels;
    m_blockAlign = channels * bytesPerSample;

    HMODULE hds = LoadLibraryW(L"dsound.dll");
    if (!hds) { SMF_ERR("audio: dsound.dll not available (%lu)", GetLastError()); return false; }

    // NOTE: DirectSoundCreate8 takes exactly three parameters:
    //   HRESULT DirectSoundCreate8(LPCGUID pcGuidDevice, LPDIRECTSOUND8 *ppDS8, LPUNKNOWN pUnkOuter)
    // Declaring it with an extra parameter makes the __stdcall argument layout
    // wrong, so ppDS8 picks up garbage and the callee writes through it.
    typedef HRESULT(WINAPI* PFN_DS8)(LPCGUID, IDirectSound8**, LPUNKNOWN);
    PFN_DS8 pCreate8 = (PFN_DS8)GetProcAddress(hds, "DirectSoundCreate8");
    if (!pCreate8) pCreate8 = (PFN_DS8)GetProcAddress(hds, (LPCSTR)11);   // ordinal fallback

    HRESULT hr = S_OK;
    if (pCreate8) {
        hr = pCreate8(nullptr, &m_ds, nullptr);
    } else {
        typedef HRESULT(WINAPI* PFN_DS)(LPCGUID, IDirectSound**, LPUNKNOWN);
        PFN_DS pCreate = (PFN_DS)GetProcAddress(hds, "DirectSoundCreate");
        IDirectSound* ds1 = nullptr;
        if (pCreate) hr = pCreate(nullptr, &ds1, nullptr);
        if (SUCCEEDED(hr) && ds1) {
            hr = ds1->QueryInterface(IID_IDirectSound8, (void**)&m_ds);
            ds1->Release();
        }
    }
    if (FAILED(hr) || !m_ds) {
        SMF_ERR("audio: DirectSoundCreate8 failed hr=0x%08lX", (unsigned long)hr);
        m_ds = nullptr;
        return false;
    }

    // The cooperative level needs a real top-level window.  DSSCL_PRIORITY is
    // only needed for the primary buffer, which we don't use, so failing here is
    // harmless and we simply continue at normal priority.
    HWND coop = GetForegroundWindow();
    if (coop) {
        hr = m_ds->SetCooperativeLevel(coop, DSSCL_PRIORITY);
        if (FAILED(hr))
            SMF_WARN("audio: SetCooperativeLevel(DSSCL_PRIORITY) hr=0x%08lX (continuing)",
                     (unsigned long)hr);
    }

    WAVEFORMATEX wf = { 0 };
    wf.wFormatTag      = WAVE_FORMAT_PCM;
    wf.nChannels       = (WORD)m_channels;
    wf.nSamplesPerSec  = (DWORD)m_rate;
    wf.wBitsPerSample  = 16;
    wf.nBlockAlign     = (WORD)m_blockAlign;
    wf.nAvgBytesPerSec = wf.nSamplesPerSec * wf.nBlockAlign;

    m_bufBytes = kRingBytes - (kRingBytes % (DWORD)m_blockAlign);
    DSBUFFERDESC desc = { 0 };
    desc.dwSize        = sizeof(desc);
    desc.dwFlags       = DSBCAPS_GETCURRENTPOSITION2 | DSBCAPS_GLOBALFOCUS;
    desc.dwBufferBytes = m_bufBytes;
    desc.lpwfxFormat   = &wf;

    hr = m_ds->CreateSoundBuffer(&desc, &m_buf, nullptr);
    if (FAILED(hr) || !m_buf) {
        SMF_ERR("audio: CreateSoundBuffer failed hr=0x%08lX", (unsigned long)hr);
        m_buf = nullptr;
        m_ds->Release(); m_ds = nullptr;
        return false;
    }

    // Silence the ring so nothing stale is ever played.
    void* p1 = nullptr; void* p2 = nullptr;
    DWORD n1 = 0, n2 = 0;
    if (SUCCEEDED(m_buf->Lock(0, m_bufBytes, &p1, &n1, &p2, &n2, DSBLOCK_ENTIREBUFFER))) {
        if (p1 && n1) memset(p1, 0, n1);
        if (p2 && n2) memset(p2, 0, n2);
        m_buf->Unlock(p1, n1, p2, n2);
    }

    m_writePos = 0;
    m_primed = 0;
    m_writtenBytes = 0;
    m_cursorBaseBytes = 0;
    m_playedFrames = 0;
    m_paused = false;
    m_restartReq = 0;
    m_clearReq = 0;

    // The secondary buffer is started from the feeder thread (below), which is
    // the only thread that ever calls into DirectSound from then on.  Calling
    // Play/Stop/Lock from several threads is what corrupts the device state.
    m_run = true;
    m_thread = std::thread(&SmfAudioOut::feederLoop, this);

    SMF_INFO("audio: DirectSound ok, %d Hz %d ch, ring %lu bytes",
             m_rate, m_channels, (unsigned long)m_bufBytes);
    return true;
}

void SmfAudioOut::close() {
    if (!m_ds && !m_thread.joinable()) return;
    m_run = false;
    m_cv.notify_all();
    if (m_thread.joinable()) m_thread.join();

    if (m_buf) { m_buf->Stop(); m_buf->Release(); m_buf = nullptr; }
    if (m_ds)  { m_ds->Release(); m_ds = nullptr; }
    {
        std::lock_guard<std::mutex> lk(m_mtx);
        m_queue.clear();
    }
    SMF_INFO("audio: closed");
}

void SmfAudioOut::clear() {
    if (!m_buf) return;
    {
        std::lock_guard<std::mutex> lk(m_mtx);
        m_queue.clear();
    }
    // Hand the work to the feeder thread; DirectSound is only ever touched there.
    m_clearReq = 1;
    m_cv.notify_all();
}

bool SmfAudioOut::push(const void* data, size_t bytes) {
    if (!m_buf || !data || !bytes) return false;

    const float vol = m_volume.load();
    std::lock_guard<std::mutex> lk(m_mtx);
    if (m_queue.size() > (size_t)m_rate * m_blockAlign) return false;   // 1 s backlog

    if (vol >= 0.999f) {
        const char* p = (const char*)data;
        m_queue.insert(m_queue.end(), p, p + bytes);
    } else if (vol <= 0.001f) {
        m_queue.resize(m_queue.size() + bytes, 0);
    } else {
        const int16_t* p = (const int16_t*)data;
        size_t n = bytes / sizeof(int16_t);
        size_t base = m_queue.size();
        m_queue.resize(base + bytes);
        int16_t* out = (int16_t*)(&m_queue[base]);
        for (size_t i = 0; i < n; ++i) {
            int v = (int)(p[i] * vol);
            if (v > 32767) v = 32767; else if (v < -32768) v = -32768;
            out[i] = (int16_t)v;
        }
    }
    m_cv.notify_all();
    return true;
}

size_t SmfAudioOut::bufferedBytes() const {
    std::lock_guard<std::mutex> lk(m_mtx);
    return m_queue.size();
}

bool SmfAudioOut::pump() {
    if (!m_buf) return false;

    DWORD play = 0, write = 0;
    if (FAILED(m_buf->GetCurrentPosition(&play, &write))) return false;

    DWORD delta = (play - (DWORD)m_cursorBaseBytes.load() + m_bufBytes) % m_bufBytes;
    DWORD freeBytes = m_bufBytes - delta;
    if (freeBytes < kLowWater) return true;            // enough buffered already

    DWORD want = freeBytes;
    if (want > kChunkBytes) want = kChunkBytes;
    want -= want % (DWORD)m_blockAlign;
    if (want == 0) return true;

    std::vector<char> chunk;
    {
        std::lock_guard<std::mutex> lk(m_mtx);
        if (m_queue.empty()) return true;
        size_t take = (want < m_queue.size()) ? want : m_queue.size();
        take -= take % (size_t)m_blockAlign;
        if (take == 0) return true;
        chunk.assign(m_queue.begin(), m_queue.begin() + take);
        m_queue.erase(m_queue.begin(), m_queue.begin() + take);
    }

    DWORD pos = m_writePos;
    size_t remaining = chunk.size();
    size_t offset = 0;
    while (remaining) {
        DWORD part = (DWORD)remaining;
        if (pos + part > m_bufBytes) part = m_bufBytes - pos;

        void* p1 = nullptr; void* p2 = nullptr;
        DWORD n1 = 0, n2 = 0;
        if (FAILED(m_buf->Lock(pos, part, &p1, &n1, &p2, &n2, 0))) {
            SMF_WARN("audio: buffer lock failed at %lu+%lu",
                     (unsigned long)pos, (unsigned long)part);
            break;
        }
        if (p1 && n1) SMF_MEMCPY(p1, chunk.data() + offset, n1, SMF_CPY_AUDIO_FEEDER);
        if (p2 && n2) SMF_MEMCPY(p2, chunk.data() + offset + n1, n2, SMF_CPY_AUDIO_FEEDER);
        m_buf->Unlock(p1, n1, p2, n2);

        offset += part;
        remaining -= part;
        pos = (pos + part) % m_bufBytes;
    }

    m_writePos = pos;
    m_primed += (DWORD)chunk.size();
    m_writtenBytes.fetch_add((int64_t)chunk.size());
    return true;
}

void SmfAudioOut::feederLoop() {
    SetThreadDescription(GetCurrentThread(), L"SmfAudioFeeder");

    // Bring the device up: this thread owns every DirectSound call from here on.
    if (m_buf) {
        m_buf->SetCurrentPosition(0);
        if (FAILED(m_buf->Play(0, 0, DSBPLAY_LOOPING)))
            SMF_WARN("audio: initial Play failed");
    }

    while (m_run) {
        if (m_clearReq.exchange(0)) {
            if (m_buf) {
                m_buf->Stop();
                m_buf->SetCurrentPosition(0);
                void* p1 = nullptr; void* p2 = nullptr;
                DWORD n1 = 0, n2 = 0;
                if (SUCCEEDED(m_buf->Lock(0, m_bufBytes, &p1, &n1, &p2, &n2,
                                          DSBLOCK_ENTIREBUFFER))) {
                    if (p1 && n1) memset(p1, 0, n1);
                    if (p2 && n2) memset(p2, 0, n2);
                    m_buf->Unlock(p1, n1, p2, n2);
                }
                m_writePos = 0;
                m_cursorBaseBytes = 0;
                m_writtenBytes = 0;
                m_playedFrames = 0;
                if (!m_paused.load()) m_buf->Play(0, 0, DSBPLAY_LOOPING);
            }
        }
        pump();
        std::unique_lock<std::mutex> lk(m_mtx);
        m_cv.wait_for(lk, std::chrono::milliseconds(15));
    }

    if (m_buf) m_buf->Stop();
}

int64_t SmfAudioOut::playedFrames() const {
    if (!m_buf) return 0;
    DWORD play = 0, write = 0;
    if (FAILED(m_buf->GetCurrentPosition(&play, &write))) return m_playedFrames.load();
    DWORD delta = (play - (DWORD)m_cursorBaseBytes.load() + m_bufBytes) % m_bufBytes;
    int64_t frames = bytesToFrames((int64_t)delta, m_blockAlign);
    const_cast<SmfAudioOut*>(this)->m_playedFrames.store(frames);
    return frames;
}

void SmfAudioOut::setVolume(float v) {
    if (v < 0.f) v = 0.f;
    if (v > 1.f) v = 1.f;
    m_volume = v;
    // The gain is applied on push(), so no buffer volume call is made here (that
    // would double-apply it).
}

void SmfAudioOut::setPaused(bool paused) {
    m_paused = paused;
    // DirectSound is only touched by the feeder thread; it observes m_paused.
    if (!m_buf) return;
    if (!paused) m_cv.notify_all();
}
