#include "video_out.h"
#include <d3d9.h>

#pragma comment(lib, "d3d9.lib")

// ---------------------------------------------------------------------------
// D3D9 backend
// ---------------------------------------------------------------------------

struct SmfVideoOut::Impl {
    IDirect3D9*       d3d = nullptr;
    IDirect3DDevice9* dev = nullptr;
    IDirect3DTexture9* tex = nullptr;
    bool              lost = false;
    D3DPRESENT_PARAMETERS pp = { 0 };

    void releaseAll() {
        if (tex) { tex->Release(); tex = nullptr; }
        if (dev) { dev->Release(); dev = nullptr; }
        if (d3d) { d3d->Release(); d3d = nullptr; }
    }
};

namespace {

struct Vertex { float x, y, z, rhw, u, v; };
const DWORD kFVF = D3DFVF_XYZRHW | D3DFVF_TEX1;

// Original window procedure of the target window, if we subclass it.
WNDPROC g_prevProc = nullptr;
HWND    g_procHwnd = nullptr;
SmfVideoOut* g_owner = nullptr;

LRESULT CALLBACK movieWndProc(HWND hwnd, UINT msg, WPARAM wp, LPARAM lp) {
    switch (msg) {
    case WM_ERASEBKGND:
        if (g_owner && g_owner->usingD3D()) return 1;   // avoid flicker behind D3D
        break;
    case WM_SIZE:
    case WM_MOVE:
        // The engine may reposition the window; just force a redraw.
        InvalidateRect(hwnd, nullptr, FALSE);
        break;
    default:
        break;
    }
    if (g_prevProc) return CallWindowProcW(g_prevProc, hwnd, msg, wp, lp);
    return DefWindowProcW(hwnd, msg, wp, lp);
}

int clientSize(HWND hwnd, int* w, int* h) {
    RECT rc;
    if (!GetClientRect(hwnd, &rc)) return 0;
    *w = rc.right - rc.left;
    *h = rc.bottom - rc.top;
    return (*w > 0 && *h > 0) ? 1 : 0;
}

} // namespace

SmfVideoOut::SmfVideoOut() {}

SmfVideoOut::~SmfVideoOut() { destroy(); }

bool SmfVideoOut::create(HWND hwnd, int srcW, int srcH, int outW, int outH) {
    destroy();
    if (!IsWindow(hwnd)) {
        SMF_ERR("video: invalid window handle %p", (void*)hwnd);
        return false;
    }
    m_hwnd = hwnd;
    m_srcW = srcW > 0 ? srcW : 1;
    m_srcH = srcH > 0 ? srcH : 1;

    int cw = 0, ch = 0;
    if (!clientSize(hwnd, &cw, &ch)) {
        RECT wr;
        GetWindowRect(hwnd, &wr);
        cw = wr.right - wr.left; ch = wr.bottom - wr.top;
    }
    m_dstX = 0; m_dstY = 0;
    m_dstW = outW > 0 ? outW : cw;
    m_dstH = outH > 0 ? outH : ch;

    SMF_INFO("video: hwnd=%p client=%dx%d video=%dx%d dest=%d,%d %dx%d",
             (void*)hwnd, cw, ch, m_srcW, m_srcH, m_dstX, m_dstY, m_dstW, m_dstH);

    if (createD3D()) {
        m_useD3D = true;
        SMF_INFO("video backend: D3D9");
    } else if (createGDI()) {
        m_useD3D = false;
        if (!m_impl) m_impl = new Impl();   // keep present()'s guard valid
        SMF_INFO("video backend: GDI (D3D9 unavailable)");
    } else {
        SMF_ERR("video: no usable backend");
        m_hwnd = nullptr;
        return false;
    }

    if (!g_prevProc) {
        g_owner = this;
        g_procHwnd = hwnd;
        SetLastError(0);
        g_prevProc = (WNDPROC)SetWindowLongPtrW(hwnd, GWLP_WNDPROC, (LONG_PTR)movieWndProc);
        if (!g_prevProc && GetLastError() != 0) {
            SMF_WARN("video: SetWindowLongPtrW failed (%lu)", GetLastError());
        }
    }
    return true;
}

