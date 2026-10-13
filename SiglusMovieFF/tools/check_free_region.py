"""Check whether a byte range in the executable is referenced by relocations or
by any absolute address in the code - i.e. whether it is genuinely disposable."""
import pefile
import re
import struct
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

P = sys.argv[1]
RANGES = [(0x6BF040, 0x6C0000), (0x4A39000, 0x4A39200)]

pe = pefile.PE(P)
raw = bytes(pe.__data__)
base = pe.OPTIONAL_HEADER.ImageBase

# ---- relocations ---------------------------------------------------------
reloc_hits = []
try:
    for blk in pe.DIRECTORY_ENTRY_BASERELOC:
        for e in blk.entries:
            rva = blk.struct.VirtualAddress + e.rva if hasattr(e, "rva") else None
            if rva is None:
                continue
            for lo, hi in RANGES:
                if lo <= rva < hi:
                    reloc_hits.append(rva)
except Exception as ex:
    print("reloc walk failed:", ex)

print("relocations pointing into the candidate ranges: %d" % len(reloc_hits))
for r in reloc_hits[:20]:
    print("   RVA %08X" % r)

# ---- absolute-address immediates in code --------------------------------
text = [s for s in pe.sections if s.Name.startswith(b".text")][0]
tb = raw[text.PointerToRawData:text.PointerToRawData + text.SizeOfRawData]
hits = []
for lo, hi in RANGES:
    for va in range(base + lo, base + hi, 4):
        pat = struct.pack("<I", va)
        st = 0
        while True:
            k = tb.find(pat, st)
            if k < 0:
                break
            hits.append((text.VirtualAddress + k + base, va))
            st = k + 1
print("code immediates pointing into the candidate ranges: %d" % len(hits))
for a, v in hits[:20]:
    print("   insn @%08X -> %08X" % (a, v))
