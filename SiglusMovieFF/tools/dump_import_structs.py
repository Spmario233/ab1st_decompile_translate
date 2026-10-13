"""Dump exactly what the loader will read for the import table: every descriptor,
its INT/IAT thunks, hint/name entries and DLL name, with the raw bytes."""
import pefile
import struct
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

P = sys.argv[1]
pe = pefile.PE(P)
raw = bytes(pe.__data__)
base = pe.OPTIONAL_HEADER.ImageBase

secs = []
for s in pe.sections:
    secs.append((s.Name.split(b"\x00")[0].decode(errors="replace"),
                 int(s.VirtualAddress), int(s.Misc_VirtualSize),
                 int(s.PointerToRawData), int(s.SizeOfRawData)))

def va2off(rva):
    for nm, va, vsz, praw, rsz in secs:
        if va <= rva < va + rsz:
            return praw + (rva - va)
    return None

def cstr(rva, maxlen=200):
    o = va2off(rva)
    if o is None:
        return None
    end = raw.find(b"\x00", o, o + maxlen)
    if end < 0:
        return None
    return raw[o:end]

imp = pe.OPTIONAL_HEADER.DATA_DIRECTORY[pefile.DIRECTORY_ENTRY["IMAGE_DIRECTORY_ENTRY_IMPORT"]]
imp_rva = int(imp.VirtualAddress)
print("import dir RVA 0x%08X size %d" % (imp_rva, imp.Size))
o = va2off(imp_rva)
i = 0
while True:
    d = struct.unpack_from("<IIIII", raw, o + i * 20)
    if d == (0, 0, 0, 0, 0):
        print("  [%2d] RVA 0x%08X TERMINATOR" % (i, imp_rva + i * 20))
        break
    oft, ts, fc, name, iat = d
    nm = cstr(name)
    print("  [%2d] RVA 0x%08X OFT=0x%08X Name=0x%08X (%r) IAT=0x%08X" %
          (i, imp_rva + i * 20, oft, name, nm, iat))
    # first few thunks
    if oft and nm and not nm.startswith(b"Siglus"):
        pass
    if nm and nm.lower().startswith(b"siglusmovieff"):
        for tbl_label, tbl in (("OFT", oft), ("IAT", iat)):
            to = va2off(tbl)
            if to is None:
                print("      %s RVA 0x%08X NOT FILE-BACKED" % (tbl_label, tbl))
                continue
            for k in range(3):
                v = struct.unpack_from("<I", raw, to + k * 4)[0]
                extra = ""
                if v and not (v & 0x80000000):
                    hn = cstr(v + 2, 64)
                    extra = " hint/name %r" % hn
                print("      %s[%d] RVA 0x%08X value=0x%08X%s" %
                      (tbl_label, k, tbl + k * 4, v, extra))
                if v == 0:
                    break
    i += 1
    if i > 40:
        break
