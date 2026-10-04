"""Mosaic v6 — rebuild the plate mosaics using only provably clean pixels.

The subtitle sits at a nearly fixed *screen* position, which for plate 0801 maps to a
nearly fixed *plate* position (the camera barely moves that point), so a plain temporal
median keeps the glyph cores and their bright halo.  Instead we take each plate's exact
clean anchor frame (one of the four `refrences\\00NNNN.png`, which are pixel-identical to
the video), warp it onto every other frame, and use the residual to mark subtitle pixels.
Pixels the anchor does not cover fall back to the current mosaic model.
"""
import os, sys, time, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
from mosaic_build import sim_from_params, PLATES

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
ANCHOR = {'eviw_0801.png': ('001167.png', 1049),
          'eviw_0301.png': ('001842.png', 1724),   # 001576 was itself not clean (user, 2026-10)
          'eviw_0401.png': ('002160.png', 2042),
          'eviw_0701.png': ('002810.png', 2692)}
PERIOD = {'eviw_0801.png': (874, 1425),
          'eviw_0301.png': (1420, 1990),
          'eviw_0401.png': (1988, 2570),
          'eviw_0701.png': (2556, 3320)}


def rel(Mn, Ma):
    return (np.vstack([Mn, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]


def build(pname, traj, prev, iters=3, thr_anchor=22.0, thr_model=26.0, dil=3, verbose=True):
    tt, P = traj[pname]
    n0, n1 = int(tt[0]), int(tt[-1])
    refname, nanchor = ANCHOR[pname]
    anchor = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname)).astype(np.float32)
    Ma = sim_from_params(P[nanchor - n0])
    kern = np.ones((dil, dil), np.uint8)
    cur = prev.copy()
    wt = None
    for it in range(iters):
        num = np.zeros((H, W, 3), np.float64)
        acc = np.zeros((H, W), np.float64)
        t0 = time.time()
        for k, n in enumerate(range(n0, n1 + 1)):
            M = sim_from_params(P[k]); Minv = cv2.invertAffineTransform(M)
            F = pf.frame_rgb(n).astype(np.float32)
            # (a) anchor-based subtitle mask (reliable where the anchor covers)
            R = rel(M, Ma)
            A = cv2.warpAffine(anchor, R, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT, borderValue=(255, 255, 255))
            cA = cv2.warpAffine(np.ones((H, W), np.float32), R, (W, H), flags=cv2.INTER_LINEAR,
                                borderMode=cv2.BORDER_CONSTANT, borderValue=0)
            dA = np.abs(F - A).max(axis=2)
            mask = (cA > 0.99) & (dA > thr_anchor)
            # (b) fall back to the current mosaic model where the anchor does not reach
            den = cv2.warpAffine(cur, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE
            v = np.abs(den).max(axis=2) > 25
            if v.sum() > 1000:
                a = F - WHITE
                s = float((a * den)[v].sum() / max((den * den)[v].sum(), 1e-9))
                s = min(max(s, 0.2), 3.0)
            else:
                s = 1.0
            bg = WHITE + s * den
            mask |= (cA <= 0.99) & (np.abs(F - bg).max(axis=2) > thr_model)
            mask = cv2.dilate(mask.astype(np.uint8), kern).astype(bool)
            wp = cv2.warpAffine(F, Minv, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
            wp = WHITE + (wp - WHITE) / s
            wm = cv2.warpAffine((~mask).astype(np.float32), Minv, (W, H), flags=cv2.INTER_LINEAR)
            w = wm > 0.99
            num += wp * w[..., None]
            acc += w
        c = np.maximum(acc, 1e-9)
        new = num / c[..., None]
        hole = acc < 2
        new[hole] = cur[hole]
        if verbose:
            print('   %s iter %d: %.0fs  used %.4f  holes %.4f' %
                  (pname[5:9], it, time.time() - t0, (acc >= 2).mean(), hole.mean()), flush=True)
        cur = new
        wt = acc
    return cur, wt


if __name__ == '__main__':
    with open(os.path.join(WS, 'traj_smooth.pkl'), 'rb') as f:
        traj = pickle.load(f)
    want = sys.argv[1:] or PLATES
    for pname in PLATES:
        if pname not in want and pname[5:9] not in want:
            continue
        print('mosaic6 %s' % pname[5:9], flush=True)
        prev = np.load(os.path.join(WS, 'mosaic5_%s.npy' % pname[5:9])).astype(np.float32) \
            if os.path.exists(os.path.join(WS, 'mosaic5_%s.npy' % pname[5:9])) \
            else np.load(os.path.join(WS, 'mosaic6_%s.npy' % pname[5:9])).astype(np.float32)
        m, w = build(pname, traj, prev, iters=3)
        np.save(os.path.join(WS, 'mosaic6_%s.npy' % pname[5:9]), m.astype(np.float32))
        np.save(os.path.join(WS, 'mosweight_%s.npy' % pname[5:9]), w.astype(np.float32))
        from PIL import Image
        Image.fromarray(np.clip(m, 0, 255).astype(np.uint8)).save(
            os.path.join(WS, 'diag_mosaic6_%s.png' % pname[5:9]))