void SmfVideoOut::destroy() {
    if (m_impl) { m_impl->releaseAll(); delete m_impl; m_impl = nullptr; }

    if (m_memDC) { if (m_oldBmp) SelectObject(m_memDC, m_oldBmp); DeleteDC(m_memDC); m_memDC = nullptr; }
    if (m_bmp)   { DeleteObject(m_bmp); m_bmp = nullptr; }
    m_bits = nullptr; m_oldBmp = nullptr; m_bmpW = m_bmpH = 0;

    if (g_procHwnd && g_prevProc) {
        SetWindowLongPtrW(g_procHwnd, GWLP_WNDPROC, (LONG_PTR)g_prevProc);
    }
    g_prevProc = nullptr; g_procHwnd = nullptr; g_owner = nullptr;

    m_hwnd = nullptr;
    m_useD3D = false;
}

void SmfVideoOut::setDestination(int x, int y, int w, int h) {
    m_dstX = x; m_dstY = y;
    if (w > 0) m_dstW = w;
    if (h > 0) m_dstH = h;
    SMF_INFO("video: destination %d,%d %dx%d", m_dstX, m_dstY, m_dstW, m_dstH);
}

bool SmfVideoOut::createD3D() {
    // Diagnostic: SIGLUSMF_NOD3D=1 forces the GDI backend.
    {
        wchar_t v[8] = { 0 };
        if (GetEnvironmentVariableW(L"SIGLUSMF_NOD3D", v, 8) && v[0] == L'1') {
            SMF_WARN("SIGLUSMF_NOD3D: forcing GDI backend");
            return false;
        }
    }
    m_impl = new Impl();

    typedef IDirect3D9* (WINAPI* PFN_D3DCreate9)(UINT);
    HMODULE hd3d = GetModuleHandleW(L"d3d9.dll");
    PFN_D3DCreate9 pCreate = nullptr;
    if (!hd3d) hd3d = LoadLibraryW(L"d3d9.dll");
    if (hd3d) pCreate = (PFN_D3DCreate9)GetProcAddress(hd3d, "Direct3DCreate9");
    if (!pCreate) { SMF_WARN("video: Direct3DCreate9 not available"); delete m_impl; m_impl = nullptr; return false; }

    m_impl->d3d = pCreate(D3D_SDK_VERSION);
    if (!m_impl->d3d) { SMF_WARN("video: Direct3DCreate9 failed"); delete m_impl; m_impl = nullptr; return false; }

    D3DDISPLAYMODE dm = { 0 };
    m_impl->d3d->GetAdapterDisplayMode(D3DADAPTER_DEFAULT, &dm);
    int w = m_dstW > 0 ? m_dstW : 640;
    int h = m_dstH > 0 ? m_dstH : 480;

    D3DPRESENT_PARAMETERS& pp = m_impl->pp;
    ZeroMemory(&pp, sizeof(pp));
    pp.Windowed               = TRUE;
    pp.SwapEffect             = D3DSWAPEFFECT_DISCARD;
    pp.hDeviceWindow          = m_hwnd;
    pp.BackBufferFormat       = dm.Format;
    pp.BackBufferWidth        = (UINT)w;
    pp.BackBufferHeight       = (UINT)h;
    pp.BackBufferCount        = 1;
    pp.EnableAutoDepthStencil = FALSE;
    pp.PresentationInterval   = D3DPRESENT_INTERVAL_IMMEDIATE;
    pp.MultiSampleType        = D3DMULTISAMPLE_NONE;
    pp.Flags                  = 0;

    const DWORD behavior = D3DCREATE_FPU_PRESERVE | D3DCREATE_MULTITHREADED |
                           D3DCREATE_SOFTWARE_VERTEXPROCESSING;

    HRESULT hr = m_impl->d3d->CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, m_hwnd,
                                           behavior, &pp, &m_impl->dev);
    if (FAILED(hr)) {
        SMF_WARN("video: CreateDevice(HAL) failed hr=0x%08lx, trying MIXED/REF", (unsigned long)hr);
        hr = m_impl->d3d->CreateDevice(D3DADAPTER_DEFAULT, D3DDEVTYPE_HAL, m_hwnd,
                                       behavior | D3DCREATE_MIXED_VERTEXPROCESSING, &pp, &m_impl->dev);
    }
    if (FAILED(hr)) {
        SMF_WARN("video: CreateDevice failed hr=0x%08lx", (unsigned long)hr);
        m_impl->releaseAll();
        delete m_impl; m_impl = nullptr;
        return false;
    }

    hr = m_impl->dev->CreateTexture((UINT)m_srcW, (UINT)m_srcH, 1, D3DUSAGE_DYNAMIC,
                                    D3DFMT_X8R8G8B8, D3DPOOL_DEFAULT, &m_impl->tex, nullptr);
    if (FAILED(hr)) {
        SMF_WARN("video: CreateTexture failed hr=0x%08lx", (unsigned long)hr);
        m_impl->releaseAll();
        delete m_impl; m_impl = nullptr;
        return false;
    }

    m_impl->dev->SetRenderState(D3DRS_LIGHTING, FALSE);
    m_impl->dev->SetRenderState(D3DRS_CULLMODE, D3DCULL_NONE);
    m_impl->dev->SetRenderState(D3DRS_ALPHABLENDENABLE, FALSE);
    m_impl->dev->SetRenderState(D3DRS_ZENABLE, FALSE);
    m_impl->dev->SetRenderState(D3DRS_COLORVERTEX, FALSE);
    m_impl->dev->SetSamplerState(0, D3DSAMP_MINFILTER, D3DTEXF_LINEAR);
    m_impl->dev->SetSamplerState(0, D3DSAMP_MAGFILTER, D3DTEXF_LINEAR);
    m_impl->dev->SetSamplerState(0, D3DSAMP_ADDRESSU, D3DTADDRESS_CLAMP);
    m_impl->dev->SetSamplerState(0, D3DSAMP_ADDRESSV, D3DTADDRESS_CLAMP);
    return true;
}

