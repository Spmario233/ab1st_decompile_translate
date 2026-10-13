// DllDecodeTest - decode in a DLL to compare against the same code in an EXE.
// If the EXE probe succeeds and this DLL test crashes, the problem is the DLL
// environment (loader/CRT), not the FFmpeg API usage.
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <process.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <vector>
#include <string>

extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <libswscale/swscale.h>
}

static FILE* g_log = nullptr;
static void L(const char* fmt, ...) {
    va_list ap; va_start(ap, fmt);
    if (g_log) { vfprintf(g_log, fmt, ap); fputc('\n', g_log); fflush(g_log); }
    va_end(ap);
}

static unsigned __stdcall worker(void* arg) {
    const char* path = (const char*)arg;
    L("[dll] worker tid=%lu", (unsigned long)GetCurrentThreadId());

    AVFormatContext* fmt = nullptr;
    int r = avformat_open_input(&fmt, path, nullptr, nullptr);
    L("[dll] avformat_open_input -> %d", r);
    if (r < 0) return 1;
    r = avformat_find_stream_info(fmt, nullptr);
    L("[dll] find_stream_info -> %d", r);

    int vs = -1;
    for (unsigned i = 0; i < fmt->nb_streams; ++i)
        if (fmt->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) { vs = (int)i; break; }
    AVStream* st = fmt->streams[vs];
    const AVCodec* dec = avcodec_find_decoder(st->codecpar->codec_id);
    L("[dll] decoder=%s", dec->name);
    AVCodecContext* c = avcodec_alloc_context3(dec);
    avcodec_parameters_to_context(c, st->codecpar);
    c->thread_count = 0;
    r = avcodec_open2(c, dec, nullptr);
    L("[dll] avcodec_open2 -> %d (%dx%d fmt=%d threads=%d active=%d)", r, c->width, c->height,
      c->pix_fmt, c->thread_count, c->active_thread_type);

    SwsContext* sws = sws_getContext(c->width, c->height, c->pix_fmt,
                                     c->width, c->height, AV_PIX_FMT_BGRA,
                                     SWS_BILINEAR, nullptr, nullptr, nullptr);
    L("[dll] sws=%p", (void*)sws);
    std::vector<uint8_t> buf((size_t)c->width * c->height * 4 + 64);

    AVPacket* pkt = av_packet_alloc();
    AVFrame* frame = av_frame_alloc();
    int64_t frames = 0;
    while (av_read_frame(fmt, pkt) >= 0) {
        if (pkt->stream_index != vs) { av_packet_unref(pkt); continue; }
        if ((frames % 30) == 0 && frames < 90)
            L("[dll] read pkt size=%d key=%d", pkt->size, (pkt->flags & AV_PKT_FLAG_KEY) ? 1 : 0);
        r = avcodec_send_packet(c, pkt);
        if (r >= 0) {
            while (avcodec_receive_frame(c, frame) == 0) {
                if (frames < 3) L("[dll] got frame %lld fmt=%d %dx%d", (long long)frames,
                                  frame->format, frame->width, frame->height);
                uint8_t* dst[4] = { buf.data(), nullptr, nullptr, nullptr };
                int st2[4] = { c->width * 4, 0, 0, 0 };
                sws_scale(sws, frame->data, frame->linesize, 0, c->height, dst, st2);
                av_frame_unref(frame);
                if (++frames >= 300) goto done;
            }
        }
        av_packet_unref(pkt);
    }
done:
    L("[dll] TOTAL frames=%lld", (long long)frames);
    av_packet_free(&pkt);
    av_frame_free(&frame);
    if (sws) sws_freeContext(sws);
    avcodec_free_context(&c);
    avformat_close_input(&fmt);
    return 0;
}

extern "C" __declspec(dllexport) int DllRunDecode(const char* path) {
    fopen_s(&g_log, "DllDecodeTest.log", "wb");
    L("[dll] DllRunDecode('%s')", path);
    HANDLE h = (HANDLE)_beginthreadex(nullptr, 32u * 1024 * 1024, worker, (void*)path, 0, nullptr);
    if (!h) { L("[dll] thread create failed"); return -1; }
    WaitForSingleObject(h, INFINITE);
    DWORD code = 0;
    GetExitCodeThread(h, &code);
    CloseHandle(h);
    L("[dll] worker exit=%lu", (unsigned long)code);
    if (g_log) { fclose(g_log); g_log = nullptr; }
    return (int)code;
}
