#include "player.h"

#pragma comment(lib, "avformat.lib")
#pragma comment(lib, "avcodec.lib")
#pragma comment(lib, "avutil.lib")
#pragma comment(lib, "swscale.lib")
#pragma comment(lib, "swresample.lib")

static int64_t tsToMs(int64_t ts, AVRational tb) {
    if (ts == AV_NOPTS_VALUE || tb.num <= 0 || tb.den <= 0) return 0;
    if (tb.den == 1000) return ts * tb.num;
    return (int64_t)((double)ts * tb.num * 1000.0 / (double)tb.den);
}

static void setError(std::string* err, const char* fmt, ...) {
    if (!err) return;
    char buf[512];
    va_list ap; va_start(ap, fmt);
    vsnprintf_s(buf, sizeof(buf), _TRUNCATE, fmt, ap);
    va_end(ap);
    *err = buf;
}

// Diagnostic switches used to isolate a fault to the decode, render or audio
// stage:  SIGLUSMF_NOPRESENT=1 disables D3D/GDI presentation,
//         SIGLUSMF_NOAUDIO=1   disables the audio device and resampler.
static bool envFlag(const wchar_t* name) {
    wchar_t buf[16] = { 0 };
    DWORD n = GetEnvironmentVariableW(name, buf, 16);
    if (n == 0 || n >= 16) return false;
    return !(buf[0] == L'0' && buf[1] == 0);
}
static bool noPresent() { static bool v = envFlag(L"SIGLUSMF_NOPRESENT"); return v; }
static bool noAudio()   { static bool v = envFlag(L"SIGLUSMF_NOAUDIO");   return v; }

// ---------------------------------------------------------------- wall clock --

int64_t SmfPlayer::qpcNow() const {
    LARGE_INTEGER t;
    QueryPerformanceCounter(&t);
    return t.QuadPart;
}

// Milliseconds since wallClockReset(), excluding paused intervals.
int64_t SmfPlayer::wallClockMs() const {
    if (!m_qpcFreq.QuadPart) return 0;
    int64_t base = m_wallBaseQpc.load();
    if (base == 0) return 0;
    int64_t end = m_pausedAtQpc.load();
    if (end == 0) end = qpcNow();          // currently running
    if (end < base) return 0;
    return (end - base) * 1000 / m_qpcFreq.QuadPart;
}

void SmfPlayer::wallClockReset() {
    if (!m_qpcFreq.QuadPart) QueryPerformanceFrequency(&m_qpcFreq);
    m_pausedAtQpc = 0;
    m_wallBaseQpc = qpcNow();
}

void SmfPlayer::wallClockPause() {
    if (m_pausedAtQpc.load() == 0) m_pausedAtQpc = qpcNow();
}

void SmfPlayer::wallClockResume() {
    int64_t pausedAt = m_pausedAtQpc.exchange(0);
    if (pausedAt && m_wallBaseQpc.load() != 0) {
        m_wallBaseQpc = m_wallBaseQpc.load() + (qpcNow() - pausedAt);
    }
}

SmfPlayer::SmfPlayer() {
    // These live for the lifetime of the object: close() is also the first thing
    // open() does, so they must not be freed there.
    m_pkt    = av_packet_alloc();
    m_vframe = av_frame_alloc();
    m_aframe = av_frame_alloc();
    if (!m_pkt || !m_vframe || !m_aframe)
        SMF_ERR("player: FFmpeg scratch allocation failed");
}

SmfPlayer::~SmfPlayer() {
    m_shuttingDown = true;
    close();
    if (m_pkt) av_packet_free(&m_pkt);
    if (m_vframe) av_frame_free(&m_vframe);
    if (m_aframe) av_frame_free(&m_aframe);
}

unsigned __stdcall SmfPlayer::readerEntry(void* self) {
    ((SmfPlayer*)self)->readerLoopThread();
    return 0;
}
unsigned __stdcall SmfPlayer::presenterEntry(void* self) {
    ((SmfPlayer*)self)->presenterLoop();
    return 0;
}
unsigned __stdcall SmfPlayer::feederEntry(void* self) {
    ((SmfPlayer*)self)->audioFeedLoop();
    return 0;
}

