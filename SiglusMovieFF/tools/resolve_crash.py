import re, sys, os
sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

MAP = r"E:\Projects\ab1st_decompile\re_video\modern_movie\build\SiglusMovieFF.map"
DMP = r"E:\Projects\ab1st_decompile\re_video\modern_movie\dist\FakeMovieHost.dmp"

lines = open(MAP, encoding="utf-8", errors="replace").read().splitlines()
start = [i for i, l in enumerate(lines) if "Publics by Value" in l][0]
pat = re.compile(r"^\s+([0-9a-f]{4}):([0-9a-f]{8})\s+(\S+)\s+([0-9a-f]{8})")
rows = []
for l in lines[start:]:
    m = pat.match(l)
    if m and m.group(1) == "0001":
        rows.append((0x1000 + int(m.group(2), 16), m.group(3)))
rows.sort()

sys.path.insert(0, os.path.dirname(MAP))
import struct

d = open(DMP, "rb").read()
u32 = lambda o: struct.unpack_from("<I", d, o)[0]
u64 = lambda o: struct.unpack_from("<Q", d, o)[0]

nstreams = u32(8)
dir_rva = u32(12)
streams = {}
for i in range(nstreams):
    off = dir_rva + i * 12
    streams[u32(off)] = (u32(off + 8), u32(off + 4))

mods = []
rva, _ = streams[4]
count = u32(rva)
p = rva + 4
for i in range(count):
    base = u64(p)
    size = u32(p + 8)
    name_rva = u32(p + 20)
    nlen = u32(name_rva)
    name = d[name_rva + 4:name_rva + 4 + nlen].decode("utf-16-le", "replace")
    mods.append((base, size, name))
    p += 108

rva, _ = streams[6]
tid = u32(rva)
addr = u64(rva + 24)
print("faulting tid : 0x%X" % tid)
print("fault addr   : 0x%X" % addr)

for base, size, name in mods:
    if base <= addr < base + size:
        r = addr - base
        print("module       : %s + 0x%X" % (os.path.basename(name), r))
        best = None
        for v, n in rows:
            if v <= r:
                best = (v, n)
            else:
                break
        if best:
            print("symbol       : %s + 0x%X" % (best[1], r - best[0]))
        break