bool SmfVideoOut::createGDI() {
    HDC screen = GetDC(nullptr);
    if (!screen) return false;
    m_memDC = CreateCompatibleDC(screen);
    ReleaseDC(nullptr, screen);
    if (!m_memDC) return false;

    m_bmpW = m_srcW;
    m_bmpH = m_srcH;
    BITMAPINFO bi;
    ZeroMemory(&bi, sizeof(bi));
    bi.bmiHeader.biSize = sizeof(BITMAPINFOHEADER);
    bi.bmiHeader.biWidth = m_bmpW;
    bi.bmiHeader.biHeight = -m_bmpH;            // top-down
    bi.bmiHeader.biPlanes = 1;
    bi.bmiHeader.biBitCount = 32;
    bi.bmiHeader.biCompression = BI_RGB;

    m_bmp = CreateDIBSection(m_memDC, &bi, DIB_RGB_COLORS, &m_bits, nullptr, 0);
    if (!m_bmp || !m_bits) { SMF_WARN("video: CreateDIBSection failed"); return false; }
    m_oldBmp = SelectObject(m_memDC, m_bmp);
    SetStretchBltMode(m_memDC, HALFTONE);
    return true;
}

void SmfVideoOut::drawLetterbox(RECT* dst) {
    // Fit the video inside the destination rect preserving aspect ratio.
    int dw = m_dstW, dh = m_dstH;
    if (dw <= 0 || dh <= 0) { clientSize(m_hwnd, &dw, &dh); }
    double va = (double)m_srcW / (double)m_srcH;
    double wa = (double)dw / (double)dh;
    int w, h;
    if (wa > va) { h = dh; w = (int)(dh * va + 0.5); }
    else         { w = dw; h = (int)(dw / va + 0.5); }
    dst->left   = m_dstX + (dw - w) / 2;
    dst->top    = m_dstY + (dh - h) / 2;
    dst->right  = dst->left + w;
    dst->bottom = dst->top + h;
}

