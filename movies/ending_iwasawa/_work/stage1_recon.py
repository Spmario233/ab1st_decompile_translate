"""
Stage 1 (final): reconstruct the tall sky mosaic.

  1. offset track from long-baseline sub-pixel band-profile matches
     (short baselines are systematically biased)
  2. robust median mosaic over a random sample of frames per master row
  3. iterative registration of every frame against the mosaic (2-D band SSD)
     alternating with robust re-accumulation  ->  sharp, text-free master image

Coordinate system: master row  u = cum[n] + y   (frame n, video row y),  cum[0] = 0.
Layout used everywhere:  M[channel, row, col].
"""
import os, time, sys
import numpy as np

W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
RAW = os.path.join(W, "raw_0_73.yuv")
NF, H0, W0 = 2190, 720, 1280
MM = np.memmap(RAW, dtype=np.uint8, mode="r", shape=(NF, 3, H0, W0))
BANDS = [(0, 400), (880, 1280)]
NUSE = 2058                    # frames 0..2057 = t <= 68.57 s, before the fade
K = 81
RNG = np.random.default_rng(20240517)
YS = np.arange(H0, dtype=np.float64)
YS2 = np.arange(0, H0, 2, dtype=np.float64)


def log(*a):
    print(*a, flush=True)


BP = np.load(os.path.join(W, "bp_y.npy")).reshape(NF, 2, H0)


def prof_ssd(nA, nB, s):
    pos = s + YS
    i0 = np.floor(pos).astype(int)
    f = pos - i0
    ok = (i0 >= 0) & (i0 + 1 < H0)
    if ok.sum() < 200:
        return np.nan
    i0c = np.clip(i0, 0, H0 - 2)
    v = BP[nA][:, i0c] * (1 - f) + BP[nA][:, i0c + 1] * f
    d = BP[nB][:, ok] - v[:, ok]
    return float(np.mean(d * d))


def prof_match(nA, nB, pred, span, step=0.02):
    ss = np.arange(pred - span, pred + span + 1e-9, step)
    vals = np.array([prof_ssd(nA, nB, s) for s in ss])
    i = int(np.nanargmin(vals))
    sub = 0.0
    if 0 < i < len(vals) - 1 and np.isfinite(vals[i - 1]) and np.isfinite(vals[i + 1]):
        y0, y1, y2 = vals[i - 1], vals[i], vals[i + 1]
        den = y0 - 2 * y1 + y2
        if den != 0:
            sub = float(np.clip(0.5 * (y0 - y2) / den, -1, 1))
    return ss[i] + sub * step, float(vals[i])


def offset_track(step_frames=60, span=3.0):
    """Piecewise-linear offset track; slope carried forward between anchors."""
    anchors_n = list(range(0, NUSE, step_frames))
    if anchors_n[-1] != NUSE - 1:
        anchors_n.append(NUSE - 1)
    a0 = anchors_n[0]
    cum = {a0: 0.0}
    prev_slope = -0.815                        # px per frame (measured)
    edge = 0
    for i in range(1, len(anchors_n)):
        n, m = anchors_n[i - 1], anchors_n[i]
        span_f = m - n
        pred = prev_slope * span_f
        s, v = prof_match(n, m, pred, span=span, step=0.02)
        if abs(s - pred) > span - 4 * 0.02:
            edge += 1
        cum[m] = cum[n] + s
        prev_slope = s / span_f
    if edge:
        log(f"    WARNING step={step_frames}: {edge} measurements hit the search edge")
    out = np.zeros(NUSE)
    for i in range(1, len(anchors_n)):
        n, m = anchors_n[i - 1], anchors_n[i]
        for j in range(1, m - n + 1):
            out[n + j] = cum[n] + (cum[m] - cum[n]) * j / (m - n)
        out[m] = cum[m]
    out[0] = 0.0
    return out


# ---------------------------------------------------------------------------
def build_assignments(cum):
    U_lo = int(np.floor(cum.min()))
    H = H0 - U_lo + 1
    assign = [[] for _ in range(len(cum))]
    for ui in range(H):
        u = U_lo + ui
        yv = u - cum
        n0 = int(np.searchsorted(yv, 0.0, "left"))
        n1 = int(np.searchsorted(yv, H0 - 0.5, "right")) - 1
        if n1 < n0:
            continue
        cnt = n1 - n0 + 1
        k = min(K, cnt)
        idx = np.arange(n0, n1 + 1) if k == cnt else np.sort(RNG.choice(cnt, k, replace=False)) + n0
        for slot, nn in enumerate(idx):
            assign[nn].append((ui, slot, float(yv[nn])))
    return U_lo, H, assign