// ---------------------------------------------------------------------------

bool SmfPlayer::open(const std::wstring& path, std::string* error) {
    close();
    m_path = path;
    m_state = SmfState::Opening;
    // The container and codecs are opened on the reader thread (see readerLoop)
    // because libavformat keeps thread-local state set up by avformat_open_input:
    // reading from a different thread than the one that opened the context makes
    // av_read_frame fault inside avformat.
    {
        std::lock_guard<std::mutex> lk(m_qmtx);
        m_codecsReady = false;
        m_openFailed = false;
    }
    if (error) error->clear();
    SMF_INFO("movie queued: %ls", path.c_str());
    return true;
}

bool SmfPlayer::openCodecs(std::string* error) {
    m_vstream = -1;
    m_astream = -1;

    // Convert to UTF-8 for FFmpeg (it treats the input as UTF-8 on Windows).
    char u8[MAX_PATH * 4] = { 0 };
    int n = WideCharToMultiByte(CP_UTF8, 0, m_path.c_str(), -1, u8, sizeof(u8) - 1, nullptr, nullptr);
    if (n <= 0) {
        setError(error, "path conversion failed");
        m_state = SmfState::Error;
        return false;
    }

    int ret = avformat_open_input(&m_fmt, u8, nullptr, nullptr);
    if (ret < 0) {
        char eb[AV_ERROR_MAX_STRING_SIZE] = { 0 };
        av_strerror(ret, eb, sizeof(eb));
        setError(error, "avformat_open_input failed: %s", eb);
        SMF_ERR("open '%ls' -> %s", m_path.c_str(), eb);
        m_state = SmfState::Error;
        return false;
    }

    ret = avformat_find_stream_info(m_fmt, nullptr);
    if (ret < 0) {
        setError(error, "avformat_find_stream_info failed (%d)", ret);
        m_state = SmfState::Error;
        return false;
    }

    for (unsigned i = 0; i < m_fmt->nb_streams; ++i) {
        AVStream* st = m_fmt->streams[i];
        if (st->codecpar->codec_type == AVMEDIA_TYPE_VIDEO && m_vstream < 0) {
            m_vstream = (int)i;
        } else if (st->codecpar->codec_type == AVMEDIA_TYPE_AUDIO && m_astream < 0) {
            m_astream = (int)i;
        }
    }

    if (m_vstream < 0 && m_astream < 0) {
        setError(error, "no audio or video stream found");
        m_state = SmfState::Error;
        return false;
    }

    // ---- video decoder ----
    if (m_vstream >= 0) {
        AVStream* st = m_fmt->streams[m_vstream];
        const AVCodec* dec = avcodec_find_decoder(st->codecpar->codec_id);
        if (!dec) {
            setError(error, "no decoder for video codec id %d", (int)st->codecpar->codec_id);
            m_state = SmfState::Error;
            return false;
        }
        m_vdec = avcodec_alloc_context3(dec);
        avcodec_parameters_to_context(m_vdec, st->codecpar);
        // Let FFmpeg keep its default thread_type (slice+frame) and decide which
        // one this decoder actually implements.  Forcing frame threading on a
        // decoder that only supports slice threading (wmv3 among them) corrupts
        // decoder state and crashes inside avcodec.
        m_vdec->thread_count = 0;                 // auto
        ret = avcodec_open2(m_vdec, dec, nullptr);
        if (ret < 0) {
            setError(error, "avcodec_open2(video) failed (%d)", ret);
            m_state = SmfState::Error;
            return false;
        }
        SMF_INFO("video decoder '%s' threads=%d active_type=%d", dec->name,
                 m_vdec->thread_count, (int)m_vdec->active_thread_type);
        m_width = m_vdec->width;
        m_height = m_vdec->height;
        m_vtimeBase = st->time_base;
        AVRational fr = av_guess_frame_rate(m_fmt, st, nullptr);
        m_frameRate = (fr.num > 0 && fr.den > 0) ? (double)fr.num / (double)fr.den : 0.0;
        SMF_INFO("video: %s %dx%d %.3f fps (stream %d)",
                 dec->name, m_width, m_height, m_frameRate, m_vstream);
    }

    // ---- audio decoder ----
    if (m_astream >= 0) {
        AVStream* st = m_fmt->streams[m_astream];
        const AVCodec* dec = avcodec_find_decoder(st->codecpar->codec_id);
        if (!dec) {
            SMF_WARN("no decoder for audio codec id %d - continuing without audio",
                     (int)st->codecpar->codec_id);
            m_astream = -1;
        } else {
            m_adec = avcodec_alloc_context3(dec);
            avcodec_parameters_to_context(m_adec, st->codecpar);
            ret = avcodec_open2(m_adec, dec, nullptr);
            if (ret < 0) {
                SMF_WARN("avcodec_open2(audio) failed (%d) - continuing without audio", ret);
                avcodec_free_context(&m_adec);
                m_astream = -1;
            } else {
                m_atimeBase = st->time_base;
                SMF_INFO("audio: %s %d Hz %d ch", dec->name,
                         m_adec->sample_rate, m_adec->ch_layout.nb_channels);
            }
        }
    }

    m_durationMs = (m_fmt->duration != AV_NOPTS_VALUE)
        ? (int64_t)(m_fmt->duration / (AV_TIME_BASE / 1000))
        : 0;

    // ---- scaler for BGRA output ----
    if (m_vstream >= 0) {
        m_sws = sws_getContext(m_width, m_height, m_vdec->pix_fmt,
                               m_width, m_height, AV_PIX_FMT_BGRA,
                               SWS_BILINEAR, nullptr, nullptr, nullptr);
        if (!m_sws) {
            setError(error, "sws_getContext failed");
            m_state = SmfState::Error;
            return false;
        }
        m_convBuf.resize((size_t)m_width * m_height * 4 + 64);
    }

    // ---- resampler -> 48 kHz stereo s16 ----
    if (m_astream >= 0) {
        AVChannelLayout out;
        av_channel_layout_default(&out, 2);
        ret = swr_alloc_set_opts2(&m_swr, &out, AV_SAMPLE_FMT_S16, 48000,
                                  &m_adec->ch_layout, m_adec->sample_fmt,
                                  m_adec->sample_rate, 0, nullptr);
        av_channel_layout_uninit(&out);
        if (ret < 0 || !m_swr || swr_init(m_swr) < 0) {
            SMF_WARN("swr init failed (%d) - continuing without audio", ret);
            if (m_swr) { swr_free(&m_swr); m_swr = nullptr; }
            m_astream = -1;
        }
    }

    // ---- audio device ----
    if (m_astream >= 0) {
        if (noAudio()) {
            SMF_WARN("SIGLUSMF_NOAUDIO: audio device disabled for this run");
            m_astream = -1;
        } else {
            bool aok = m_audio.open(48000, 2, 2);
            if (!aok) {
                SMF_WARN("audio device open failed - playing video only");
                m_astream = -1;
            }
        }
    }

    m_state = SmfState::Stopped;
    m_baseMs = 0;
    m_playedFrames = 0;
    m_eof = false;
    m_serial = 0;
    m_seekTargetMs = -1;
    wallClockReset();
    {
        std::lock_guard<std::mutex> lk(m_qmtx);
        m_codecsReady = true;
        m_openFailed = false;
    }
    SMF_INFO("movie opened: %ls  duration=%lld ms  video=%d audio=%d",
             m_path.c_str(), (long long)m_durationMs, m_vstream, m_astream);
    return true;
}

