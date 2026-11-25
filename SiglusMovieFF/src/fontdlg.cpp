// SiglusMovieFF - font settings window layout repair.
//
// The engine creates the "font settings" window (cfg_wnd_solo_font) as a
// DLU-based #32770 dialog.  At 200% system scaling the dialog frame is scaled
// by the dialog manager, but the engine creates the child controls itself with
// hard-coded 96-DPI pixel sizes (16 px rows, 80/102 px buttons), while the font
// it assigns is a 9 pt face that becomes 24 px at 192 DPI.  The result is 24 px
// text inside 16 px high rows: lines overlap and button captions get clipped.
//
// We hook CreateWindowExW, notice the first child created inside that dialog,
// subclass the dialog and re-flow its children once the engine has finished
// creating them.  All geometry is computed from a one-time snapshot of the
// engine's own layout, so repeated passes stay stable.
#include "common.h"
#include "fontdlg.h"

#include <algorithm>

namespace {

using CreateWindowExWFn = HWND (WINAPI*)(DWORD, LPCWSTR, LPCWSTR, DWORD, int, int,
                                         int, int, HWND, HMENU, HINSTANCE, LPVOID);
CreateWindowExWFn g_origCreateWindowExW = nullptr;

const UINT kMsgSnapshot = WM_APP + 0x51;
const UINT kMsgRelayout = WM_APP + 0x52;

HWND    g_dlg = nullptr;
WNDPROC g_origDlgProc = nullptr;
bool    g_snapped = false;
bool    g_inLayout = false;

struct Item {
    HWND         hwnd = nullptr;
    DWORD        style = 0;
    std::wstring cls;
    std::wstring text;
    bool         push = false;
    bool         check = false;
    bool         radio = false;
    bool         stat = false;
    bool         list = false;
    bool         status = false;
};

struct Orig { int x = 0, y = 0, w = 0, h = 0; };

std::vector<Item> g_items;
std::vector<Orig> g_orig;

int GetDpiFor(HWND hwnd) {
    typedef UINT (WINAPI* GetDpiForWindowFn)(HWND);
    static GetDpiForWindowFn fn = nullptr;
    static bool resolved = false;
    if (!resolved) {
        resolved = true;
        HMODULE user32 = GetModuleHandleW(L"user32.dll");
        if (!user32) user32 = LoadLibraryW(L"user32.dll");
        if (user32) fn = (GetDpiForWindowFn)GetProcAddress(user32, "GetDpiForWindow");
    }
    if (fn) {
        UINT dpi = fn(hwnd);
        if (dpi >= 96 && dpi <= 960) return (int)dpi;
    }
    HDC dc = GetDC(hwnd);
    int dpi = dc ? GetDeviceCaps(dc, LOGPIXELSY) : 96;
    if (dc) ReleaseDC(hwnd, dc);
    return dpi > 0 ? dpi : 96;
}

HFONT CtrlFont(HWND hwnd) {
    return (HFONT)(uintptr_t)SendMessageW(hwnd, WM_GETFONT, 0, 0);
}

int FontHeight(HWND hwnd, int fallback) {
    HFONT font = CtrlFont(hwnd);
    if (!font) return fallback;
    LOGFONTW lf = {};
    if (!GetObjectW(font, sizeof(lf), &lf)) return fallback;
    int h = lf.lfHeight < 0 ? -lf.lfHeight : lf.lfHeight;
    return h > 0 ? h : fallback;
}

int TextWidth(HWND hwnd, const std::wstring& text) {
    if (text.empty()) return 0;
    HDC dc = GetDC(hwnd);
    if (!dc) return 0;
    HFONT font = CtrlFont(hwnd);
    HGDIOBJ old = font ? SelectObject(dc, font) : nullptr;
    SIZE sz = {};
    GetTextExtentPoint32W(dc, text.c_str(), (int)text.size(), &sz);
    if (old) SelectObject(dc, old);
    ReleaseDC(hwnd, dc);
    return sz.cx;
}

bool IsFontDialog(HWND hwnd) {
    wchar_t cls[64] = {};
    if (!hwnd || !GetClassNameW(hwnd, cls, _countof(cls))) return false;
    if (_wcsicmp(cls, L"#32770") != 0) return false;
    wchar_t title[160] = {};
    GetWindowTextW(hwnd, title, _countof(title));
    return wcsstr(title, L"字体") || wcsstr(title, L"フォント") ||
           wcsstr(title, L"Font") || wcsstr(title, L"font");
}

BOOL CALLBACK SnapshotProc(HWND child, LPARAM) {
    Item it;
    it.hwnd = child;
    it.style = (DWORD)GetWindowLongW(child, GWL_STYLE);
    wchar_t buf[256] = {};
    GetClassNameW(child, buf, _countof(buf));
    it.cls = buf;
    buf[0] = 0;
    GetWindowTextW(child, buf, _countof(buf));
    it.text = buf;

    const DWORD type = it.style & 0x0F;
    if (_wcsicmp(it.cls.c_str(), L"Button") == 0) {
        if (type == BS_PUSHBUTTON || type == BS_DEFPUSHBUTTON) it.push = true;
        else if (type == BS_CHECKBOX || type == BS_AUTOCHECKBOX) it.check = true;
        else if (type == BS_RADIOBUTTON || type == BS_AUTORADIOBUTTON) it.radio = true;
    } else if (_wcsicmp(it.cls.c_str(), L"Static") == 0) {
        it.stat = true;
    } else if (_wcsicmp(it.cls.c_str(), L"ListBox") == 0) {
        it.list = true;
    } else if (_wcsicmp(it.cls.c_str(), L"msctls_statusbar32") == 0) {
        it.status = true;
    }
    g_items.push_back(it);

    RECT r = {};
    GetWindowRect(child, &r);
    POINT tl = { r.left, r.top };
    ScreenToClient(g_dlg, &tl);
    Orig o;
    o.x = tl.x;
    o.y = tl.y;
    o.w = r.right - r.left;
    o.h = r.bottom - r.top;
    g_orig.push_back(o);
    return TRUE;
}

void Snapshot(HWND dlg) {
    g_items.clear();
    g_orig.clear();
    EnumChildWindows(dlg, SnapshotProc, 0);
    g_snapped = true;
    SMF_INFO("font dialog %p: snapshot of %d child controls", (void*)dlg,
             (int)g_items.size());
}

void Reflow(HWND dlg) {
    RECT cr = {};
    GetClientRect(dlg, &cr);
    const int dpi = GetDpiFor(dlg);
    if (dpi < 144) return;                       // 100% / 125% already fit
    const int s = (dpi + 48) / 96;               // 1.5 -> 2, 2.0 -> 2, 2.5 -> 3

    size_t listIdx = (size_t)-1, statusIdx = (size_t)-1;
    for (size_t i = 0; i < g_items.size(); ++i) {
        if (g_items[i].list) listIdx = i;
        else if (g_items[i].status) statusIdx = i;
    }
    if (listIdx == (size_t)-1) return;

    const int fontH = FontHeight(g_items[listIdx].hwnd, 16 * s);
    const int rowH = fontH + 6;
    const int sampleH = fontH + 12;
    const int btnH = fontH + 16;
    const int gap = 4 * s;
    const int pad = 8 * s;

    struct Row { int top; std::vector<size_t> idx; };
    std::vector<Row> rows;
    std::vector<size_t> pushes;

    for (size_t i = 0; i < g_items.size(); ++i) {
        const Item& it = g_items[i];
        if (it.list || it.status) continue;
        if (it.push) { pushes.push_back(i); continue; }
        if (!it.check && !it.radio && !it.stat) continue;

        bool placed = false;
        for (Row& r : rows) {
            if (abs(r.top - g_orig[i].y) <= 2) { r.idx.push_back(i); placed = true; break; }
        }
        if (!placed) {
            Row r;
            r.top = g_orig[i].y;
            r.idx.push_back(i);
            rows.push_back(r);
        }
    }
    std::sort(rows.begin(), rows.end(),
              [](const Row& a, const Row& b) { return a.top < b.top; });

    std::vector<int> heights(rows.size(), rowH);
    for (size_t r = 0; r < rows.size(); ++r) {
        for (size_t i : rows[r].idx) {
            if (g_items[i].stat && g_orig[i].h > 2 * fontH) heights[r] = sampleH;
        }
    }

    int total = 0;
    for (int h : heights) total += h + gap;
    total += btnH + pad;

    int bottomLimit = cr.bottom;
    if (statusIdx != (size_t)-1 && IsWindowVisible(g_items[statusIdx].hwnd)) {
        bottomLimit = g_orig[statusIdx].y;
    }

    const int listTop = g_orig[listIdx].y;
    int listBottom = bottomLimit - total;
    if (listBottom - listTop < 6 * fontH) listBottom = listTop + 6 * fontH;

    SetWindowPos(g_items[listIdx].hwnd, nullptr, g_orig[listIdx].x, listTop,
                 g_orig[listIdx].w, listBottom - listTop,
                 SWP_NOZORDER | SWP_NOACTIVATE);
    SendMessageW(g_items[listIdx].hwnd, LB_SETITEMHEIGHT, 0, (LPARAM)(fontH + 4));

    int y = listBottom + gap;
    for (size_t r = 0; r < rows.size(); ++r) {
        const int h = heights[r];
        const Row& row = rows[r];
        const int radios = (int)std::count_if(
            row.idx.begin(), row.idx.end(),
            [](size_t i) { return g_items[i].radio; });

        if (radios >= 3) {
            int x = g_orig[row.idx[0]].x;
            for (size_t i : row.idx) {
                int w = TextWidth(g_items[i].hwnd, g_items[i].text) + 2 * fontH;
                if (w < g_orig[i].w) w = g_orig[i].w;
                SetWindowPos(g_items[i].hwnd, nullptr, x, y, w, h,
                             SWP_NOZORDER | SWP_NOACTIVATE);
                x += w + gap;
            }
        } else if (row.idx.size() == 1 && g_items[row.idx[0]].stat) {
            const size_t i = row.idx[0];
            int w = g_orig[i].w;
            const int full = cr.right - g_orig[i].x - pad;
            if (w < full) w = full;
            SetWindowPos(g_items[i].hwnd, nullptr, g_orig[i].x, y, w, h,
                         SWP_NOZORDER | SWP_NOACTIVATE);
        } else {
            for (size_t i : row.idx) {
                int w = g_orig[i].w;
                if (g_items[i].check || g_items[i].stat) {
                    const int full = cr.right - g_orig[i].x - pad;
                    if (w < full) w = full;
                }
                SetWindowPos(g_items[i].hwnd, nullptr, g_orig[i].x, y, w, h,
                             SWP_NOZORDER | SWP_NOACTIVATE);
            }
        }
        y += h + gap;
    }

    int bx = cr.right - pad;
    int by = bottomLimit - pad - btnH;
    if (by < y) by = y;
    std::sort(pushes.begin(), pushes.end(),
              [](size_t a, size_t b) { return g_orig[a].x > g_orig[b].x; });
    for (size_t i : pushes) {
        int w = TextWidth(g_items[i].hwnd, g_items[i].text) + 2 * fontH;
        if (w < g_orig[i].w * s) w = g_orig[i].w * s;
        bx -= w;
        SetWindowPos(g_items[i].hwnd, nullptr, bx, by, w, btnH,
                     SWP_NOZORDER | SWP_NOACTIVATE);
        bx -= gap;
    }

    InvalidateRect(dlg, nullptr, TRUE);
    SMF_INFO("font dialog %p fixed: dpi=%d font=%dpx rows=%d buttons_y=%d",
             (void*)dlg, dpi, fontH, (int)rows.size(), by);
}

void Layout(HWND dlg) {
    if (g_inLayout || g_items.empty()) return;
    g_inLayout = true;
    Reflow(dlg);
    g_inLayout = false;
}

LRESULT CALLBACK DlgProc(HWND hwnd, UINT msg, WPARAM wParam, LPARAM lParam) {
    if (hwnd == g_dlg) {
        if (msg == kMsgSnapshot) {
            if (!g_snapped) {
                Snapshot(hwnd);
                Layout(hwnd);
            }
            return 0;
        }
        if (msg == kMsgRelayout) {
            Layout(hwnd);
            return 0;
        }
        if ((msg == WM_SIZE || msg == WM_SHOWWINDOW) && g_snapped) {
            PostMessageW(hwnd, kMsgRelayout, 0, 0);
        }
    }

    LRESULT result = g_origDlgProc
        ? CallWindowProcW(g_origDlgProc, hwnd, msg, wParam, lParam)
        : DefWindowProcW(hwnd, msg, wParam, lParam);

    if (hwnd == g_dlg && msg == WM_NCDESTROY) {
        g_dlg = nullptr;
        g_origDlgProc = nullptr;
        g_snapped = false;
        g_items.clear();
        g_orig.clear();
    }
    return result;
}

HWND WINAPI Smf_CreateWindowExW(DWORD exStyle, LPCWSTR className, LPCWSTR windowName,
                                DWORD style, int x, int y, int w, int h,
                                HWND parent, HMENU menu, HINSTANCE inst, LPVOID param) {
    if (!g_origCreateWindowExW) {
        HMODULE user32 = GetModuleHandleW(L"user32.dll");
        if (!user32) user32 = LoadLibraryW(L"user32.dll");
        if (user32) g_origCreateWindowExW =
            (CreateWindowExWFn)GetProcAddress(user32, "CreateWindowExW");
    }
    HWND result = g_origCreateWindowExW
        ? g_origCreateWindowExW(exStyle, className, windowName, style, x, y, w, h,
                                parent, menu, inst, param)
        : nullptr;

    if (result && parent && parent != g_dlg && !g_dlg && IsFontDialog(parent)) {
        g_dlg = parent;
        g_origDlgProc = (WNDPROC)SetWindowLongPtrW(parent, GWLP_WNDPROC,
                                                   (LONG_PTR)DlgProc);
        SMF_INFO("font dialog %p detected, subclassed", (void*)parent);
        PostMessageW(parent, kMsgSnapshot, 0, 0);
    }
    return result;
}

}  // namespace

void SmfFontDialogInit() {
    if (SmfPatchHostIat("user32.dll", "CreateWindowExW", (void*)&Smf_CreateWindowExW)) {
        SMF_INFO("CreateWindowExW hook installed (font dialog layout repair)");
    } else {
        SMF_WARN("CreateWindowExW hook: user32!CreateWindowExW IAT slot not found");
    }
}