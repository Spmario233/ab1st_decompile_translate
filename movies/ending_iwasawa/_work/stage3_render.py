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
N_END = 2165


def log(*a):
    print(*a, flush=True)


# --------------------------------------------------------------------- inputs
M = np.load(os.path.join(W, "mosaic_final.npy"))
U_lo, H = (int(v) for v in np.load(os.path.join(W, "ulo_final.npy")))
cum = np.load(os.path.join(W, "cum_final.npy"))
NUSE = len(cum)
log(f"mosaic {M.shape} U_lo={U_lo} H={H}  cum n=0..{NUSE-1}")

xs = np.arange(NUSE - 400, NUSE, dtype=np.float64)
co = np.polyfit(xs, cum[-400:], 2)
cum_ext = np.zeros(N_END + 1)
cum_ext[:NUSE] = cum
cum_ext[NUSE:] = np.polyval(co, np.arange(NUSE, N_END + 1))
log(f"cum extrapolation: n={NUSE}->{cum_ext[NUSE]:.2f}  n={N_END}->{cum_ext[N_END]:.2f}")


def sample(Mx, u_base, c):
    g = c - u_base
    g0 = int(np.floor(g))
    f = g - g0
    return (Mx[:, g0:g0 + H0] * (1 - f) + Mx[:, g0 + 1:g0 + 1 + H0] * f)


def sample_rows(Mx, u_base, c, ystart, nrows):
    g = c + ystart - u_base
    g0 = int(np.floor(g))
    f = g - g0
    return (Mx[:, g0:g0 + nrows] * (1 - f) + Mx[:, g0 + 1:g0 + 1 + nrows] * f)


# ------------------------------------------------------------- 1. fade factors
log("=== fitting fade factors ===")
fade = np.ones(N_END + 1)
for n in range(560, N_END + 1):
    c = float(cum_ext[n])
    ystart = int(np.ceil(U_lo - c))
    ystart = max(0, min(ystart, H0 - 1))
    R = sample_rows(M, U_lo, c, ystart, H0 - ystart)
    F = np.asarray(MM[min(n, NF - 1)], dtype=np.float32)[:, ystart:, :]
    ry, ru, rv = R[0][:, BAND], R[1][:, BAND] - 128.0, R[2][:, BAND] - 128.0
    fy, fu, fv = F[0][:, BAND], F[1][:, BAND] - 128.0, F[2][:, BAND] - 128.0
    den = float((ry * ry).sum() + (ru * ru).sum() + (rv * rv).sum())
    if den <= 0:
        continue
    num = float((fy * ry).sum() + (fu * ru).sum() + (fv * rv).sum())
    fade[n] = num / den
np.save(os.path.join(W, "fade.npy"), fade)
for t in [18, 20, 22, 23, 30, 40, 50, 60, 65, 68, 68.5, 68.6, 68.7, 69, 69.5, 70, 70.5, 71, 71.5, 72]:
    n = int(round(t * 30))
    if n <= N_END:
        log(f"  t={t:5.2f} n={n:4d}  fade={fade[n]:.5f}")
log(f"  fade max over n<2058 = {fade[:NUSE].max():.5f}, min = {fade[:NUSE].min():.5f}")

# ---------------------------------------------------- 2. extend the mosaic grid
U_ext = int(np.floor(cum_ext.min()))
EXTRA = U_lo - U_ext
log(f"=== extending mosaic from u={U_lo} down to u={U_ext} ({EXTRA} rows) ===")
# per frame, which extra rows does it show?
jobs = [[] for _ in range(N_END + 1)]
for i in range(EXTRA):
    u = U_ext + i
    yv = u - cum_ext
    for n in np.nonzero((yv >= 0) & (yv <= H0 - 1))[0]:
        if fade[n] >= 0.25:
            jobs[n].append((i, int(round(yv[n])), float(fade[n])))
cnt = np.zeros(EXTRA, dtype=int)
samp = [[None] * 64 for _ in range(EXTRA)]
wgt = [[0.0] * 64 for _ in range(EXTRA)]
for n in range(N_END + 1):
    if not jobs[n]:
        continue
    fr = np.asarray(MM[min(n, NF - 1)], dtype=np.float32)
    for i, y, f in jobs[n]:
        k = cnt[i]
        if k < 64:
            v = fr[:, y, :].copy()
            # invert the fade: Y' = f*Y,  U' = 128 + f*(U-128)   (V likewise)
            v[0] /= f
            v[1] = 128.0 + (v[1] - 128.0) / f
            v[2] = 128.0 + (v[2] - 128.0) / f
            samp[i][k] = v
            wgt[i][k] = f * f
            cnt[i] += 1
