// SiglusMovieFF - text layout fixes for the Chinese build.
//
// Two engine behaviours are wrong for this build:
//
// 1. Line breaking at the end of a run of punctuation.
//    When the next glyph would overrun the line, the engine asks "is this glyph
//    one that must not start a line?" and, if so, keeps it on the current line.
//    But that allowance is hard-capped at one character, so "。」" at the end of
//    a line leaves "」" alone on the next line.
//    Fix: keep the engine's rule (at most one glyph may sit past the right edge)
//    but let closing brackets / quotes hang without that limit, so a closing mark
//    never starts a line on its own.
//
// 2. Character width of Japanese-only symbols (・ ♪ ...).
//    The engine builds a 64K "is this glyph half width" table by converting each
//    code unit to the ANSI code page and storing 2 for a 2-byte result, 1
//    otherwise.  On a Chinese system (CP936) characters that exist in Shift-JIS
//    but not in GBK - ・, ♪, 〜, 〟 and so on - fail to convert and end up
//    half width, so they are drawn squeezed and the line is measured too short.
//    Fix: after the table is built, promote those entries to full width; the
//    set is computed with CP932, i.e. exactly the rule the Japanese build used.
#include "common.h"
#include "textfix.h"

#include <atomic>
#include <vector>

namespace {

// RVAs inside SiglusEngine.  Every patch is guarded by a byte signature so a
// different engine build is left alone.
const uintptr_t kRvaLimitA   = 0x1ee6fd;  // mov eax,[esi+0x18] / add eax,edx
const uintptr_t kRvaLimitB   = 0x1ee720;  // mov [ebp-0x444],eax
const uintptr_t kRvaBreak    = 0x1ee744;  // "start a new line"
const uintptr_t kRvaContinue = 0x1ee781;  // "keep the glyph on this line"
const uintptr_t kRvaKinsoku  = 0x1ee73b;  // call <is-kinsoku character>
const uintptr_t kRvaWidthCall = 0x1ee69a;  // call <width table getter>
const uintptr_t kRvaWidthGetter = 0x163140;

const int32_t kNewXSlot = -0x444;  // [ebp-0x444]: pen position after this glyph

// Closing marks from the engine's own kinsoku table.  These are allowed to hang
// past the two-character allowance: a closing quote must not start a line.
const uint16_t kClosing[] = {
    0x300D, 0x300F, 0x3009, 0x300B, 0x3011, 0x3015, 0x301F,  // 」，』〉》】〕〟
    0xFF09, 0xFF3D, 0xFF5D, 0xFF63,                          // ）］｝｣
    0x201D, 0x2019,                                          // ” ’
    0x0029, 0x005D, 0x007D, 0x003E, 0x0022, 0x0027,          // ) ] } > " '
};

using WidthTableFn = void* (__cdecl*)();

uintptr_t g_exeBase = 0;
BYTE* g_cave = nullptr;      // next free byte in the cave
BYTE* g_caveBase = nullptr;  // start of the cave

WidthTableFn g_getWidthTable = nullptr;
std::vector<uint16_t> g_promote;
std::atomic<bool> g_ready{false};
volatile LONG g_applied = 0;

bool g_patchedA = false;
bool g_patchedB = false;
bool g_patchedCall = false;

bool verifyBytes(uintptr_t address, const unsigned char* expect, size_t len) {
    return memcmp((const void*)address, expect, len) == 0;
}

bool writeBytes(uintptr_t address, const unsigned char* bytes, size_t len) {
    DWORD old = 0;
    if (!VirtualProtect((void*)address, len, PAGE_EXECUTE_READWRITE, &old)) {
        return false;
    }
    memcpy((void*)address, bytes, len);
    DWORD ignored = 0;
    VirtualProtect((void*)address, len, old, &ignored);
    FlushInstructionCache(GetCurrentProcess(), (void*)address, len);
    return true;
}

void putRel32(BYTE* field, const void* target) {
    const intptr_t rel = (const BYTE*)target - (field + 4);
    memcpy(field, &rel, 4);
}

// Emits one "right edge + one character (or a closing mark)" test into the code
// cave and returns its entry point.  storeNewX is needed for the second layout
// mode, where the engine has not stored the pen position yet.
BYTE* buildLimitThunk(bool storeNewX) {
    BYTE* start = g_cave;
    BYTE* p = g_cave;

    enum { kLabelOverflow = 0, kLabelBreak = 1, kLabelContinue = 2 };
    BYTE* labels[3] = {};
    struct Fix { BYTE* field; int label; };
    std::vector<Fix> fixes;

    auto jmpLabel = [&](int label) {
        *p++ = 0xE9;
        fixes.push_back({p, label});
        p += 4;
    };
    auto jccLabel = [&](BYTE code, int label) {
        *p++ = 0x0F;
        *p++ = code;
        fixes.push_back({p, label});
        p += 4;
    };
    auto jmpEngine = [&](uintptr_t target) {
        *p++ = 0xE9;
        putRel32(p, (const void*)target);
        p += 4;
    };

    if (storeNewX) {
        *p++ = 0x89; *p++ = 0x85;                 // mov [ebp-0x444],eax
        memcpy(p, &kNewXSlot, 4); p += 4;
    }
    *p++ = 0x8B; *p++ = 0x46; *p++ = 0x18;        // mov eax,[esi+0x18]
    *p++ = 0x03; *p++ = 0xC2;                     // add eax,edx  -> right edge + 1 char
    *p++ = 0x39; *p++ = 0x85;                     // cmp [ebp-0x444],eax
    memcpy(p, &kNewXSlot, 4); p += 4;
    jccLabel(0x8F, kLabelOverflow);               // jg overflow
    *p++ = 0x39; *p++ = 0x95;                     // cmp [ebp-0x444],edx
    memcpy(p, &kNewXSlot, 4); p += 4;
    jccLabel(0x8E, kLabelContinue);               // jle continue
    jmpEngine(g_exeBase + kRvaKinsoku);           // kinsoku test decides

    labels[kLabelOverflow] = p;
    for (uint16_t ch : kClosing) {
        *p++ = 0x66; *p++ = 0x81; *p++ = 0xF9;    // cmp cx, imm16
        memcpy(p, &ch, 2); p += 2;
        jccLabel(0x84, kLabelContinue);           // je continue (hang the mark)
    }
    jmpLabel(kLabelBreak);

    labels[kLabelBreak] = p;
    jmpEngine(g_exeBase + kRvaBreak);
    labels[kLabelContinue] = p;
    jmpEngine(g_exeBase + kRvaContinue);

    for (const Fix& fix : fixes) {
        const intptr_t rel = labels[fix.label] - (fix.field + 4);
        memcpy(fix.field, &rel, 4);
    }
    g_cave = p;
    return start;
}

// Called on the UI thread the first time the engine asks for the width table.
void* __cdecl WidthThunk() {
    void* table = g_getWidthTable ? g_getWidthTable() : nullptr;
    if (table && g_ready.load(std::memory_order_acquire) &&
        InterlockedCompareExchange(&g_applied, 1, 0) == 0) {
        unsigned char* bytes = (unsigned char*)table;
        int changed = 0;
        for (uint16_t cp : g_promote) {
            if (bytes[cp] == 1) {
                bytes[cp] = 2;
                ++changed;
            }
        }
        SMF_INFO("textfix: width table %p, %d glyph(s) promoted to full width",
                 table, changed);
    }
    return table;
}

bool rel32Fits(const void* from, const void* to) {
    const intptr_t d = (const BYTE*)to - ((const BYTE*)from + 5);
    return d > -0x70000000LL && d < 0x70000000LL;
}

}  // namespace

