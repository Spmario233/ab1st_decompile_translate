"""Plate-space mosaics, v2: one-sided (subtitle-only-darkens) rejection plus per-frame
global drift normalisation."""
import os, sys, time, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
from mosaic_build import sim_from_params, PERIOD, PLATES

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
THR = (1e9, 22.0, 14.0, 9.0, 7.0)


def build(pname, traj, passes=4, verbose=True):
    tt, P = traj[pname]
    n0, n1 = int(tt[0]), int(tt[-1])
    ref = None
    scales = {}
    for it in range(passes + 1):
        num = np.zeros((H, W, 3), np.float64)
        cnt = np.zeros((H, W), np.float64)
        t0 = time.time()
        for k, n in enumerate(range(n0, n1 + 1)):
            M = sim_from_params(P[k])
            Minv = cv2.invertAffineTransform(M)
            F = pf.frame_rgb(n).astype(np.float32)
            wp = cv2.warpAffine(F, Minv, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
            wc = cv2.warpAffine(np.ones((H, W), np.float32), Minv, (W, H), flags=cv2.INTER_LINEAR)
            if ref is None:
                w = wc > 0.99
                val = wp
            else:
                b = ref - WHITE
                v = (wc > 0.99) & (np.abs(b).max(axis=2) > 30) & np.isfinite(ref[..., 0])
                a = wp - WHITE
                sb = (b * b)[v].sum()
                s = float((a * b)[v].sum() / sb) if sb > 0 else 1.0
                s = min(max(s, 0.2), 3.0)
                scales[n] = s
                val = WHITE + a / s
                d = val - np.nan_to_num(ref, nan=WHITE)
                dm = d.max(axis=2)
                w = (wc > 0.99) & (dm > -THR[it]) & (dm < 60)
            num += val * w[..., None]
            cnt += w
        c = np.maximum(cnt, 1e-9)
        ref = num / c[..., None]
        ref[cnt < 3] = np.nan
        if verbose:
            print('   pass %d thr=%s: %.0fs  covered %.3f' % (it, THR[it], time.time() - t0, (cnt >= 3).mean()), flush=True)
    return ref, scales


if __name__ == '__main__':
    with open(os.path.join(WS, 'traj_smooth.pkl'), 'rb') as f:
        traj = pickle.load(f)
    allsc = {}
    for pname in PLATES:
        print('mosaic2 %s' % pname[5:9], flush=True)
        m, sc = build(pname, traj, passes=4)
        np.save(os.path.join(WS, 'mosaic2_%s.npy' % pname[5:9]), m.astype(np.float32))
        allsc[pname] = sc
        from PIL import Image
        vis = np.nan_to_num(m, nan=255).clip(0, 255).astype(np.uint8)
        Image.fromarray(vis).save(os.path.join(WS, 'diag_mosaic2_%s.png' % pname[5:9]))
    with open(os.path.join(WS, 'mosaic_scales.pkl'), 'wb') as f:
        pickle.dump(allsc, f)