ext = np.zeros((3, EXTRA, W0), dtype=np.float32)
for i in range(EXTRA):
    k = cnt[i]
    if k == 0:
        continue
    S = np.stack(samp[i][:k])                     # (k,3,W0)
    ww = np.asarray(wgt[i][:k], dtype=np.float64)
    order = np.argsort(S, axis=0)                 # (k,3,W0)
    cw = np.cumsum(ww[order], axis=0)
    tot = cw[-1]
    pick = (cw < tot / 2.0).sum(axis=0)
    pick = np.clip(pick, 0, k - 1)
    vals = np.take_along_axis(S, order, axis=0)
    ext[:, i, :] = np.take_along_axis(vals, pick[None, :, :], axis=0)[0]
log(f"  extension rows with data: {(cnt>0).sum()}/{EXTRA}  median samples/row={int(np.median(cnt))}")
# rows with no usable sample: carry the nearest reconstructed row across
first = next((i for i in range(EXTRA) if cnt[i] > 0), None)
if first is None:
    raise SystemExit("no extension rows reconstructed")
for i in range(first):
    ext[:, i, :] = ext[:, first, :]
last = first
for i in range(first, EXTRA):
    if cnt[i] > 0:
        last = i
    else:
        ext[:, i, :] = ext[:, last, :]
prof = ext[0].mean(axis=1)
log("  ext Ymean profile (u ascending): " + " ".join(f"{v:.1f}" for v in prof[::8]))
log(f"  boundary: ext last row Ymean={prof[-1]:.2f}   mosaic first row Ymean={M[0][0].mean():.2f}")

Mext = np.concatenate([ext, M], axis=1)
np.save(os.path.join(W, "mosaic_ext.npy"), Mext)
np.save(os.path.join(W, "cum_ext.npy"), cum_ext)
np.save(os.path.join(W, "u_ext.npy"), np.array([U_ext, Mext.shape[1]]))
log(f"Mext {Mext.shape}")

# --------------------------------------------------- 3. text / black boundaries
log("=== boundaries ===")
N_TEXT = None
for n in range(600, 840):
    c = float(cum_ext[n])
    R = sample(Mext, U_ext, c)
    F = np.asarray(MM[n], dtype=np.float32)
    dev = float(np.abs(F - R).max())
    if N_TEXT is None and dev > 80:
        N_TEXT = n
    if n % 10 == 0 or (N_TEXT and n < N_TEXT + 3):
        log(f"  n={n:4d} t={n/30:6.2f}  max|F-sky|={dev:7.1f}")
N_BLACK = N_END + 1
for n in range(NUSE, N_END + 1):
    c = float(cum_ext[n])
    R = sample(Mext, U_ext, c)
    if fade[n] * float(R[0].max()) < 0.5:
        N_BLACK = n
        break
log(f"N_TEXT={N_TEXT} (t={N_TEXT/30:.3f}s)   N_BLACK={N_BLACK} (t={N_BLACK/30:.3f}s)")
np.save(os.path.join(W, "bounds.npy"), np.array([N_TEXT, N_BLACK]))

# ------------------------------------------------------------------ 4. render
if len(sys.argv) > 1 and sys.argv[1] == "render":
    log("=== rendering ===")
    outp = os.path.join(W, "out_full.yuv")
    black = np.zeros((3, H0, W0), dtype=np.uint8)
    black[1] = 128
    black[2] = 128
    t0 = time.time()
    with open(outp, "wb") as fh:
        for n in range(N_TOTAL):
            if n < N_TEXT:
                fr = np.asarray(MM[n])
            elif n < N_BLACK:
                c = float(cum_ext[min(n, N_END)])
                R = sample(Mext, U_ext, c)
                f = fade[min(n, N_END)]
                out = np.empty((3, H0, W0), dtype=np.float32)
                out[0] = R[0] * f
                out[1] = 128.0 + (R[1] - 128.0) * f
                out[2] = 128.0 + (R[2] - 128.0) * f
                fr = np.clip(np.rint(out), 0, 255).astype(np.uint8)
            else:
                fr = black
            fh.write(np.ascontiguousarray(fr).tobytes())
            if n % 600 == 0:
                log(f"  frame {n}/{N_TOTAL}  ({time.time()-t0:.0f}s)")
    log(f"wrote {outp}  ({time.time()-t0:.0f}s)")