void SmfPlayer::close() {
    m_run = false;
    m_qcvEmpty.notify_all();
    m_qcvFull.notify_all();
    m_reader.join();
    m_presenter.join();
    m_feeder.join();
    m_feederStarted = false;

    m_audio.close();

    flushQueues();

    if (m_sws) { sws_freeContext(m_sws); m_sws = nullptr; }
    if (m_swr) { swr_free(&m_swr); m_swr = nullptr; }
    if (m_vdec) avcodec_free_context(&m_vdec);
    if (m_adec) avcodec_free_context(&m_adec);
    if (m_fmt) avformat_close_input(&m_fmt);

    // Keep the scratch buffers allocated: close() is also the first thing open()
    // does, and a null packet/frame makes av_read_frame/avcodec_receive_frame
    // fault immediately.
    if (!m_pkt)    m_pkt = av_packet_alloc();
    if (!m_vframe) m_vframe = av_frame_alloc();
    if (!m_aframe) m_aframe = av_frame_alloc();

    m_vstream = m_astream = -1;
    m_width = m_height = 0;
    m_durationMs = 0;
    m_frameRate = 0.0;
    m_decodedFrames = 0;
    m_pktCount = 0;
    {
        std::lock_guard<std::mutex> lk(m_qmtx);
        m_codecsReady = false;
        m_openFailed = false;
    }
    m_state = SmfState::Idle;
}

