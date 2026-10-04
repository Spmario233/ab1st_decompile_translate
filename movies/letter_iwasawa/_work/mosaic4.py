"""Mosaic refinement, stage 2: rebuild each plate mosaic discarding subtitle pixels,
identified by the frame-vs-current-mosaic residual (the subtitle has a dark core *and*
a bright halo over dark artwork, so the rejection must be two-sided)."""
import os, sys, time, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
from mosaic_build import sim_from_params, PERIOD, PLATES

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0


def refine(pname, traj, prev, passes=3, thr=(25.0, 20.0, 18.0), dil=3, verbose=True):
    tt, P = traj[pname]
    n0, n1 = int(tt[0]), int(tt[-1])
    cur = prev.copy()
    kern = np.ones((dil, dil), np.uint8)
    for it in range(passes):
        num = np.zeros((H, W, 3), np.float64)
        cnt = np.zeros((H, W), np.float64)
        t0 = time.time()
        nused = 0
        for k, n in enumerate(range(n0, n1 + 1)):
            M = sim_from_params(P[k])
            Minv = cv2.invertAffineTransform(M)
            F = pf.frame_rgb(n).astype(np.float32)
            den = cv2.warpAffine(cur, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE
            v = np.abs(den).max(axis=2) > 25
            if v.sum() < 1000:
                continue
            a = (F - WHITE)
            s = float((a * den)[v].sum() / max((den * den)[v].sum(), 1e-9))
            s = min(max(s, 0.2), 3.0)
            bg = WHITE + s * den
            bad = (np.abs(bg - F).max(axis=2) > thr[it]).astype(np.uint8)
            bad = cv2.dilate(bad, kern).astype(bool)
            wp = cv2.warpAffine(F, Minv, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
            wp = WHITE + (wp - WHITE) / s
            wm = cv2.warpAffine((~bad).astype(np.float32), Minv, (W, H), flags=cv2.INTER_LINEAR)
            w = (wm > 0.99)
            num += wp * w[..., None]
            cnt += w
            nused += 1
        c = np.maximum(cnt, 1e-9)
        new = num / c[..., None]
        hole = cnt < 2
        new[hole] = cur[hole]           # keep the previous value where nothing survived
        if verbose:
            print('   refine %d thr=%.0f: %.0fs frames=%d holes=%.4f' %
                  (it, thr[it], time.time() - t0, nused, hole.mean()), flush=True)
        cur = new
    return cur


if __name__ == '__main__':
    with open(os.path.join(WS, 'traj_smooth.pkl'), 'rb') as f:
        traj = pickle.load(f)
    for pname in PLATES:
        print('refine %s' % pname[5:9], flush=True)
        prev = np.load(os.path.join(WS, 'mosaic3_%s.npy' % pname[5:9])).astype(np.float32)
        m = refine(pname, traj, prev, passes=3)
        np.save(os.path.join(WS, 'mosaic4_%s.npy' % pname[5:9]), m.astype(np.float32))
        from PIL import Image
        Image.fromarray(np.clip(m, 0, 255).astype(np.uint8)).save(
            os.path.join(WS, 'diag_mosaic4_%s.png' % pname[5:9]))
