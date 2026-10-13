// SiglusMovieFF - modern video playback for SiglusEngine (32-bit).
// Common definitions.
#pragma once

#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <mmsystem.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include <string>
#include <vector>
#include <deque>
#include <mutex>
#include <condition_variable>
#include <atomic>
#include <thread>

extern "C" {
#include <libavformat/avformat.h>
#include <libavcodec/avcodec.h>
#include <libavutil/avutil.h>
#include <libavutil/imgutils.h>
#include <libavutil/opt.h>
#include <libavutil/time.h>
#include <libavutil/channel_layout.h>
#include <libswscale/swscale.h>
#include <libswresample/swresample.h>
}

#define SMF_VERSION L"1.0.0"

// ---------------------------------------------------------------- logging ---

enum SmfLogLevel { SMF_LOG_ERROR = 0, SMF_LOG_WARN = 1, SMF_LOG_INFO = 2, SMF_LOG_DEBUG = 3 };

void SmfLogInit(const wchar_t* moduleDir);
void SmfLogShutdown();
void SmfLogSetLevel(SmfLogLevel level);
void SmfLog(SmfLogLevel level, const char* fmt, ...);

#define SMF_ERR(...)  SmfLog(SMF_LOG_ERROR, __VA_ARGS__)
#define SMF_WARN(...) SmfLog(SMF_LOG_WARN,  __VA_ARGS__)
#define SMF_INFO(...) SmfLog(SMF_LOG_INFO,  __VA_ARGS__)
#define SMF_DBG(...)  SmfLog(SMF_LOG_DEBUG, __VA_ARGS__)

// Checked memcpy: turns a bad pointer/size into a precise log line instead of a
// fault deep inside the CRT's copy routine.  `site` identifies the call site.
#include "memcpy_sites.h"
void* SmfCheckedMemcpySite(void* dst, const void* src, size_t bytes, unsigned site);
#define SMF_MEMCPY(dst, src, n, site) SmfCheckedMemcpySite((dst), (src), (n), (site))