void SmfTextFixPatch() {
    HMODULE host = GetModuleHandleW(nullptr);
    if (!host) return;
    g_exeBase = (uintptr_t)host;

    // Code cave for the two limit checks.  Kept near the executable so the
    // 32-bit relative jumps are guaranteed to reach.
    void* cave = VirtualAlloc((void*)0x10000000, 4096, MEM_COMMIT | MEM_RESERVE,
                              PAGE_EXECUTE_READWRITE);
    if (!cave) {
        cave = VirtualAlloc(nullptr, 4096, MEM_COMMIT | MEM_RESERVE,
                            PAGE_EXECUTE_READWRITE);
    }
    if (!cave) {
        SMF_WARN("textfix: cannot allocate code cave (%lu)", GetLastError());
        return;
    }
    g_caveBase = (BYTE*)cave;
    g_cave = g_caveBase;

    // Mode A: "mov eax,[esi+0x18]; add eax,edx" right before the limit compare.
    {
        static const unsigned char kGuard[5] = {0x8B, 0x46, 0x18, 0x03, 0xC2};
        const uintptr_t site = g_exeBase + kRvaLimitA;
        if (verifyBytes(site, kGuard, 5)) {
            BYTE* thunk = buildLimitThunk(false);
            if (rel32Fits((const void*)site, thunk)) {
                unsigned char patch[5] = {0xE9, 0, 0, 0, 0};
                const intptr_t rel = (intptr_t)thunk - (intptr_t)(site + 5);
                memcpy(patch + 1, &rel, 4);
                g_patchedA = writeBytes(site, patch, 5);
            }
        }
    }
    // Mode B: the same test, one instruction earlier (the pen position is still
    // in eax there).
    {
        static const unsigned char kGuard[6] = {0x89, 0x85, 0xBC, 0xFB, 0xFF, 0xFF};
        const uintptr_t site = g_exeBase + kRvaLimitB;
        if (verifyBytes(site, kGuard, 6)) {
            BYTE* thunk = buildLimitThunk(true);
            if (rel32Fits((const void*)site, thunk)) {
                unsigned char patch[6] = {0xE9, 0, 0, 0, 0, 0x90};
                const intptr_t rel = (intptr_t)thunk - (intptr_t)(site + 5);
                memcpy(patch + 1, &rel, 4);
                g_patchedB = writeBytes(site, patch, 6);
            }
        }
    }
    FlushInstructionCache(GetCurrentProcess(), g_caveBase, 1024);

    // Width table: route the getter through our thunk so the freshly built
    // table can be corrected once.
    g_getWidthTable = (WidthTableFn)(g_exeBase + kRvaWidthGetter);
    {
        const uintptr_t callSite = g_exeBase + kRvaWidthCall;
        static const unsigned char kGuardCall[5] = {0xE8, 0xA1, 0x4A, 0xF7, 0xFF};
        if (verifyBytes(callSite, kGuardCall, 5)) {
            unsigned char repl[5];
            repl[0] = 0xE8;
            const intptr_t rel = (intptr_t)((uintptr_t)&WidthThunk - (callSite + 5));
            memcpy(repl + 1, &rel, 4);
            g_patchedCall = writeBytes(callSite, repl, 5);
        }
    }
}