void SmfPlayer::flushQueues() {
    std::lock_guard<std::mutex> lk(m_qmtx);
    m_vq.clear();
    m_aq.clear();
    m_qcvEmpty.notify_all();
}

// ---------------------------------------------------------------------------

// ---------------------------------------------------------------------------
// Synchronous attach
//
// The container/codecs are opened on the reader thread (libavformat keeps
// thread-local state that makes cross-thread reads fault), but the MCI layer
// must know the frame size before "window <alias> handle ..." arrives.  start()
// therefore brings the decode thread up and waits until the open attempt has
// finished before returning.
// ---------------------------------------------------------------------------

bool SmfPlayer::start() {
    if (m_run) return true;
    if (m_path.empty()) return false;
    {
        std::lock_guard<std::mutex> lk(m_qmtx);
        m_codecsReady = false;
        m_openFailed = false;
    }
    m_run = true;
    if (!m_reader.start(kDecoderStackBytes, &SmfPlayer::readerEntry, this)) {
        m_run = false;
        return false;
    }
    // Wait for openCodecs() to finish (or fail) inside the reader thread.
    std::unique_lock<std::mutex> lk(m_qmtx);
    m_readyCv.wait_for(lk, std::chrono::seconds(30), [&] { return m_codecsReady || m_openFailed; });
    bool ok = m_codecsReady && !m_openFailed;
    if (ok) {
        if (!m_presenter.start(kDefaultStackBytes, &SmfPlayer::presenterEntry, this)) ok = false;
    }
    if (!ok) {
        m_run = false;
        m_qcvFull.notify_all();
        lk.unlock();
        m_reader.join();
        m_state = SmfState::Error;
        SMF_ERR("player start failed: %s", m_lastError.c_str());
    }
    return ok;
}

void SmfPlayer::readerLoopThread() {
    // Open on this thread, then signal the waiter, then run the read loop.
    std::string err;
    bool ok = openCodecs(&err);
    {
        std::lock_guard<std::mutex> lk(m_qmtx);
        m_codecsReady = ok;
        m_openFailed = !ok;
        if (!ok) m_lastError = err;
    }
    m_readyCv.notify_all();
    if (!ok) {
        SMF_ERR("reader: openCodecs failed: %s", err.c_str());
        return;
    }
    readerLoop();
}

bool SmfPlayer::attachVideo(HWND hwnd, int x, int y, int w, int h) {
    if (!m_vout) return false;
    if (m_width <= 0 || m_height <= 0) {
        SMF_ERR("attachVideo: frame size unknown (%dx%d)", m_width, m_height);
        return false;
    }
    if (!m_vout->create(hwnd, m_width, m_height, 0, 0)) return false;
    m_vout->setDestination(x, y, w, h);
    return true;
}

