"""Is the residual drift a global scalar or a smooth spatial field?"""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
from mosaic_build import sim_from_params

WS = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(WS, 'traj_smooth.pkl'), 'rb') as f:
    traj = pickle.load(f)
BAND = (280, 520)
WHITE = 254.0
DS = 8


def bg0(pname, n):
    tt, P = traj[pname]
    M = sim_from_params(P[int(n - tt[0])])
    m = np.nan_to_num(np.load(os.path.join(WS, 'mosaic_%s.npy' % pname[5:9])), nan=WHITE)
    return cv2.warpAffine(m, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)


for pname, ns in [('eviw_0801.png', [960, 1050, 1250, 1340, 1400]),
                  ('eviw_0401.png', [2050, 2200, 2400, 2500])]:
    print('\n===== %s =====' % pname[5:9])
    for n in ns:
        B = bg0(pname, n)
        F = pf.frame_rgb(n)
        num = F - WHITE
        den = B - WHITE
        ok = np.abs(den).max(axis=2) > 50
        band = np.zeros((H, W), bool); band[BAND[0]:BAND[1], :] = True
        ok = ok & ~band
        R = np.full((H, W, 3), np.nan, np.float32)
        R[ok] = num[ok] / den[ok]
        # coarse grid at 1/8 resolution using medians of valid pixels
        gh, gw = H // DS, W // DS
        G = np.full((gh, gw, 3), np.nan, np.float32)
        for a in range(gh):
            for b in range(gw):
                if a * DS >= BAND[0] and a * DS < BAND[1]:
                    continue
                blk = R[a*DS:(a+1)*DS, b*DS:(b+1)*DS]
                for c in range(3):
                    v = blk[..., c][np.isfinite(blk[..., c])]
                    if v.size >= 20:
                        G[a, b, c] = np.median(v)
        # smooth the coarse grid (fill NaN first)
        Gs = G.copy()
        for c in range(3):
            g = Gs[..., c]
            m = np.isfinite(g)
            g[~m] = np.nanmean(g)
            Gs[..., c] = cv2.GaussianBlur(g, (0, 0), 2.0, borderType=cv2.BORDER_REPLICATE)
        Rf = cv2.resize(Gs, (W, H), interpolation=cv2.INTER_CUBIC)
        bgN = WHITE + Rf * den
        e0 = np.abs(B - F).max(axis=2)[~band]
        e1 = np.abs(bgN - F).max(axis=2)[~band]
        gv = G[..., 0][np.isfinite(G[..., 0])]
        print('n=%4d  global-scale rms=%.2f p95=%.0f | spatial-R rms=%.2f p95=%.0f | R grid p5=%.3f med=%.3f p95=%.3f std=%.4f' %
              (n, np.sqrt((e0 ** 2).mean()), np.percentile(e0, 95),
               np.sqrt((e1 ** 2).mean()), np.percentile(e1, 95),
               *np.percentile(gv, [5, 50, 95]), gv.std()))
