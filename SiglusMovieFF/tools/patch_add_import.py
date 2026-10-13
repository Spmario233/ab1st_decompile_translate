"""Add an import for our proxy DLL to a SiglusEngine executable.

Why this is more involved than appending a descriptor
-----------------------------------------------------
* The executable's import descriptors live in .data, in a region whose virtual
  size is far larger than its raw size.  The loader walks the descriptor array
  until it sees an all-zero descriptor, so anything between two descriptors is
  read as another descriptor.
* Appending a descriptor "far away" therefore forces the directory's Size field
  to cover the whole gap, and the loader then tries to load DLLs named after
  whatever lies in that gap - exactly what produced the error
  "cannot find ?RegQueryValueExW.DLL" on the first attempt.
* The loader parses the import structures from the file image before the BSS part
  of .data is zeroed, so they may live anywhere that has file backing, but they
  must not rely on runtime-initialised memory.

The fix used here: relocate the whole descriptor array (existing descriptors +
ours + terminator) into free, file-backed space and point the import directory at
the copy.  Nothing in between then has to be interpreted as a descriptor.

The module must also actually export the symbol the executable imports from it,
otherwise the loader fails with "cannot find entry point ...".

Usage:
    patch_add_import.py <exe> [dll-name] [--revert] [--symbol NAME] [--data-rva 0x...]
"""
import argparse
import os
import pefile
import shutil
import struct
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

DEFAULT_DLL = "SiglusMovieFF.dll"
# Inside the 4035-byte zero run of .data's file-backed image (RVA 0x6BF040 ..
# 0x6C0003).  Verified: no relocation points there, and its only code reference
# is at RVA 0x6BFFE8, clear of this base.
DEFAULT_DATA_RVA = 0x6BF100
# Must match an export of the DLL (see src/SiglusMovieFF.def).
DEFAULT_SYMBOL = "SmfImportAnchor"
IMPORT_DIR_ENTRY = "IMAGE_DIRECTORY_ENTRY_IMPORT"
IMPORT_DESC_SIZE = 20


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("exe")
    ap.add_argument("dll", nargs="?", default=DEFAULT_DLL)
    ap.add_argument("--revert", action="store_true")
    ap.add_argument("--symbol", default=DEFAULT_SYMBOL)
    ap.add_argument("--data-rva", default=hex(DEFAULT_DATA_RVA))
    args = ap.parse_args()

    exe = os.path.abspath(args.exe)
    bak = exe + ".preimport"

    if args.revert:
        if not os.path.exists(bak):
            print("no backup at", bak)
            return 1
        shutil.copyfile(bak, exe)
        print("reverted", exe)
        return 0

    data = bytearray(open(exe, "rb").read())
    pe = pefile.PE(data=bytes(data), fast_load=True)

    secs = []
    for s in pe.sections:
        secs.append((s.Name.split(b"\x00")[0].decode(errors="replace"),
                     int(s.VirtualAddress), int(s.Misc_VirtualSize),
                     int(s.PointerToRawData), int(s.SizeOfRawData)))

    def rva_to_off(rva):
        for nm, va, vsz, praw, rsz in secs:
            if va <= rva < va + rsz:
                return praw + (rva - va)
        return None

    if len(args.dll) > 120:
        print("dll name too long")
        return 1
    data_rva = int(args.data_rva, 16)

    imp = pe.OPTIONAL_HEADER.DATA_DIRECTORY[pefile.DIRECTORY_ENTRY[IMPORT_DIR_ENTRY]]
    imp_rva, imp_size = int(imp.VirtualAddress), int(imp.Size)
    imp_off = rva_to_off(imp_rva)
    if imp_off is None:
        print("import directory is not file-backed")
        return 1

    # --- read the existing descriptor array (stop at the terminator) ----------
    descs = []
    i = 0
    while True:
        d = struct.unpack_from("<IIIII", data, imp_off + i * IMPORT_DESC_SIZE)
        if d == (0, 0, 0, 0, 0):
            break
        descs.append(d)
        i += 1
        if i > 256:
            print("no terminator found")
            return 1
    print("existing import descriptors: %d (directory RVA 0x%08X size %d)" %
          (len(descs), imp_rva, imp_size))

    # --- write the relocated array -------------------------------------------
    name_bytes = args.dll.encode("ascii") + b"\x00"
    hint_name = struct.pack("<H", 0) + args.symbol.encode("ascii") + b"\x00"

    base = (data_rva + 15) & ~15
    new_desc_rva = base
    ours_index = len(descs)                  # right after the originals
    term_index = ours_index + 1
    tail = new_desc_rva + (term_index + 1) * IMPORT_DESC_SIZE
    oft_rva = (tail + 7) & ~7
    iat_rva = oft_rva + 8
    hn_rva = iat_rva + 8
    dll_rva = hn_rva + len(hint_name)
    end_rva = dll_rva + len(name_bytes)
    total = end_rva - base

    off = rva_to_off(base)
    if off is None:
        print("data RVA 0x%08X is not file-backed" % base)
        return 1
    # every byte of the destination must be file-backed
    if rva_to_off(end_rva - 1) is None:
        print("destination is not fully file-backed")
        return 1
    region = bytes(data[off:off + total])
    if any(region):
        print("destination RVA 0x%08X is not free (%d non-zero bytes)" %
              (base, sum(1 for b in region if b)))
        return 1
    print("relocating %d descriptors + ours to RVA 0x%08X (%d bytes, free)" %
          (len(descs), base, total))

    def w(rva, blob):
        data[rva_to_off(rva):rva_to_off(rva) + len(blob)] = blob

    for k, d in enumerate(descs):
        w(new_desc_rva + k * IMPORT_DESC_SIZE, struct.pack("<IIIII", *d))
    w(new_desc_rva + ours_index * IMPORT_DESC_SIZE,
      struct.pack("<IIIII", oft_rva, 0, 0, dll_rva, iat_rva))
    w(new_desc_rva + term_index * IMPORT_DESC_SIZE, b"\x00" * IMPORT_DESC_SIZE)

    thunk = struct.pack("<II", hn_rva, 0)
    w(oft_rva, thunk)
    w(iat_rva, thunk)
    w(hn_rva, hint_name)
    w(dll_rva, name_bytes)

    # --- point the directory at the relocated array --------------------------
    opt_off = pe.DOS_HEADER.e_lfanew + 4 + 20
    dd_off = opt_off + 96 + pefile.DIRECTORY_ENTRY[IMPORT_DIR_ENTRY] * 8
    struct.pack_into("<I", data, dd_off, new_desc_rva)
    struct.pack_into("<I", data, dd_off + 4, (term_index + 1) * IMPORT_DESC_SIZE)
    print("import directory -> RVA 0x%08X size %d (%d descriptors + terminator)" %
          (new_desc_rva, (term_index + 1) * IMPORT_DESC_SIZE, term_index))

    if not os.path.exists(bak):
        shutil.copyfile(exe, bak)
        print("backup ->", bak)
    with open(exe, "wb") as f:
        f.write(bytes(data))

    # --- verify --------------------------------------------------------------
    chk = pefile.PE(exe)
    names = [d.dll.decode(errors="replace") for d in chk.DIRECTORY_ENTRY_IMPORT]
    print("verify: %d descriptors" % len(names))
    for nm in names:
        print("   ", nm)
    bad = [x for x in names if not x.lower().endswith(".dll")]
    if bad or names[-1].lower() != args.dll.lower() or len(names) != len(descs) + 1:
        print("VERIFY FAILED")
        return 2
    print("verify: OK")
    return 0


if __name__ == "__main__":
    sys.exit(main())