void SmfPlayer::setDestination(int x, int y, int w, int h) {
    if (m_vout) m_vout->setDestination(x, y, w, h);
}

bool SmfPlayer::hasVideoOut() const { return m_vout && m_vout->isReady(); }

HWND SmfPlayer::videoWindow() const { return m_vout ? m_vout->window() : nullptr; }

void SmfPlayer::play() {
    SmfState s = m_state.load();
    if (s == SmfState::Playing) return;

    if (s == SmfState::Paused) {
        m_state = SmfState::Playing;
        m_audio.setPaused(false);
        wallClockResume();
        return;
    }

    // Start (or restart) from the current position.  The container was already
    // opened by start() during the MCI "open" command, so only the audio feed
    // needs bringing up here.
    if (!m_run) {
        if (!start()) { SMF_ERR("play: could not start decoder threads"); return; }
    }
    if (!m_feederStarted.exchange(true)) {
        m_feeder.start(kDefaultStackBytes, &SmfPlayer::feederEntry, this);
    }
    if (s == SmfState::EndOfStream) {
        seekMs(0);
        m_audio.setPaused(false);
        wallClockReset();
    } else {
        m_audio.setPaused(false);
        wallClockResume();
    }
    m_state = SmfState::Playing;
    SMF_INFO("playback started");
}

void SmfPlayer::pause() {
    if (m_state.load() != SmfState::Playing) return;
    m_state = SmfState::Paused;
    m_audio.setPaused(true);
    wallClockPause();
    SMF_INFO("playback paused at %lld ms", (long long)positionMs());
}

void SmfPlayer::stop() {
    m_run = false;
    m_qcvEmpty.notify_all();
    m_qcvFull.notify_all();
    m_reader.join();
    m_presenter.join();
    m_feeder.join();
    m_feederStarted = false;
    m_audio.clear();
    flushQueues();
    m_baseMs = 0;
    m_playedFrames = 0;
    wallClockReset();
    m_eof = false;
    m_state = SmfState::Stopped;
    SMF_INFO("playback stopped");
}

void SmfPlayer::seekMs(int64_t ms) {
    if (!m_fmt) return;
    if (ms < 0) ms = 0;
    if (m_durationMs > 0 && ms > m_durationMs) ms = m_durationMs;
    m_seekTargetMs = ms;
    m_qcvEmpty.notify_all();
    m_qcvFull.notify_all();
    SMF_INFO("seek request -> %lld ms", (long long)ms);
}

void SmfPlayer::setVolume(float v) { m_audio.setVolume(v); }

// ---------------------------------------------------------------------------

int64_t SmfPlayer::positionMs() const {
    int64_t base = m_baseMs.load();
    if (m_astream >= 0 && m_audio.isOpen()) {
        return base + (m_playedFrames.load() * 1000) / 48000;
    }
    return base + wallClockMs();
}

int64_t SmfPlayer::masterClockMs() const {
    // Prefer the audio device clock when audio is present and running; it is the
    // most stable reference and matches what the user hears.
    if (m_astream >= 0 && m_audio.isOpen()) {
        int64_t frames = m_audio.playedFrames();
        const_cast<SmfPlayer*>(this)->m_playedFrames.store(frames);
        return m_baseMs.load() + (frames * 1000) / 48000;
    }
    return m_baseMs.load() + wallClockMs();
}

// ---------------------------------------------------------------------------
// Decoding
// ---------------------------------------------------------------------------

