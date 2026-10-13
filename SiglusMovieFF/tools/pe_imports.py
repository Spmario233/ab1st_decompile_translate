"""Analyse where a new import descriptor can be added to SiglusEngine.

Reports the import directory layout, the gap after the last descriptor, and the
usable tail of .data (whose raw size is far smaller than its virtual size).
"""
import pefile
import struct
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

P = sys.argv[1] if len(sys.argv) > 1 else \
    r"E:\Projects\ab1st_decompile\binary\1st_beat\SiglusEngine_CHS_RECOMPILE.exe"

pe = pefile.PE(P)
raw = bytes(pe.__data__)
base = pe.OPTIONAL_HEADER.ImageBase
imp = pe.OPTIONAL_HEADER.DATA_DIRECTORY[pefile.DIRECTORY_ENTRY["IMAGE_DIRECTORY_ENTRY_IMPORT"]]
print("ImageBase          0x%08X" % base)
print("SizeOfImage        0x%08X" % pe.OPTIONAL_HEADER.SizeOfImage)
print("Import dir RVA     0x%08X size 0x%X" % (imp.VirtualAddress, imp.Size))
print("Import dir file off 0x%X" % pe.get_offset_from_rva(imp.VirtualAddress))

# section map helper
secs = []
for s in pe.sections:
    nm = s.Name.split(b"\x00")[0].decode(errors="replace")
    secs.append((nm, int(s.VirtualAddress), int(s.Misc_VirtualSize),
                 int(s.PointerToRawData), int(s.SizeOfRawData), int(s.Characteristics)))
    print("%-9s VA=%08x VSZ=%08x PRAW=%08x RAWSZ=%08x CH=%08x" %
          (nm, s.VirtualAddress, s.Misc_VirtualSize, s.PointerToRawData,
           s.SizeOfRawData, s.Characteristics))

def va2off(rva):
    for nm, va, vsz, praw, rsz, ch in secs:
        if va <= rva < va + max(vsz, rsz):
            o = praw + (rva - va)
            if o < len(raw):
                return o
    return None

# walk the descriptor chain
o = pe.get_offset_from_rva(imp.VirtualAddress)
i = 0
while True:
    d = struct.unpack_from("<IIIII", raw, o + i * 20)
    name = None
    if d[3]:
        no = va2off(d[3])
        if no:
            name = raw[no:raw.index(b"\x00", no)].decode(errors="replace")
    print("  desc[%d] @rva %08x  OFT=%08x Name=%08x FirstThunk=%08x  %s" %
          (i, imp.VirtualAddress + i * 20, d[0], d[3], d[4], name or "(terminator)"))
    if d[0] == 0 and d[1] == 0 and d[2] == 0 and d[3] == 0 and d[4] == 0:
        break
    i += 1
    if i > 64:
        break

gap_end = imp.VirtualAddress + i * 20
print("terminator at RVA  0x%08X ; next structures could start at 0x%08X" %
      (imp.VirtualAddress + i * 20, gap_end + 20))

# .data tail: end of raw data vs virtual size
for nm, va, vsz, praw, rsz, ch in secs:
    if nm == ".data":
        print("\n.data: VA %08x..%08x (vsz), raw ends at RVA %08x" %
              (va, va + vsz, va + rsz))
        # how much of the raw tail is zeros?
        tail = raw[praw + rsz - 512: praw + rsz]
        print("  last 512 raw bytes all zero: %s" % (tail == b"\x00" * 512))
        nz = len(raw) - praw - rsz
        print("  gap RVA %08x..%08x is outside any raw data" % (va + rsz, va + vsz))
