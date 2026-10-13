"""Dump all threads from the minidump: thread id, EIP and the module it lands in."""
import struct
import sys
import os

MINIDUMP_EXCEPTION_STREAM = 6
MINIDUMP_MODULE_LIST_STREAM = 4
MINIDUMP_THREAD_LIST_STREAM = 3


def parse(path):
    d = open(path, "rb").read()
    u32 = lambda o: struct.unpack_from("<I", d, o)[0]
    u64 = lambda o: struct.unpack_from("<Q", d, o)[0]

    nstreams = u32(8)
    dir_rva = u32(12)
    streams = {}
    for i in range(nstreams):
        off = dir_rva + i * 12
        streams[u32(off)] = (u32(off + 8), u32(off + 4))

    mods = []
    if MINIDUMP_MODULE_LIST_STREAM in streams:
        rva, _ = streams[MINIDUMP_MODULE_LIST_STREAM]
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
    mods.sort()

    def mod_of(addr):
        best = None
        for base, size, name in mods:
            if base <= addr < base + size:
                best = (base, name)
        return best

    tid_exc = None
    if MINIDUMP_EXCEPTION_STREAM in streams:
        rva, _ = streams[MINIDUMP_EXCEPTION_STREAM]
        tid_exc = u32(rva)
        print("faulting tid  : 0x%X" % tid_exc)
        print("exception code: 0x%08X" % u32(rva + 8))
        addr = u64(rva + 24)
        print("fault address : 0x%X" % addr)
        m = mod_of(addr)
        if m:
            print("  -> %s + 0x%X" % (os.path.basename(m[1]), addr - m[0]))

    print()
    if MINIDUMP_THREAD_LIST_STREAM in streams:
        rva, _ = streams[MINIDUMP_THREAD_LIST_STREAM]
        count = u32(rva)
        p = rva + 4
        print("threads: %d" % count)
        for i in range(count):
            th = u32(p)
            ctx_size = u32(p + 44)
            ctx_rva = u32(p + 48)
            eip = 0
            esp = 0
            if ctx_rva and ctx_size >= 0xC8:
                c = d[ctx_rva:ctx_rva + ctx_size]
                eip = struct.unpack_from("<I", c, 0xB8)[0]
                esp = struct.unpack_from("<I", c, 0xC4)[0]
            m = mod_of(eip)
            tag = " <== FAULTING" if th == tid_exc else ""
            print("  tid 0x%06X  EIP=0x%08X  ESP=0x%08X  %s%s" % (
                th, eip, esp,
                ("%s+0x%X" % (os.path.basename(m[1]), eip - m[0])) if m else "(?)",
                tag))
            p += 48


if __name__ == "__main__":
    parse(sys.argv[1])