bool SmfPlayer::decodeVideo(AVFrame* f, int serial, std::vector<uint8_t>& out, int64_t* ptsMs) {
    uint8_t* dst[4] = { out.data(), nullptr, nullptr, nullptr };
    int dstStride[4] = { m_width * 4, 0, 0, 0 };
    sws_scale(m_sws, f->data, f->linesize, 0, m_height, dst, dstStride);

    int64_t best = f->best_effort_timestamp;
    if (best == AV_NOPTS_VALUE) best = f->pts;
    if (best != AV_NOPTS_VALUE) {
        *ptsMs = tsToMs(best, m_vtimeBase);
    } else if (m_frameRate > 0.0) {
        // No timestamps at all: synthesise from the frame rate, indexed per serial.
        if (serial != m_ptsSerial) { m_ptsSerial = serial; m_ptsCounter = 0; }
        *ptsMs = (int64_t)(1000.0 * (double)m_ptsCounter++ / m_frameRate);
    } else {
        *ptsMs = m_baseMs.load();
    }
    return true;
}

void SmfPlayer::readerLoop() {
    SetThreadDescription(GetCurrentThread(), L"SmfReader");
    SMF_INFO("reader thread started (stack reserved %llu KB)",
             (unsigned long long)(kDecoderStackBytes / 1024));
    if (m_convBuf.empty()) { SMF_ERR("reader: no conversion buffer"); return; }

    // Report the caller's actual stack limits so a guard-page fault can be told
    // apart from a genuine decoder bug.
    {
        MEMORY_BASIC_INFORMATION mbi;
        ULONG_PTR lo = 0, hi = 0;
        if (VirtualQuery((LPCVOID)&mbi, &mbi, sizeof(mbi))) {
            lo = (ULONG_PTR)mbi.AllocationBase;
        }
        hi = (ULONG_PTR)&mbi;
        (void)hi;
    }

    while (m_run) {
        // ---- apply a pending seek ----
        int64_t target = m_seekTargetMs.exchange(-1);
        if (target >= 0) {
            int64_t ts = target * (AV_TIME_BASE / 1000);
            int ret = avformat_seek_file(m_fmt, -1, INT64_MIN, ts, INT64_MAX, AVSEEK_FLAG_BACKWARD);
            if (ret < 0) {
                SMF_WARN("avformat_seek_file(%lld) failed (%d)", (long long)target, ret);
            }
            if (m_vdec) avcodec_flush_buffers(m_vdec);
            if (m_adec) avcodec_flush_buffers(m_adec);
            m_serial.fetch_add(1);
            m_baseMs = target;
            m_playedFrames = 0;
            wallClockReset();
            m_eof = false;
            m_audio.clear();
            flushQueues();
            SMF_INFO("seek applied -> %lld ms (serial %d)", (long long)target, m_serial.load());
        }

        // ---- read one packet ----
        int ret = av_read_frame(m_fmt, m_pkt);
        if (ret == 0 && (m_pktCount++ % 200) == 0)
            SMF_DBG("read: packet %lld stream=%d size=%d", (long long)m_pktCount,
                    m_pkt->stream_index, m_pkt->size);
        if (ret < 0) {
            // Flush decoders, then mark EOF.
            if (m_vdec && m_vstream >= 0) {
                avcodec_send_packet(m_vdec, nullptr);
                while (avcodec_receive_frame(m_vdec, m_vframe) == 0) {
                    if (m_seekTargetMs.load() >= 0) break;
                    std::vector<uint8_t> buf((size_t)m_width * m_height * 4 + 64);
                    int serial = m_serial.load();
                    int64_t pts = 0;
                    decodeVideo(m_vframe, serial, buf, &pts);
                    {
                        std::unique_lock<std::mutex> lk(m_qmtx);
                        m_qcvEmpty.wait(lk, [&] { return m_vq.size() < kMaxVideoQueue || !m_run; });
                        if (!m_run) break;
                        m_vq.push_back({ std::move(buf), pts, serial });
                    }
                    m_qcvFull.notify_all();
                }
            }
            m_eof = true;
            SMF_INFO("end of stream");
            break;
        }

        if (m_pkt->stream_index == m_vstream && m_vdec) {
            // Retry on EAGAIN: the decoder must be drained before it accepts a
            // new packet, otherwise frames are silently dropped.
            for (;;) {
                ret = avcodec_send_packet(m_vdec, m_pkt);
                if (ret != AVERROR(EAGAIN)) break;
                if (avcodec_receive_frame(m_vdec, m_vframe) < 0) break;
                if (!m_run || m_seekTargetMs.load() >= 0) { av_frame_unref(m_vframe); break; }
                std::vector<uint8_t> buf((size_t)m_width * m_height * 4 + 64);
                int serial = m_serial.load();
                int64_t pts = 0;
                decodeVideo(m_vframe, serial, buf, &pts);
                av_frame_unref(m_vframe);          // FFmpeg requires this each round
                std::unique_lock<std::mutex> lk(m_qmtx);
                m_qcvEmpty.wait(lk, [&] { return m_vq.size() < kMaxVideoQueue || !m_run; });
                if (!m_run) break;
                m_vq.push_back({ std::move(buf), pts, serial });
                lk.unlock();
                m_qcvFull.notify_all();
                if ((++m_decodedFrames % 30) == 0)
                    SMF_DBG("decode: %lld frames, last pts=%lld ms", (long long)m_decodedFrames, (long long)pts);
            }
            if (ret >= 0) {
                while (avcodec_receive_frame(m_vdec, m_vframe) == 0) {
                    if (!m_run || m_seekTargetMs.load() >= 0) { av_frame_unref(m_vframe); break; }
                    std::vector<uint8_t> buf((size_t)m_width * m_height * 4 + 64);
                    int serial = m_serial.load();
                    int64_t pts = 0;
                    decodeVideo(m_vframe, serial, buf, &pts);
                    av_frame_unref(m_vframe);      // FFmpeg requires this each round
                    std::unique_lock<std::mutex> lk(m_qmtx);
                    m_qcvEmpty.wait(lk, [&] { return m_vq.size() < kMaxVideoQueue || !m_run; });
                    if (!m_run) break;
                    m_vq.push_back({ std::move(buf), pts, serial });
                    lk.unlock();
                    m_qcvFull.notify_all();
                    if ((++m_decodedFrames % 30) == 0)
                        SMF_DBG("decode: %lld frames, last pts=%lld ms", (long long)m_decodedFrames, (long long)pts);
                }
            }
            av_packet_unref(m_pkt);
        } else if (m_pkt->stream_index == m_astream && m_adec && m_swr) {
            ret = avcodec_send_packet(m_adec, m_pkt);
            if (ret >= 0) {
                while (avcodec_receive_frame(m_adec, m_aframe) == 0) {
                    if (!m_run || m_seekTargetMs.load() >= 0) { av_frame_unref(m_aframe); break; }
                    int outSamples = (int)av_rescale_rnd(
                        swr_get_delay(m_swr, m_adec->sample_rate) + m_aframe->nb_samples,
                        48000, m_adec->sample_rate, AV_ROUND_UP);
                    if (outSamples <= 0) { av_frame_unref(m_aframe); continue; }
                    std::vector<uint8_t> pcm((size_t)outSamples * 2 * 2);
                    uint8_t* outp[1] = { pcm.data() };
                    int got = swr_convert(m_swr, outp, outSamples,
                                          (const uint8_t**)m_aframe->extended_data,
                                          m_aframe->nb_samples);
                    if (got <= 0) { av_frame_unref(m_aframe); continue; }
                    pcm.resize((size_t)got * 2 * 2);
                    int64_t pts = 0;
                    int64_t best = m_aframe->best_effort_timestamp;
                    if (best == AV_NOPTS_VALUE) best = m_aframe->pts;
                    if (best != AV_NOPTS_VALUE) pts = tsToMs(best, m_atimeBase);
                    av_frame_unref(m_aframe);          // FFmpeg requires this each round

                    APacket ap{ std::move(pcm), pts, m_serial.load(), got };
                    std::unique_lock<std::mutex> lk(m_qmtx);
                    m_qcvEmpty.wait(lk, [&] { return m_aq.size() < kMaxAudioQueue || !m_run; });
                    if (!m_run) break;
                    m_aq.push_back(std::move(ap));
                    lk.unlock();
                    m_qcvFull.notify_all();
                }
            }
            av_packet_unref(m_pkt);
        } else {
            av_packet_unref(m_pkt);
        }

        // Respect a pending pause by sleeping a little (keeps the threads alive).
        while (m_state.load() == SmfState::Paused && m_run && m_seekTargetMs.load() < 0) {
            Sleep(10);
        }
    }

    m_qcvFull.notify_all();
    if (m_run && m_eof) {
        // Give the queues a moment to drain before reporting end.
        for (int i = 0; i < 600 && m_run; ++i) {
            {
                std::lock_guard<std::mutex> lk(m_qmtx);
                if (m_vq.empty() && m_aq.empty()) break;
            }
            Sleep(50);
        }
        if (m_run) m_state = SmfState::EndOfStream;
    }
}

