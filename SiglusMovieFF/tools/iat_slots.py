"""Compute the exact IAT slot addresses for the WINMM imports of an executable.

Reads both the OriginalFirstThunk (names) and FirstThunk (IAT) so the slot index
for each imported name is known precisely.
"""
import pefile
import struct
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

P = sys.argv[1]
pe = pefile.PE(P)
raw = bytes(pe.__data__)
print("ImageBase 0x%08X" % pe.OPTIONAL_HEADER.ImageBase)

for d in pe.DIRECTORY_ENTRY_IMPORT:
    dll = d.dll.decode()
    if dll.lower() not in ("winmm.dll",):
        continue
    print("== %s  FirstThunk RVA=0x%08X" % (dll, d.struct.FirstThunk))
    for idx, imp in enumerate(d.imports):
        nm = imp.name.decode() if imp.name else "ord%d" % imp.ordinal
        slot_rva = d.struct.FirstThunk + idx * 4
        print("   [%2d] %-22s IAT RVA=0x%08X  (VA=0x%08X)" %
              (idx, nm, slot_rva, pe.OPTIONAL_HEADER.ImageBase + slot_rva))
