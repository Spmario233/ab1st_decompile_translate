// Loads DllDecodeTest.dll and calls DllRunDecode on a file path.
#define WIN32_LEAN_AND_MEAN
#define NOMINMAX
#include <windows.h>
#include <stdio.h>

typedef int (*PFN)(const char*);

int main(int argc, char** argv) {
    if (argc < 2) { printf("usage: dlltest_host <file>\n"); return 2; }
    HMODULE d = LoadLibraryA("DllDecodeTest.dll");
    if (!d) { printf("LoadLibrary failed: %lu\n", GetLastError()); return 3; }
    PFN fn = (PFN)GetProcAddress(d, "DllRunDecode");
    if (!fn) { printf("no export\n"); return 4; }
    int r = fn(argv[1]);
    printf("DllRunDecode -> %d\n", r);
    FreeLibrary(d);
    return r;
}
