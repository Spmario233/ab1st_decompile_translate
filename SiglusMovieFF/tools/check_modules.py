"""Report whether SiglusMovieFF (and the FFmpeg DLLs) are loaded in the game
process, to verify DLL injection."""
import ctypes
import sys
import subprocess
from ctypes import wintypes as w

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

k = ctypes.WinDLL("kernel32", use_last_error=True)
psapi = ctypes.WinDLL("psapi")

PROCESS_QUERY_INFORMATION = 0x0400
PROCESS_VM_READ = 0x0010
LIST_MODULES_ALL = 0x03

target = sys.argv[1] if len(sys.argv) > 1 else "SiglusEngine_CHS_RECOMPILE.exe"

out = subprocess.run(["tasklist", "/FI", f"IMAGENAME eq {target}", "/FO", "CSV", "/NH"],
                     capture_output=True, text=True).stdout
pid = None
for line in out.splitlines():
    if target in line:
        parts = line.split(",")
        pid = int(parts[1].strip('"'))
if pid is None:
    print(f"{target} is not running")
    sys.exit(1)

print(f"{target} pid={pid}")
h = k.OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, False, pid)
if not h:
    print("OpenProcess failed:", ctypes.get_last_error())
    sys.exit(2)

mods = (w.HMODULE * 2048)()
need = w.DWORD(0)
ok = psapi.EnumProcessModulesEx(h, ctypes.byref(mods), ctypes.sizeof(mods),
                                ctypes.byref(need), LIST_MODULES_ALL)
if not ok:
    print("EnumProcessModulesEx failed:", ctypes.get_last_error())
    k.CloseHandle(h)
    sys.exit(3)

n = need.value // ctypes.sizeof(w.HMODULE)
print(f"modules: {n}")
interesting = ("siglus", "avcodec", "avformat", "avutil", "swscale", "swresample", "d3d9", "dsound")
for i in range(min(n, len(mods))):
    try:
        buf = ctypes.create_unicode_buffer(260)
        psapi.GetModuleBaseNameW(h, w.HMODULE(int(mods[i])), buf, 260)
    except Exception as e:
        print("   <module %d unreadable: %s>" % (i, e))
        continue
    low = buf.value.lower()
    if any(s in low for s in interesting):
        print(f"   {buf.value}")

k.CloseHandle(h)
