"""Build a plate-space mosaic of the (already memory-filtered) artwork for each of the four plates.

Because the filter lives in plate space (verified), every frame of a plate's display
period is a warp of the *same* filtered artwork, so the artwork can be recombined in
plate coordinates.  Subtitles are rejected by comparing each warped frame against the
running mosaic.
"""
import os, sys, time, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
PLATES = ['eviw_0801.png', 'eviw_0301.png', 'eviw_0401.png', 'eviw_0701.png']
# Period over which SIFT fits are collected and the mosaic is accumulated.
PERIOD = {
    'eviw_0801.png': (874, 1428),
    'eviw_0301.png': (1425, 1992),
    'eviw_0401.png': (1990, 2572),
    'eviw_0701.png': (2556, 3320),
}
# Period over which the *trajectory* is emitted.  A plate takes part in a dissolve before it
# becomes the dominant one (and after it stops), and SIFT cannot fit it there -- but
# render_full.M_of() clamps n into the emitted range, so a range that stops at the plate's own
# period freezes the incoming artwork during the first half of every dissolve.  Emit the
# trajectory across the whole dissolve window instead; the ends are filled by the local
# quadratic extrapolation below.
TRAJ_RANGE = {
    'eviw_0801.png': (874, 1462),      # dissolve a runs to 1462
    'eviw_0301.png': (1374, 2026),     # dissolve a starts at 1374, dissolve b ends at 2026
    'eviw_0401.png': (1943, 2572),     # dissolve b starts at 1943
    'eviw_0701.png': (2556, 3320),     # dissolve c intentionally left untouched
}


def sim_params(A):
    return np.array([np.hypot(A[0, 0], A[1, 0]), np.arctan2(A[1, 0], A[0, 0]), A[0, 2], A[1, 2]])


def sim_from_params(p):
    s, th, tx, ty = p
    c, sn = np.cos(th) * s, np.sin(th) * s
    return np.array([[c, -sn, tx], [sn, c, ty]], np.float32)


def smooth_local(v, w=41, deg=3):
    """Local polynomial smoothing.  Reads only the INPUT values (no in-place feedback),
    which matters at the array ends where the window is truncated."""
    n = len(v)
    y = v.copy()
    for i in range(n):
        a, b = max(0, i - w // 2), min(n, i + w // 2 + 1)
        seg = v[a:b]
        m = np.isfinite(seg)
        if m.sum() < deg + 2:
            continue
        tt = np.arange(a, b)[m]
        c = np.polyfit(tt, seg[m], deg)
        y[i] = np.polyval(c, i)
    return y


TOL = (0.02, 0.40, 6.0, 6.0)     # scale, rot(deg), tx, ty


def robust_keep(P, w=25):
    """Drop SIFT fits that disagree with the local median (degenerate RANSAC results)."""
    n = len(P)
    keep = np.ones(n, bool)
    for c in range(4):
        med = np.array([np.median(P[max(0, i - w // 2):i + w // 2 + 1, c]) for i in range(n)])
        keep &= np.abs(P[:, c] - med) < TOL[c]
    return keep


def build_traj():
    d = np.load(os.path.join(WS, 'geo_full.npz'))
    lo, hi = int(d['lo']), int(d['hi'])
    plates = [str(x) for x in d['plates']]
    M = d['M']; ninl = d['ninl']
    t = np.arange(lo, hi + 1)
    traj = {}
    for pname in PLATES:
        j = plates.index(pname)
        p0, p1 = PERIOD[pname]
        sel = (t >= p0) & (t <= p1) & (ninl[:, j] >= 20) & np.isfinite(M[:, j, 0, 0])
        idx = np.nonzero(sel)[0]
        P = np.array([sim_params(M[i, j]) for i in idx])
        keep = robust_keep(P)
        idx = idx[keep]
        P = P[keep]
        print('   %s usable %d frames (%d rejected)' % (pname[5:9], len(idx), int((~keep).sum())))
        for c in range(4):
            P[:, c] = smooth_local(P[:, c], 41, 3)
        # extrapolate to both ends with a local quadratic on the smoothed tail
        def extrap(tt):
            outv = np.full(len(tt), np.nan)
            for c in range(4):
                k = min(80, len(idx))
                head = np.polyfit(t[idx[:k]], P[:k, c], 2)
                tail = np.polyfit(t[idx[-k:]], P[-k:, c], 2)
                vals = np.where(tt < t[idx[0]], np.polyval(head, tt), np.polyval(tail, tt))
                inv = (tt >= t[idx[0]]) & (tt <= t[idx[-1]])
                vals = np.where(inv, np.interp(tt, t[idx], P[:, c]), vals)
                outv = vals if c == 0 else np.vstack([outv, vals])
            return outv.T
        tt = np.arange(TRAJ_RANGE[pname][0], TRAJ_RANGE[pname][1] + 1)
        traj[pname] = (tt, extrap(tt))
        print('%s traj %d..%d (fits %d..%d)' % (pname[5:9], tt[0], tt[-1], p0, p1), flush=True)
    with open(os.path.join(WS, 'traj_smooth.pkl'), 'wb') as f:
        pickle.dump({k: (v[0], v[1]) for k, v in traj.items()}, f)
    return traj


def warp_to_plate(img, Minv):
    return cv2.warpAffine(img, Minv, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)


def build_mosaic(pname, traj, passes=3, verbose=True):
    tt, P = traj[pname]
    n0, n1 = int(tt[0]), int(tt[-1])
    ref = None
    thr = [1e9, 18.0, 10.0, 8.0]
    for it in range(passes):
        num = np.zeros((H, W, 3), np.float64)
        cnt = np.zeros((H, W), np.float64)
        t0 = time.time()
        for k, n in enumerate(range(n0, n1 + 1)):
            M = sim_from_params(P[k])
            Minv = cv2.invertAffineTransform(M)
            g = pf.frame_gray(n)
            if g.std() < 1.0:
                continue
            F = pf.frame_rgb(n).astype(np.float32)
            wp = warp_to_plate(F, Minv)
            wc = warp_to_plate(np.ones((H, W), np.float32), Minv)
            if ref is None:
                w = (wc > 0.99)
            else:
                rw = warp_to_plate(ref, M)          # mosaic -> screen
                rp = warp_to_plate(rw, Minv)        # back to plate space (matched sampling)
                w = (wc > 0.99) & (np.abs(wp - rp).max(axis=2) < thr[it])
            num += wp * w[..., None]
            cnt += w
        m = num / np.maximum(cnt, 1e-9)[..., None]
        m[cnt < 3] = np.nan
        if verbose:
            print('   pass %d: %.0fs  covered %.3f' % (it, time.time() - t0, (cnt >= 3).mean()), flush=True)
        ref = m
    return m


if __name__ == '__main__':
    pk = os.path.join(WS, 'traj_smooth.pkl')
    if os.path.exists(pk):
        with open(pk, 'rb') as f:
            traj = pickle.load(f)
    else:
        traj = build_traj()
    for pname in PLATES:
        print('mosaic %s' % pname[5:9], flush=True)
        m = build_mosaic(pname, traj, passes=3)
        np.save(os.path.join(WS, 'mosaic_%s.npy' % pname[5:9]), m.astype(np.float32))
        from PIL import Image
        vis = np.nan_to_num(m, nan=255).clip(0, 255).astype(np.uint8)
        Image.fromarray(vis).save(os.path.join(WS, 'diag_mosaic_%s.png' % pname[5:9]))
