"""Minimal MINIDUMP parser: prints the faulting instruction address and the
thread/module context so a crash in the proxy can be located."""
import struct
import sys
import os

MINIDUMP_EXCEPTION_STREAM = 6
MINIDUMP_MODULE_LIST_STREAM = 4
MINIDUMP_THREAD_LIST_STREAM = 3
MINIDUMP_MEMORY_LIST_STREAM = 5


class Reader:
    def __init__(self, data):
        self.d = data

    def u32(self, off):
        return struct.unpack_from("<I", self.d, off)[0]

    def u64(self, off):
        return struct.unpack_from("<Q", self.d, off)[0]

    def raw(self, off, n):
        return self.d[off:off + n]


def parse(path):
    data = open(path, "rb").read()
    r = Reader(data)
    if r.raw(0, 4) != b"MDMP":
        print("not a minidump")
        return
    nstreams = r.u32(8)
    dir_rva = r.u32(12)
    streams = {}
    for i in range(nstreams):
        off = dir_rva + i * 12
        stype = r.u32(off)
        size = r.u32(off + 4)
        rva = r.u32(off + 8)
        streams[stype] = (rva, size)

    print("streams:", sorted(streams))

    # ---- modules ----
    mods = []
    if MINIDUMP_MODULE_LIST_STREAM in streams:
        rva, _ = streams[MINIDUMP_MODULE_LIST_STREAM]
        count = r.u32(rva)
        p = rva + 4
        for i in range(count):
            base = r.u64(p)
            size = r.u32(p + 8)
            name_rva = r.u32(p + 20)
            nlen = r.u32(name_rva)
            name = r.raw(name_rva + 4, nlen).decode("utf-16-le", "replace")
            mods.append((base, size, name))
            p += 108
    mods.sort()

    def mod_of(addr):
        best = None
        for base, size, name in mods:
            if base <= addr < base + size:
                best = (base, size, name)
        return best

    # ---- exception ----
    if MINIDUMP_EXCEPTION_STREAM not in streams:
        print("no exception stream")
        return
    rva, _ = streams[MINIDUMP_EXCEPTION_STREAM]
    tid = r.u32(rva)
    # MINIDUMP_EXCEPTION_STREAM: u32 ThreadId, u32 __align, MINIDUMP_EXCEPTION at +8
    code = r.u32(rva + 8)
    flags = r.u32(rva + 12)
    rec = r.u64(rva + 16)
    addr = r.u64(rva + 24)
    nparams = r.u32(rva + 32)
    params = [r.u64(rva + 36 + 8 * i) for i in range(min(nparams, 8))]

    print()
    print("faulting thread id : 0x%X" % tid)
    print("exception code     : 0x%08X" % code)
    print("exception address  : 0x%016X" % addr)
    m = mod_of(addr)
    if m:
        print("  -> %s + 0x%X   (module base 0x%X)" % (os.path.basename(m[2]), addr - m[0], m[0]))
    print("parameters         :", [hex(p) for p in params])

    # x86: for AV, param0 = read/write flag, param1 = faulting address
    if code == 0xC0000005 and len(params) >= 2:
        how = {0: "read", 1: "write", 8: "execute"}.get(params[0], str(params[0]))
        print("access violation   : %s at 0x%016X" % (how, params[1]))

    # ---- threads: find the faulting one and dump its CONTEXT ----
    if MINIDUMP_THREAD_LIST_STREAM in streams:
        rva, _ = streams[MINIDUMP_THREAD_LIST_STREAM]
        count = r.u32(rva)
        p = rva + 4
        for i in range(count):
            th_id = r.u32(p)
            # MINIDUMP_THREAD: u32 ThreadId, u32 SuspendCount, u32 PriorityClass,
            #   u32 Priority, u64 Teb, MINIDUMP_MEMORY_DESCRIPTOR Stack,
            #   MINIDUMP_LOCATION_DESCRIPTOR ThreadContext
            ctx_size = r.u32(p + 44)
            ctx_rva = r.u32(p + 48)
            if th_id == tid:
                print()
                print("thread context: rva=0x%X size=%d" % (ctx_rva, ctx_size))
                if ctx_rva and ctx_size >= 0x2CC:
                    ctx = r.raw(ctx_rva, ctx_size)
                    # CONTEXT (x86) layout for the registers we care about
                    eip = struct.unpack_from("<I", ctx, 0xB8)[0]
                    esp = struct.unpack_from("<I", ctx, 0xC4)[0]
                    ebp = struct.unpack_from("<I", ctx, 0xB4)[0]
                    print("  EIP=0x%08X  ESP=0x%08X  EBP=0x%08X" % (eip, esp, ebp))
                    mm = mod_of(eip)
                    if mm:
                        print("  EIP in %s + 0x%X" % (os.path.basename(mm[2]), eip - mm[0]))
                break
            p += 48
    print()
    print("modules:")
    for base, size, name in mods:
        print("  0x%08X - 0x%08X  %s" % (base, base + size, name))


if __name__ == "__main__":
    parse(sys.argv[1])
