// Video output into the window the game engine hands us via the MCI
// "window <alias> handle <hwnd>" command.
//
// Primary backend is an IDirect3D9Ex/IDirect3D9 present chain on that window
// (GPU scaled blit, no tearing); the fallback is a plain GDI StretchDIBits
// blit, which always works even when no D3D device can be created.
#pragma once
#include "common.h"

class SmfVideoOut {
public:
    SmfVideoOut();
    ~SmfVideoOut();

    // Creates the backend.  hwnd must be a valid window.  srcW/srcH is the video
    // size, outW/outH the destination size (<= 0 means "use the client area").
    bool create(HWND hwnd, int srcW, int srcH, int outW, int outH);
    void destroy();
    bool isReady() const { return m_hwnd != nullptr; }

    HWND window() const { return m_hwnd; }

    // dstW/dstH = the region inside the client area the engine wants the movie
    // drawn into (from "put <alias> destination at x y w h").
    void setDestination(int x, int y, int w, int h);

    // Presents a decoded frame.  pix is BGRA (or BGRX), top-down, tightly packed,
    // stride = srcW*4.  Returns false if the frame could not be presented.
    bool present(const void* pix, int stride);

    const char* backendName() const { return m_useD3D ? "D3D9" : "GDI"; }
    bool usingD3D() const { return m_useD3D; }

private:
    bool createD3D();
    bool createGDI();
    void drawLetterbox(RECT* dst);

    HWND    m_hwnd = nullptr;
    int     m_srcW = 0, m_srcH = 0;
    int     m_dstX = 0, m_dstY = 0, m_dstW = 0, m_dstH = 0;
    bool    m_useD3D = false;

    // --- D3D9 ---
    struct Impl;
    Impl*   m_impl = nullptr;

    // --- GDI ---
    HDC        m_memDC = nullptr;
    HBITMAP    m_bmp = nullptr;
    void*      m_bits = nullptr;
    HGDIOBJ    m_oldBmp = nullptr;
    int        m_bmpW = 0, m_bmpH = 0;
};
