"""
Stage 3: render the de-subtitled frame sequence.

   frames [0, N_TEXT)            : original frames, untouched
   frames [N_TEXT, N_BLACK)      : reconstructed sky * measured fade factor
   frames [N_BLACK, N_TOTAL)     : pure black (Y=0, U=V=128), matching the source
"""
import os, sys, time
import numpy as np

W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
RAW = os.path.join(W, "raw_0_73.yuv")
NF, H0, W0 = 2190, 720, 1280
MM = np.memmap(RAW, dtype=np.uint8, mode="r", shape=(NF, 3, H0, W0))
BAND = np.concatenate([np.arange(0, 400), np.arange(880, 1280)])
N_TOTAL = 7830


def log(*a):
    print(*a, flush=True)


M = np.load(os.path.join(W, "mosaic_final.npy"))          # (3,H,W0) stored YUV
U_lo, H = (int(v) for v in np.load(os.path.join(W, "ulo_final.npy")))
cum = np.load(os.path.join(W, "cum_final.npy"))           # n = 0..NUSE-1
NUSE = len(cum)
log(f"mosaic {M.shape}  U_lo={U_lo} H={H}  cum n=0..{NUSE-1} min={cum.min():.2f}")

N_END = 2165
# quadratic extrapolation of the offset track through the fade
xs = np.arange(NUSE - 400, NUSE, dtype=np.float64)
co = np.polyfit(xs, cum[-400:], 2)
cum_ext = np.zeros(N_END + 1)
cum_ext[:NUSE] = cum
cum_ext[NUSE:] = np.polyval(co, np.arange(NUSE, N_END + 1))
log(f"extrapolated cum: n={NUSE} -> {cum_ext[NUSE]:.2f}   n={N_END} -> {cum_ext[N_END]:.2f}")

# ---------------------------------------------------------------- extend grid
U_ext = int(np.floor(cum_ext.min()))
EXTRA = U_lo - U_ext
log(f"extending mosaic below u={U_lo} by {EXTRA} rows down to u={U_ext}")
ext = np.zeros((3, EXTRA, W0), dtype=np.float32)
for i in range(EXTRA):
    u = U_ext + i
    yv = u - cum_ext
    ns = np.nonzero((yv >= 0) & (yv <= H0 - 1))[0]
    if len(ns) == 0:
        continue
    fs = fade_vals = None
    vals = np.empty((len(ns), 3, W0), dtype=np.float32)
    for k, n in enumerate(ns):
        vals[k] = np.asarray(MM[min(n, NF - 1)], dtype=np.float32)
    rows = np.rint(yv[ns]).astype(int)
    samp = np.stack([vals[k, :, rows[k], :] for k in range(len(ns))])   # (S,3,W0)
    weights = np.ones(len(ns), dtype=np.float32)
    ext[:, i, :] = np.median(samp, axis=0)
log("  raw extension built")
np.save(os.path.join(W, "ext_rows.npy"), ext)
np.save(os.path.join(W, "cum_ext.npy"), cum_ext)
np.save(os.path.join(W, "u_ext.npy"), np.array([U_ext, EXTRA]))
log("done stage3-extend")
