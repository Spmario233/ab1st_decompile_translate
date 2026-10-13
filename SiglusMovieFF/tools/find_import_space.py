"""Find usable free space inside the mapped region between the import directory
and the end of .rdata (the structures the loader reads can live anywhere there)."""
import pefile
import struct
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

P = sys.argv[1]
pe = pefile.PE(P)
raw = bytes(pe.__data__)
base = pe.OPTIONAL_HEADER.ImageBase
imp = pe.OPTIONAL_HEADER.DATA_DIRECTORY[pefile.DIRECTORY_ENTRY["IMAGE_DIRECTORY_ENTRY_IMPORT"]]
imp_rva = int(imp.VirtualAddress)

secs = []
for s in pe.sections:
    nm = s.Name.split(b"\x00")[0].decode(errors="replace")
    secs.append((nm, int(s.VirtualAddress), int(s.Misc_VirtualSize),
                 int(s.PointerToRawData), int(s.SizeOfRawData)))

def va2off(rva):
    for nm, va, vsz, praw, rsz in secs:
        if va <= rva < va + rsz:
            return praw + (rva - va)
    return None

def off2va(off):
    for nm, va, vsz, praw, rsz in secs:
        if praw <= off < praw + rsz:
            return va + (off - praw)
    return None

# Walk every structure referenced by the import descriptors and record what is used.
used = set()

def mark(rva, n):
    for k in range(n):
        used.add(rva + k)

o = va2off(imp_rva)
i = 0
while True:
    d = struct.unpack_from("<IIIII", raw, o + i * 20)
    mark(imp_rva + i * 20, 20)
    if d == (0, 0, 0, 0, 0):
        break
    oft, _, _, name, iat = d
    # name string
    no = va2off(name)
    end = raw.index(b"\x00", no)
    mark(name, end - no + 1)
    # thunks (name-based, so the oft entries are RVAs to hint/name)
    for tbl in (oft, iat):
        if not tbl:
            continue
        to = va2off(tbl)
        k = 0
        while True:
            v = struct.unpack_from("<I", raw, to + k * 4)[0]
            mark(tbl + k * 4, 4)
            if v == 0:
                break
            if not (v & 0x80000000):
                ho = va2off(v)
                hend = raw.index(b"\x00", ho + 2)
                mark(v, hend - v + 1)
            k += 1
            if k > 4096:
                break
    i += 1

# .rdata range
rd = [s for s in secs if s[0] == ".rdata"][0]
_, rdva, rdvsz, rdpraw, rdrsz = rd
start = off2va(rdpraw)
end = off2va(rdpraw + rdrsz - 1)
print(".rdata RVA %08x..%08x  used bytes in region: %d" % (rdva, rdva + rdrsz, len(used)))

# find free runs >= 96 bytes
runs = []
run_start = None
for rva in range(rdva, rdva + rdrsz):
    if rva not in used:
        if run_start is None:
            run_start = rva
    else:
        if run_start is not None:
            if rva - run_start >= 96:
                runs.append((run_start, rva - run_start))
            run_start = None
if run_start is not None and (rdva + rdrsz - run_start) >= 96:
    runs.append((run_start, rdva + rdrsz - run_start))

runs.sort(key=lambda r: -r[1])
print("free runs >= 96 bytes (top 20):")
for rva, ln in runs[:20]:
    print("   RVA %08x  len %d  off 0x%X" % (rva, ln, va2off(rva)))