bool SmfVideoOut::present(const void* pix, int stride) {
    if (!m_hwnd || !pix) return false;
    if (!IsWindow(m_hwnd)) { SMF_WARN("video: target window vanished"); return false; }

    RECT dst;
    drawLetterbox(&dst);

    if (m_useD3D && m_impl && m_impl->dev) {
        Impl& I = *m_impl;
        if (I.lost) {
            HRESULT hr = I.dev->TestCooperativeLevel();
            if (hr == D3DERR_DEVICENOTRESET) {
                if (SUCCEEDED(I.dev->Reset(&I.pp))) {
                    I.dev->CreateTexture((UINT)m_srcW, (UINT)m_srcH, 1, D3DUSAGE_DYNAMIC,
                                         D3DFMT_X8R8G8B8, D3DPOOL_DEFAULT, &I.tex, nullptr);
                    I.lost = false;
                    SMF_INFO("video: D3D device reset");
                } else {
                    return false;
                }
            } else if (hr == D3DERR_DEVICELOST) {
                return false;
            } else {
                I.lost = false;
            }
        }

        D3DLOCKED_RECT lr;
        HRESULT hr = I.tex->LockRect(0, &lr, nullptr, D3DLOCK_DISCARD);
        if (FAILED(hr)) {
            if (hr == D3DERR_DEVICELOST) { I.lost = true; }
            return false;
        }
        const uint8_t* src = (const uint8_t*)pix;
        uint8_t* d = (uint8_t*)lr.pBits;
        if (!d) { I.tex->UnlockRect(0); return false; }
        int copyW = m_srcW;
        if (copyW * 4 > lr.Pitch) copyW = lr.Pitch / 4;   // never write past the pitch
        for (int y = 0; y < m_srcH; ++y) {
            SMF_MEMCPY(d, src, (size_t)copyW * 4, SMF_CPY_D3D_ROW);
            src += stride;
            d += lr.Pitch;
        }
        I.tex->UnlockRect(0);

        // Clip the destination to the client area.
        RECT cr;
        GetClientRect(m_hwnd, &cr);
        if (dst.left < cr.left) dst.left = cr.left;
        if (dst.top < cr.top) dst.top = cr.top;
        if (dst.right > cr.right) dst.right = cr.right;
        if (dst.bottom > cr.bottom) dst.bottom = cr.bottom;

        float x0 = (float)dst.left - 0.5f, y0 = (float)dst.top - 0.5f;
        float x1 = (float)dst.right - 0.5f, y1 = (float)dst.bottom - 0.5f;
        Vertex v[4] = {
            { x0, y0, 0.f, 1.f, 0.f, 0.f },
            { x1, y0, 0.f, 1.f, 1.f, 0.f },
            { x0, y1, 0.f, 1.f, 0.f, 1.f },
            { x1, y1, 0.f, 1.f, 1.f, 1.f },
        };

        hr = I.dev->BeginScene();
        if (FAILED(hr)) {
            if (hr == D3DERR_DEVICELOST) I.lost = true;
            return false;
        }
        I.dev->Clear(0, nullptr, D3DCLEAR_TARGET, D3DCOLOR_XRGB(0, 0, 0), 1.0f, 0);
        I.dev->SetFVF(kFVF);
        I.dev->SetTexture(0, I.tex);
        I.dev->SetTextureStageState(0, D3DTSS_COLOROP, D3DTOP_SELECTARG1);
        I.dev->SetTextureStageState(0, D3DTSS_COLORARG1, D3DTA_TEXTURE);
        I.dev->SetTextureStageState(0, D3DTSS_ALPHAOP, D3DTOP_DISABLE);
        I.dev->DrawPrimitiveUP(D3DPT_TRIANGLESTRIP, 2, v, sizeof(Vertex));
        I.dev->EndScene();

        hr = I.dev->Present(nullptr, nullptr, nullptr, nullptr);
        if (hr == D3DERR_DEVICELOST) { I.lost = true; return false; }
        return true;
    }

    // ---- GDI fallback ----
    if (!m_memDC || !m_bits) return false;
    const uint8_t* src = (const uint8_t*)pix;
    if (stride == m_bmpW * 4) {
        SMF_MEMCPY(m_bits, src, (size_t)m_bmpW * m_bmpH * 4, SMF_CPY_GDI_FULL);
    } else {
        uint8_t* d = (uint8_t*)m_bits;
        for (int y = 0; y < m_bmpH; ++y) {
            SMF_MEMCPY(d, src, (size_t)m_bmpW * 4, SMF_CPY_GDI_ROW);
            src += stride; d += (size_t)m_bmpW * 4;
        }
    }

    HDC dc = GetDC(m_hwnd);
    if (!dc) return false;
    if (m_useD3D == false) {
        // Erase the letterbox area to black so stale pixels do not linger.
        RECT cr;
        GetClientRect(m_hwnd, &cr);
        HBRUSH black = (HBRUSH)GetStockObject(BLACK_BRUSH);
        FillRect(dc, &cr, black);
    }
    SetStretchBltMode(dc, HALFTONE);
    SetBrushOrgEx(dc, 0, 0, nullptr);
    StretchBlt(dc, dst.left, dst.top, dst.right - dst.left, dst.bottom - dst.top,
               m_memDC, 0, 0, m_bmpW, m_bmpH, SRCCOPY);
    ReleaseDC(m_hwnd, dc);
    return true;
}