void SmfTextFixInit() {
    // Characters that Shift-JIS encodes with two bytes are full width in the
    // Japanese build.  CP932 is queried directly so the result does not depend
    // on the current system code page.
    std::vector<uint16_t> promote;
    promote.reserve(8192);
    for (unsigned cp = 0x80; cp < 0x10000; ++cp) {
        if (cp >= 0xD800 && cp <= 0xDFFF) continue;
        const wchar_t ch = (wchar_t)cp;
        char mb[8] = {};
        const int n = WideCharToMultiByte(932, 0, &ch, 1, mb, (int)sizeof(mb),
                                          nullptr, nullptr);
        if (n == 2) promote.push_back((uint16_t)cp);
    }
    g_promote.swap(promote);
    g_ready.store(true, std::memory_order_release);

    SMF_INFO("textfix: wrap limit A=%d B=%d, width hook=%d, %d candidates",
             g_patchedA ? 1 : 0, g_patchedB ? 1 : 0, g_patchedCall ? 1 : 0,
             (int)g_promote.size());
    if (!g_patchedA && !g_patchedB) {
        SMF_WARN("textfix: line-break patch sites not found (engine build changed?)");
    }
    if (!g_patchedCall) {
        SMF_WARN("textfix: width table call site not found (engine build changed?)");
    }
}