"""Send real keystrokes to the game window using SendInput, forcing it to the
foreground first (attaching thread input to bypass the foreground lock)."""
import ctypes
import sys
import time
from ctypes import wintypes as w

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

u = ctypes.WinDLL("user32", use_last_error=True)
k = ctypes.WinDLL("kernel32", use_last_error=True)

INPUT_KEYBOARD = 1
KEYEVENTF_KEYUP = 0x0002
VK = {"enter": 0x0D, "space": 0x20, "esc": 0x1B, "down": 0x28}


class KEYBDINPUT(ctypes.Structure):
    _fields_ = [("wVk", w.WORD), ("wScan", w.WORD), ("dwFlags", w.DWORD),
                ("time", w.DWORD), ("dwExtraInfo", ctypes.POINTER(w.ULONG))]


class _INPUTunion(ctypes.Union):
    _fields_ = [("ki", KEYBDINPUT), ("padding", ctypes.c_byte * 24)]


class INPUT(ctypes.Structure):
    _fields_ = [("type", w.DWORD), ("u", _INPUTunion)]


def find_window(substr="Angel Beats"):
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
    return found


def force_foreground(hwnd):
    fg = u.GetForegroundWindow()
    if fg == hwnd:
        return True
    tid_fg = u.GetWindowThreadProcessId(fg, None) if fg else 0
    tid_me = k.GetCurrentThreadId()
    attached = False
    if tid_fg and tid_fg != tid_me:
        attached = bool(u.AttachThreadInput(tid_me, tid_fg, True))
    u.ShowWindow(hwnd, 9)          # SW_RESTORE
    u.BringWindowToTop(hwnd)
    u.SetForegroundWindow(hwnd)
    u.SetActiveWindow(hwnd)
    u.SetFocus(hwnd)
    if attached:
        u.AttachThreadInput(tid_me, tid_fg, False)
    time.sleep(0.4)
    return u.GetForegroundWindow() == hwnd


def tap(vk, hold=0.06):
    down = INPUT(type=INPUT_KEYBOARD, u=_INPUTunion(ki=KEYBDINPUT(vk, 0, 0, 0, None)))
    up = INPUT(type=INPUT_KEYBOARD, u=_INPUTunion(ki=KEYBDINPUT(vk, 0, KEYEVENTF_KEYUP, 0, None)))
    u.SendInput(1, ctypes.byref(down), ctypes.sizeof(INPUT))
    time.sleep(hold)
    u.SendInput(1, ctypes.byref(up), ctypes.sizeof(INPUT))


INPUT_MOUSE = 0
MOUSEEVENTF_MOVE = 0x0001
MOUSEEVENTF_LEFTDOWN = 0x0002
MOUSEEVENTF_LEFTUP = 0x0004
MOUSEEVENTF_ABSOLUTE = 0x8000
SM_CXSCREEN = 0
SM_CYSCREEN = 1


class MOUSEINPUT(ctypes.Structure):
    _fields_ = [("dx", w.LONG), ("dy", w.LONG), ("mouseData", w.DWORD),
                ("dwFlags", w.DWORD), ("time", w.DWORD),
                ("dwExtraInfo", ctypes.POINTER(w.ULONG))]


class _MINPUTunion(ctypes.Union):
    _fields_ = [("mi", MOUSEINPUT), ("padding", ctypes.c_byte * 24)]


class MINPUT(ctypes.Structure):
    _fields_ = [("type", w.DWORD), ("u", _MINPUTunion)]


def click_client(hwnd, fx, fy):
    """Click at a fraction (fx, fy) of the client area."""
    rc = w.RECT()
    u.GetClientRect(hwnd, ctypes.byref(rc))
    cx = int(rc.right * fx)
    cy = int(rc.bottom * fy)
    pt = w.POINT(cx, cy)
    u.ClientToScreen(hwnd, ctypes.byref(pt))
    sw = u.GetSystemMetrics(SM_CXSCREEN)
    sh = u.GetSystemMetrics(SM_CYSCREEN)
    ax = int(pt.x * 65535 / max(sw - 1, 1))
    ay = int(pt.y * 65535 / max(sh - 1, 1))

    mv = MINPUT(type=INPUT_MOUSE, u=_MINPUTunion(
        mi=MOUSEINPUT(ax, ay, 0, MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE, 0, None)))
    dn = MINPUT(type=INPUT_MOUSE, u=_MINPUTunion(
        mi=MOUSEINPUT(ax, ay, 0, MOUSEEVENTF_LEFTDOWN | MOUSEEVENTF_ABSOLUTE, 0, None)))
    up = MINPUT(type=INPUT_MOUSE, u=_MINPUTunion(
        mi=MOUSEINPUT(ax, ay, 0, MOUSEEVENTF_LEFTUP | MOUSEEVENTF_ABSOLUTE, 0, None)))
    u.SendInput(1, ctypes.byref(mv), ctypes.sizeof(MINPUT))
    time.sleep(0.15)
    u.SendInput(1, ctypes.byref(dn), ctypes.sizeof(MINPUT))
    time.sleep(0.08)
    u.SendInput(1, ctypes.byref(up), ctypes.sizeof(MINPUT))
    print(f"click at screen ({pt.x},{pt.y}) == client ({cx},{cy})")


wins = find_window()
print("windows:", [(hex(h), t) for h, t in wins])
if not wins:
    sys.exit(1)
hwnd = wins[0][0]
print("foreground ok:", force_foreground(hwnd))

seq = sys.argv[1].split(",") if len(sys.argv) > 1 else ["enter", "space", "enter", "space", "enter"]
for name in seq:
    name = name.strip()
    if name == "click":
        click_client(hwnd, 0.5, 0.5)
    elif name.startswith("click:"):
        # Accept both "click:0.5:0.5" and "click:0,5,0,5" (PowerShell may split on
        # the comma, so treat either separator as a decimal point).
        parts = [p.replace(",", ".") for p in name[6:].replace(",", ":").split(":") if p]
        if len(parts) == 2:
            click_client(hwnd, float(parts[0]), float(parts[1]))
        else:
            print("bad click spec", name)
    elif name in VK:
        print("tap", name)
        tap(VK[name])
    else:
        print("unknown action", name)
        continue
    time.sleep(1.2)
print("done")
