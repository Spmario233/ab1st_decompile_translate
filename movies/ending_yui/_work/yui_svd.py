"""ending_yui: recover the static background plate from the video itself.

The illustration is static; only a global fade animates it.  Every pixel's
trajectory therefore lives in a low-dimensional temporal subspace, which the
text-free centre of the frame measures directly.  A robust regression of each
pixel onto those temporal modes then gives the background, with the darker
subtitle glyphs rejected as outliers.
"""
import os, time, sys
import numpy as np

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
RAW = os.path.join(W, "raw_0_62.yuv")
H0, W0 = 720, 1280
T = 1859
MM = np.memmap(RAW, dtype=np.uint8, mode="r", shape=(T, 3, H0, W0))


def log(*a):
    print(*a, flush=True)


# ---------------------------------------------------------------- white level
white = np.array([np.asarray(MM[T - 6, c]).mean() for c in range(3)])
log("white level at t=61.8s  (Y,U,V) =", np.round(white, 2))

# ------------------------------------------------- temporal modes from centre
CX0, CX1, CY0, CY1 = 460, 970, 0, 720
sub = (slice(CY0, CY1, 4), slice(CX0, CX1, 6))
npx = len(range(*sub[0].indices(H0))) * len(range(*sub[1].indices(W0)))
log(f"centre sample: {npx} px x 3 planes = {npx*3} columns, {T} frames")

D = np.empty((T, npx * 3), dtype=np.float32)
for t in range(T):
    fr = np.asarray(MM[t], dtype=np.float32)
    blk = np.concatenate([fr[c][sub] for c in range(3)], axis=0).reshape(-1)
    off = np.repeat(white, npx)
    D[t] = blk - off
log("data matrix built:", D.shape, f"{D.nbytes/1e9:.2f} GB")

t0 = time.time()
G = D @ D.T
log(f"temporal Gram computed ({time.time()-t0:.1f}s)")
ev, evec = np.linalg.eigh(G)
order = np.argsort(ev)[::-1]
ev = ev[order]; evec = evec[:, order]
tot = ev[ev > 0].sum()
log("top-12 eigenvalues (share of variance):")
for k in range(12):
    log(f"   mode {k+1:2d}: {ev[k]:14.4e}   {ev[k]/tot*100:7.3f} %   cumulative {ev[:k+1].sum()/tot*100:7.3f} %")

K = 6
U = evec[:, :K].astype(np.float64)          # (T, K) orthonormal temporal modes
np.save(os.path.join(W, "yui_modes.npy"), U)
np.save(os.path.join(W, "yui_white.npy"), white)
log(f"saved {K} temporal modes")
