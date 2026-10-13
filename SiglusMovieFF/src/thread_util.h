// A joinable thread with an explicit stack size.
//
// std::thread gives no control over the stack reservation, and FFmpeg's video
// decoders (particularly the MinGW builds used here) are stack hungry: running
// one on a default 1 MB worker stack faults on the guard page, which surfaces
// as an access violation deep inside avcodec.  We therefore use the CRT's
// _beginthreadex, which takes a stack size, and wrap the handle in RAII.
#pragma once
#include "common.h"
#include <process.h>
#include <errno.h>

class SmfThread {
public:
    SmfThread() = default;
    ~SmfThread() { join(); }
    SmfThread(const SmfThread&) = delete;
    SmfThread& operator=(const SmfThread&) = delete;

    bool start(size_t stackBytes, unsigned(__stdcall* fn)(void*), void* arg) {
        join();
        m_joined = false;
        m_h = (HANDLE)_beginthreadex(nullptr, (unsigned)stackBytes, fn, arg, 0, nullptr);
        if (!m_h) { SMF_ERR("_beginthreadex failed (errno=%d)", errno); return false; }
        return true;
    }

    bool joinable() const { return m_h != nullptr && !m_joined; }

    void join() {
        if (m_h && !m_joined) {
            WaitForSingleObject(m_h, INFINITE);
            CloseHandle(m_h);
            m_joined = true;
        }
        m_h = nullptr;
    }

private:
    HANDLE m_h = nullptr;
    bool   m_joined = false;
};
