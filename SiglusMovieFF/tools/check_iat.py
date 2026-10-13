"""Read the game's WINMM IAT slots and report where they point.

Confirms whether SiglusMovieFF redirected the engine's MCI calls, independent of
any log file.
"""
import ctypes
import subprocess
import sys
from ctypes import wintypes as w

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

k = ctypes.WinDLL("kernel32", use_last_error=True)
psapi = ctypes.WinDLL("psapi")

PROCESS_QUERY_INFORMATION = 0x0400
PROCESS_VM_READ = 0x0010
LIST_MODULES_ALL = 0x03
DEFAULT_BASE = 0x400000
IAT = {
    "mciSendStringW": 0xA175F0,
    "mciGetErrorStringW": 0xA175F4,
}


class MODULEINFO(ctypes.Structure):
    _fields_ = [("lpBaseOfDll", ctypes.c_void_p),
                ("SizeOfImage", w.DWORD),
                ("EntryPoint", ctypes.c_void_p)]


target = sys.argv[1] if len(sys.argv) > 1 else "SiglusEngine.exe"
out = subprocess.run(["tasklist", "/FI", f"IMAGENAME eq {target}", "/FO", "CSV", "/NH"],
                     capture_output=True, text=True).stdout
pid = None
for line in out.splitlines():
    if target.lower() in line.lower():
        pid = int(line.split(",")[1].strip('"'))
if pid is None:
    print(f"{target} not running")
    sys.exit(1)
print(f"{target} pid={pid}")

h = k.OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, False, pid)
if not h:
    print("OpenProcess failed:", ctypes.get_last_error())
    sys.exit(2)

mods = (w.HMODULE * 2048)()
need = w.DWORD(0)
psapi.EnumProcessModulesEx(h, ctypes.byref(mods), ctypes.sizeof(mods),
                           ctypes.byref(need), LIST_MODULES_ALL)
n = need.value // ctypes.sizeof(w.HMODULE)

modules = []          # (name, base, size)
for i in range(min(n, len(mods))):
    name = ctypes.create_unicode_buffer(260)
    psapi.GetModuleBaseNameW(h, w.HMODULE(int(mods[i])), name, 260)
    mi = MODULEINFO()
    psapi.GetModuleInformation(h, w.HMODULE(int(mods[i])), ctypes.byref(mi),
                               ctypes.sizeof(mi))
    modules.append((name.value, int(mods[i]), int(mi.SizeOfImage)))

for nm, b, s in modules:
    if any(t in nm.lower() for t in ("siglus", "avcodec", "avformat", "avutil",
                                     "swscale", "swresample")):
        print(f"   module {nm} base=0x{b:08X} size=0x{s:X}")


def owner_of(ptr):
    for nm, b, s in modules:
        if b <= ptr < b + s:
            return f"{nm}+0x{ptr - b:X}"
    return "(unknown)"


exe = next(((b, s) for nm, b, s in modules if nm.lower() == target.lower()), None)
if not exe:
    print("host module not found in the list")
    sys.exit(3)
base, size = exe
print(f"host base=0x{base:08X} size=0x{size:X}")

for fname, va in IAT.items():
    rva = va - DEFAULT_BASE
    buf = ctypes.c_uint32(0)
    rd = ctypes.c_size_t(0)
    if not k.ReadProcessMemory(h, ctypes.c_void_p(base + rva),
                               ctypes.byref(buf), 4, ctypes.byref(rd)):
        print(f"{fname}: read failed ({ctypes.get_last_error()})")
        continue
    ptr = buf.value
    print(f"{fname:20s} IAT@0x{base + rva:08X} -> 0x{ptr:08X}  {owner_of(ptr)}")

k.CloseHandle(h)
