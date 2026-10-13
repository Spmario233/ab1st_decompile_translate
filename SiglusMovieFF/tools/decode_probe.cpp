// Minimal libav decode probe: isolates whether a crash is in my player code or
// in the FFmpeg API usage itself.
//   decode_probe.exe <file> [seconds] [threads] [threadtype]
// threadtype: 0 = default, 1 = slice only, 2 = frame only, 3 = none
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <process.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdarg.h>
#include <vector>

extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
#include <libavutil/opt.h>
#include <libswscale/swscale.h>
}

#pragma comment(lib, "avformat.lib")
#pragma comment(lib, "avcodec.lib")
#pragma comment(lib, "avutil.lib")
#pragma comment(lib, "swscale.lib")

static void logf(const char* fmt, ...) {
    va_list ap; va_start(ap, fmt);
    vprintf(fmt, ap);
    va_end(ap);
    fflush(stdout);
}

static int run_decode();

static const char* g_path = nullptr;
static double g_seconds = 10.0;
static int    g_threads = 0;
static int    g_ttype = 0;
static int    g_rc = 0;

static unsigned __stdcall decodeThread(void*) {
    printf("[thread] started on tid %lu\n", (unsigned long)GetCurrentThreadId());
    fflush(stdout);
    return (unsigned)run_decode();
}

int main(int argc, char** argv) {
    if (argc < 2) { printf("usage: decode_probe <file> [seconds] [threads] [threadtype] [inthread] [stackMB]\n"); return 2; }
    g_path = argv[1];
    g_seconds = (argc > 2) ? atof(argv[2]) : 10.0;
    g_threads = (argc > 3) ? atoi(argv[3]) : 0;
    g_ttype = (argc > 4) ? atoi(argv[4]) : 0;
    int inThread = (argc > 5) ? atoi(argv[5]) : 0;
    int stackMB = (argc > 6) ? atoi(argv[6]) : 1;

    if (!inThread) return run_decode();

    printf("[thread] spawning worker with %d MB stack\n", stackMB);
    fflush(stdout);
    HANDLE h = (HANDLE)_beginthreadex(nullptr, (unsigned)stackMB * 1024u * 1024u,
                                      decodeThread, nullptr, 0, nullptr);
    if (!h) { printf("_beginthreadex failed\n"); return 2; }
    WaitForSingleObject(h, INFINITE);
    DWORD code = 0;
    GetExitCodeThread(h, &code);
    CloseHandle(h);
    printf("[thread] worker exit code %lu\n", (unsigned long)code);
    return (int)code;
}

int run_decode() {
    const char* path = g_path;
    double seconds = g_seconds;
    int threads = g_threads;
    int ttype = g_ttype;

    AVFormatContext* fmt = nullptr;
    if (avformat_open_input(&fmt, path, nullptr, nullptr) < 0) { printf("open failed\n"); return 3; }
    if (avformat_find_stream_info(fmt, nullptr) < 0) { printf("find_stream_info failed\n"); return 3; }

    int vs = -1;
    for (unsigned i = 0; i < fmt->nb_streams; ++i)
        if (fmt->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) { vs = (int)i; break; }
    if (vs < 0) { printf("no video stream\n"); return 3; }

    AVStream* st = fmt->streams[vs];
    const AVCodec* dec = avcodec_find_decoder(st->codecpar->codec_id);
    printf("decoder: %s\n", dec ? dec->name : "(none)");
    if (!dec) return 3;

    AVCodecContext* c = avcodec_alloc_context3(dec);
    avcodec_parameters_to_context(c, st->codecpar);
    c->thread_count = threads;
    switch (ttype) {
    case 1: c->thread_type = FF_THREAD_SLICE; break;
    case 2: c->thread_type = FF_THREAD_FRAME; break;
    case 3: c->thread_type = 0; break;
    default: break;                       // leave FFmpeg's default
    }
    printf("requested thread_count=%d thread_type=%d\n", c->thread_count, c->thread_type);
    if (avcodec_open2(c, dec, nullptr) < 0) { printf("avcodec_open2 failed\n"); return 3; }
    printf("opened: %dx%d pixfmt=%d  active_thread_type=%d thread_count=%d\n",
           c->width, c->height, c->pix_fmt, c->active_thread_type, c->thread_count);

    SwsContext* sws = sws_getContext(c->width, c->height, c->pix_fmt,
                                     c->width, c->height, AV_PIX_FMT_BGRA,
                                     SWS_BILINEAR, nullptr, nullptr, nullptr);
    std::vector<uint8_t> buf((size_t)c->width * c->height * 4 + 64);

    AVPacket* pkt = av_packet_alloc();
    AVFrame* frame = av_frame_alloc();

    int64_t frames = 0, limit = (int64_t)(seconds * 30.0);
    int64_t lastPts = 0;
    while (av_read_frame(fmt, pkt) >= 0) {
        if (pkt->stream_index != vs) { av_packet_unref(pkt); continue; }
        int r = avcodec_send_packet(c, pkt);
        if (r >= 0) {
            while (avcodec_receive_frame(c, frame) == 0) {
                uint8_t* dst[4] = { buf.data(), nullptr, nullptr, nullptr };
                int st2[4] = { c->width * 4, 0, 0, 0 };
                sws_scale(sws, frame->data, frame->linesize, 0, c->height, dst, st2);
                ++frames;
                lastPts = frame->best_effort_timestamp;
                if ((frames % 60) == 0)
                    logf("  frame %lld pts=%lld\n", (long long)frames, (long long)lastPts);
                av_frame_unref(frame);
                if (frames >= limit) { printf("reached limit\n"); goto done; }
            }
        }
        av_packet_unref(pkt);
    }
    printf("decoded all\n");
done:
    printf("TOTAL frames=%lld lastPts=%lld\n", (long long)frames, (long long)lastPts);
    av_packet_free(&pkt);
    av_frame_free(&frame);
    if (sws) sws_freeContext(sws);
    avcodec_free_context(&c);
    avformat_close_input(&fmt);
    return 0;
}
