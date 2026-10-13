"""Report, for a given RVA, whether it is backed by file data or is BSS.

Also lists zero runs that are INSIDE a section's raw (file-backed) data, which is
where loader-read structures such as the import hint/name table must live.
"""
import pefile
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

P = sys.argv[1]
pe = pefile.PE(P)
raw = bytes(pe.__data__)

secs = []
for s in pe.sections:
    nm = s.Name.split(b"\x00")[0].decode(errors="replace")
    secs.append((nm, int(s.VirtualAddress), int(s.Misc_VirtualSize),
                 int(s.PointerToRawData), int(s.SizeOfRawData)))

print("sections:")
for nm, va, vsz, praw, rsz in secs:
    print("  %-9s RVA %08x..%08x (vsz)  raw-backed RVA %08x..%08x" %
          (nm, va, va + vsz, va, va + rsz))

def classify(rva):
    for nm, va, vsz, praw, rsz in secs:
        if va <= rva < va + max(vsz, rsz):
            if va <= rva < va + rsz:
                return nm, "FILE-BACKED"
            return nm, "BSS (zeroed at load)"
    return "?", "unmapped"

for rva in [int(x, 16) for x in sys.argv[2:]] or [0x6BF040, 0x6BF800, 0x6CA67B]:
    nm, kind = classify(rva)
    print("RVA 0x%08X -> %s : %s" % (rva, nm, kind))

print("\nzero runs inside file-backed data (>=200 bytes):")
for nm, va, vsz, praw, rsz in secs:
    blob = raw[praw:praw + rsz]
    best = (0, 0)
    cur = 0
    cur_off = 0
    for k, b in enumerate(blob):
        if b == 0:
            if cur == 0:
                cur_off = k
            cur += 1
            if cur > best[0]:
                best = (cur, cur_off)
        else:
            cur = 0
    if best[0] >= 200:
        print("  %-9s longest zero run %d bytes at RVA 0x%08X (file off 0x%X)"
              % (nm, best[0], va + best[1], praw + best[1]))
