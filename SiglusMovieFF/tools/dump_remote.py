"""Hex-dump a range of another process's memory (for IAT inspection)."""
import ctypes
import subprocess
import sys
from ctypes import wintypes as w

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

k = ctypes.WinDLL("kernel32", use_last_error=True)
psapi = ctypes.WinDLL("psapi")


class MODULEINFO(ctypes.Structure):
    _fields_ = [("lpBaseOfDll", ctypes.c_void_p),
                ("SizeOfImage", w.DWORD),
                ("EntryPoint", ctypes.c_void_p)]


target = sys.argv[1]
rva = int(sys.argv[2], 16)
length = int(sys.argv[3], 16) if len(sys.argv) > 3 else 0x40

out = subprocess.run(["tasklist", "/FI", f"IMAGENAME eq {target}", "/FO", "CSV", "/NH"],
                     capture_output=True, text=True).stdout
pid = None
for line in out.splitlines():
    if target.lower() in line.lower():
        pid = int(line.split(",")[1].strip('"'))
if pid is None:
    print("not running")
    sys.exit(1)

h = k.OpenProcess(0x0410, False, pid)
mods = (w.HMODULE * 2048)()
need = w.DWORD(0)
psapi.EnumProcessModulesEx(h, ctypes.byref(mods), ctypes.sizeof(mods),
                           ctypes.byref(need), 3)
n = need.value // ctypes.sizeof(w.HMODULE)
base = None
for i in range(min(n, len(mods))):
    nm = ctypes.create_unicode_buffer(260)
    psapi.GetModuleBaseNameW(h, w.HMODULE(int(mods[i])), nm, 260)
    if nm.value.lower() == target.lower():
        base = int(mods[i])
print(f"{target} pid={pid} base=0x{base:08X}")

buf = ctypes.create_string_buffer(length)
rd = ctypes.c_size_t(0)
va = base + rva
if not k.ReadProcessMemory(h, ctypes.c_void_p(va), buf, length, ctypes.byref(rd)):
    print("read failed", ctypes.get_last_error())
    sys.exit(2)
data = buf.raw[:rd.value]
for i in range(0, len(data), 16):
    chunk = data[i:i + 16]
    words = " ".join(f"{int.from_bytes(chunk[j:j+4], 'little'):08X}"
                     for j in range(0, len(chunk), 4))
    print(f"  {va + i:08X}  {words}")
k.CloseHandle(h)