// ---------------------------------------------------------------------------

void SmfPlayer::presenterLoop() {
    SetThreadDescription(GetCurrentThread(), L"SmfPresenter");
    SmfVideoOut* vo = m_vout ? m_vout : &m_voutLocal;
    int lastSerial = -1;
    const bool skipPresent = noPresent();
    if (skipPresent) SMF_WARN("SIGLUSMF_NOPRESENT: presentation disabled for this run");

    while (m_run) {
        VFrame f;
        bool have = false;
        {
            std::unique_lock<std::mutex> lk(m_qmtx);
            if (m_vq.empty()) {
                m_qcvFull.wait_for(lk, std::chrono::milliseconds(50));
                if (m_vq.empty()) continue;
            }
            f = std::move(m_vq.front());
            m_vq.pop_front();
            have = true;
            m_qcvEmpty.notify_all();
        }
        if (!have) continue;
        if (!m_run) break;

        if (f.serial != lastSerial) { lastSerial = f.serial; }

        // Wait until it is this frame's time to be shown.
        for (;;) {
            if (!m_run || m_seekTargetMs.load() >= 0 || f.serial != m_serial.load()) break;
            SmfState st = m_state.load();
            if (st == SmfState::Paused) { Sleep(5); continue; }
            if (st == SmfState::Stopped || st == SmfState::EndOfStream) break;
            int64_t now = masterClockMs();
            int64_t diff = f.ptsMs - now;
            if (diff <= 2) break;                       // due (or late)
            if (diff > 1000) diff = 1000;
            Sleep((DWORD)(diff > 10 ? 5 : 1));
        }
        if (!m_run) break;
        if (f.serial != m_serial.load()) continue;      // superseded by a seek
        if (skipPresent) continue;

        if (!vo->isReady()) continue;
        if (!vo->present(f.data.data(), m_width * 4)) {
            // Presentation failed (e.g. device lost) - keep going, drop the frame.
        }
    }
}

// ---------------------------------------------------------------------------

void SmfPlayer::audioFeedLoop() {
    SetThreadDescription(GetCurrentThread(), L"SmfAudioFeed");
    while (m_run) {
        APacket a;
        bool have = false;
        {
            std::unique_lock<std::mutex> lk(m_qmtx);
            if (m_aq.empty()) {
                m_qcvFull.wait_for(lk, std::chrono::milliseconds(20));
                if (m_aq.empty()) continue;
            }
            a = std::move(m_aq.front());
            m_aq.pop_front();
            have = true;
            m_qcvEmpty.notify_all();
        }
        if (!have || !m_run) continue;
        if (a.serial != m_serial.load()) continue;
        if (!m_audio.isOpen()) continue;

        // Backpressure: wait for the device to drain while paused or when the
        // device queue is already deep.
        int guard = 0;
        while (m_run && !m_audio.push(a.pcm.data(), a.pcm.size())) {
            if (a.serial != m_serial.load()) break;
            if (m_state.load() == SmfState::Paused) { Sleep(10); continue; }
            Sleep(5);
            if (++guard > 2000) break;
        }
    }
}
