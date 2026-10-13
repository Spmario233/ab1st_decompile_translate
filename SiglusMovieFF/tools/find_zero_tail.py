"""Locate the largest run of zero bytes at the end of each section's raw data,
which is the safest place to park new PE structures."""
import pefile
import sys

sys.stdout.reconfigure(encoding="utf-8", errors="backslashreplace")

P = sys.argv[1]
pe = pefile.PE(P)
raw = bytes(pe.__data__)

for s in pe.sections:
    nm = s.Name.split(b"\x00")[0].decode(errors="replace")
    praw, rsz, vsz = int(s.PointerToRawData), int(s.SizeOfRawData), int(s.Misc_VirtualSize)
    va = int(s.VirtualAddress)
    blob = raw[praw:praw + rsz]
    if not blob:
        continue
    # trailing zero run
    i = len(blob)
    while i > 0 and blob[i - 1] == 0:
        i -= 1
    trailing = len(blob) - i
    # longest interior zero run
    best_len, best_off, cur, cur_off = 0, 0, 0, 0
    for k, b in enumerate(blob):
        if b == 0:
            if cur == 0:
                cur_off = k
            cur += 1
            if cur > best_len:
                best_len, best_off = cur, cur_off
        else:
            cur = 0
    print("%-9s VA=%08x PRAW=%08x RAWSZ=%08x trailing_zeros=%d (from RVA %08X)  longest_zero_run=%d @RVA %08X"
          % (nm, va, praw, rsz, trailing, va + i, best_len, va + best_off))