def median_mosaic(cum):
    t0 = time.time()
    U_lo, H, assign = build_assignments(cum)
    log(f"    assign H={H} u_lo={U_lo} ({time.time()-t0:.1f}s)")
    stack = np.zeros((H, K, 3, W0), dtype=np.uint8)
    cnt = np.zeros(H, dtype=np.int32)
    for n in range(len(cum)):
        al = assign[n]
        if not al:
            continue
        fr = np.asarray(MM[n])
        for ui, slot, yf in al:
            y0 = int(round(yf))
            y0 = 0 if y0 < 0 else (H0 - 1 if y0 > H0 - 1 else y0)
            stack[ui, slot] = fr[:, y0, :]
            cnt[ui] += 1
    M = np.zeros((3, H, W0), dtype=np.float32)
    for ui in range(H):
        k = int(cnt[ui])
        if k:
            M[:, ui, :] = np.partition(stack[ui, :k].astype(np.float32), k // 2, axis=0)[k // 2]
    del stack
    log(f"    median done ({time.time()-t0:.1f}s) rows={H} empty={(cnt==0).sum()}")
    return M, U_lo, H


# ---------------------------------------------------------------------------
def frame_bands(n):
    fr = np.asarray(MM[n], dtype=np.float32)
    return np.concatenate([fr[:, :, a:b][:, ::2, ::4] for a, b in BANDS], axis=2)


def mosaic_bands(M):
    return np.concatenate([M[:, :, a:b][:, :, ::4] for a, b in BANDS], axis=2)


def reg_ssd(Fs, Mb, U_lo, H, c, s):
    """SSD between a frame's bands and the mosaic at frame offset c+s.

    Rows are sampled on a fixed stride, so the mosaic rows needed at a given
    shift form a plain strided slice and the interpolation weight is constant.
    """
    g = c + s - U_lo
    g0 = int(np.floor(g))
    f = g - g0
    ylo = max(0, -g0)
    if ylo % 2:
        ylo += 1
    yhi = min(H0 - 1, H - 2 - g0)
    if yhi % 2:
        yhi -= 1
    if yhi - ylo < 200:
        return np.nan
    aa = Mb[:, g0 + ylo:g0 + yhi + 1:2]
    bb = Mb[:, g0 + ylo + 1:g0 + yhi + 2:2]
    v = aa * (1.0 - f) + bb * f
    d = Fs[:, ylo // 2:yhi // 2 + 1, :] - v
    return float(np.mean(d * d))


def register(cum, M, U_lo, H, span=3.0, step=0.25, stride=1):
    t0 = time.time()
    Mb = mosaic_bands(M)
    ss = np.arange(-span, span + 1e-9, step)
    idxs = list(range(0, len(cum), stride))
    new = cum.copy()
    moved = np.zeros(len(idxs))
    for k, n in enumerate(idxs):
        Fs = frame_bands(n)
        vals = np.array([reg_ssd(Fs, Mb, U_lo, H, cum[n], s) for s in ss])
        i = int(np.nanargmin(vals))
        sub = 0.0
        if 0 < i < len(vals) - 1:
            y0, y1, y2 = vals[i - 1], vals[i], vals[i + 1]
            den = y0 - 2 * y1 + y2
            if den != 0:
                sub = float(np.clip(0.5 * (y0 - y2) / den, -1, 1))
        d = ss[i] + sub * step
        new[n] = cum[n] + d
        moved[k] = d
    new[0] = 0.0
    log(f"    register ({time.time()-t0:.1f}s) |d| mean={np.abs(moved).mean():.4f} "
        f"max={np.abs(moved).max():.4f} p99={np.percentile(np.abs(moved),99):.4f} "
        f"edge_hits={int((np.abs(moved)>span-2*step).sum())}")
    return new


def rows_clamped(M, start, n):
    """M[:, clamp(start+y, 0, rows-1)] for y in 0..n-1  ->  (3, n, W0)."""
    rows, Wd = M.shape[1], M.shape[2]
    out = np.empty((3, n, Wd), dtype=np.float32)
    a0 = max(0, start)
    a1 = min(rows, start + n)
    y0 = a0 - start
    y1 = y0 + max(0, a1 - a0)
    if a1 > a0:
        out[:, y0:y1] = M[:, a0:a1]
    if y0 > 0:
        out[:, :y0] = M[:, 0:1]
    if y1 < n:
        out[:, y1:] = M[:, rows - 1:rows]
    return out


def accumulate(cum, Mref, U_lo_ref, H_ref, thresh):
    """Robust accumulation with sub-pixel resampling, rejecting outliers vs Mref."""
    t0 = time.time()
    U_lo = int(np.floor(cum.min()))
    H = H0 - U_lo + 1
    acc = np.zeros((3, H, W0), dtype=np.float64)
    wsum = np.zeros((H, W0), dtype=np.float64)
    nrej = 0
    for n in range(len(cum)):
        c = float(cum[n])
        base = int(np.floor(c))
        f = c - base
        fr = np.asarray(MM[n], dtype=np.float32)
        lo = base - U_lo_ref
        if lo >= 0 and lo + H0 + 1 <= Mref.shape[1]:
            ref = Mref[:, lo:lo + H0] * (1 - f) + Mref[:, lo + 1:lo + 1 + H0] * f
        else:
            ref = rows_clamped(Mref, lo, H0) * (1 - f) + rows_clamped(Mref, lo + 1, H0) * f
        dev = np.abs(fr - ref).max(axis=0)
        m = dev <= thresh
        nrej += int(m.size - m.sum())
        mf = m[None, :, :]
        idx = base - U_lo
        wlo = 1.0 - f
        if wlo > 0:
            acc[:, idx:idx + H0] += np.where(mf, fr * wlo, 0.0)
            wsum[idx:idx + H0] += np.where(m, wlo, 0.0)
        if f > 0:
            acc[:, idx + 1:idx + 1 + H0] += np.where(mf, fr * f, 0.0)
            wsum[idx + 1:idx + 1 + H0] += np.where(m, f, 0.0)
    M = np.zeros((3, H, W0), dtype=np.float32)
    M[1] = 128.0
    M[2] = 128.0
    good = wsum > 0
    for ch in range(3):
        M[ch] = np.where(good, acc[ch] / np.maximum(wsum, 1e-9), M[ch])
    log(f"    accumulate ({time.time()-t0:.1f}s) rejected={nrej/(len(cum)*H0*W0)*100:.3f}% "
        f"uncovered_px={(~good).sum()}")
    return M, U_lo, H


if __name__ == "__main__":
    mode = sys.argv[1] if len(sys.argv) > 1 else "all"

    if mode in ("all", "track"):
        for sf, sp in ((30, 4.0), (60, 4.0), (120, 5.0)):
            c = offset_track(sf, sp)
            np.save(os.path.join(W, f"cum_trk{sf}.npy"), c)
            log(f"track step={sf}: min={c.min():.2f}  cum@600={c[600]:.2f} "
                f"@1200={c[1200]:.2f} @2057={c[2057]:.2f}")

    if mode in ("all", "mosaic"):
        cum = np.load(os.path.join(W, "cum_trk60.npy"))
        log("=== median mosaic from track ===")
        M, U_lo, H = median_mosaic(cum)
        log("=== diagnostic registration against median mosaic ===")
        register(cum, M, U_lo, H, span=8.0, step=0.5, stride=10)
        np.save(os.path.join(W, "mosaic_a.npy"), M)
        np.save(os.path.join(W, "ulo_a.npy"), np.array([U_lo, H]))

    if mode in ("all", "iterate"):
        cum = np.load(os.path.join(W, "cum_trk60.npy"))
        M = np.load(os.path.join(W, "mosaic_a.npy"))
        U_lo, H = np.load(os.path.join(W, "ulo_a.npy"))
        for it in range(4):
            log(f"=== iteration {it+1} ===")
            cum = register(cum, M, U_lo, H,
                           span=3.0 if it == 0 else 1.2,
                           step=0.25 if it == 0 else 0.1)
            np.save(os.path.join(W, f"cum_it{it+1}.npy"), cum)
            M, U_lo, H = accumulate(cum, M, U_lo, H, thresh=[12.0, 7.0, 5.0, 4.0][it])
            np.save(os.path.join(W, f"mosaic_it{it+1}.npy"), M)
            np.save(os.path.join(W, f"ulo_it{it+1}.npy"), np.array([U_lo, H]))
            log(f"  iter {it+1}: cum.min={cum.min():.2f} H={H} u_lo={U_lo}")
        np.save(os.path.join(W, "cum_final.npy"), cum)
        np.save(os.path.join(W, "mosaic_final.npy"), M)
        np.save(os.path.join(W, "ulo_final.npy"), np.array([U_lo, H]))
    log("done")
