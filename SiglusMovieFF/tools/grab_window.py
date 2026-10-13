"""Capture a window into a PNG via PrintWindow (works for hidden/occluded windows)."""
import ctypes
import sys
from ctypes import wintypes as w
from PIL import Image

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

u = ctypes.WinDLL("user32", use_last_error=True)
g = ctypes.WinDLL("gdi32", use_last_error=True)

substr = sys.argv[1] if len(sys.argv) > 1 else "Angel Beats"
out = sys.argv[2] if len(sys.argv) > 2 else r"E:\Projects\ab1st_decompile\re_video\modern_movie\dist\window.png"

found = []


def cb(h, l):
    if u.IsWindowVisible(h):
        n = u.GetWindowTextLengthW(h)
        if n:
            b = ctypes.create_unicode_buffer(n + 1)
            u.GetWindowTextW(h, b, n + 1)
            if substr in b.value:
                found.append((h, b.value))
    return True


u.EnumWindows(ctypes.WINFUNCTYPE(w.BOOL, w.HWND, w.LPARAM)(cb), 0)
if not found:
    print("window not found")
    sys.exit(1)

hwnd, title = found[0]
print("window:", hex(hwnd), title)

rc = w.RECT()
u.GetWindowRect(hwnd, ctypes.byref(rc))
ww, hh = rc.right - rc.left, rc.bottom - rc.top
print("size:", ww, hh)

hdc = u.GetWindowDC(hwnd)
mem = g.CreateCompatibleDC(hdc)
bmp = g.CreateCompatibleBitmap(hdc, ww, hh)
g.SelectObject(mem, bmp)

PW_RENDERFULLCONTENT = 0x00000002
ok = u.PrintWindow(hwnd, mem, PW_RENDERFULLCONTENT)
if not ok:
    ok = u.PrintWindow(hwnd, mem, 0)
print("PrintWindow ->", ok)


class BITMAPINFOHEADER(ctypes.Structure):
    _fields_ = [("biSize", w.DWORD), ("biWidth", w.LONG), ("biHeight", w.LONG),
                ("biPlanes", w.WORD), ("biBitCount", w.WORD), ("biCompression", w.DWORD),
                ("biSizeImage", w.DWORD), ("biXPelsPerMeter", w.LONG),
                ("biYPelsPerMeter", w.LONG), ("biClrUsed", w.DWORD), ("biClrImportant", w.DWORD)]


bi = BITMAPINFOHEADER()
bi.biSize = ctypes.sizeof(BITMAPINFOHEADER)
bi.biWidth = ww
bi.biHeight = -hh          # top-down
bi.biPlanes = 1
bi.biBitCount = 32
bi.biCompression = 0

buf = ctypes.create_string_buffer(ww * hh * 4)
g.GetDIBits(mem, bmp, 0, hh, buf, ctypes.byref(bi), 0)

img = Image.frombuffer("RGBA", (ww, hh), buf, "raw", "BGRA", 0, 1)
img.convert("RGB").save(out)
print("saved", out)

g.DeleteObject(bmp)
g.DeleteDC(mem)
u.ReleaseDC(hwnd, hdc)
