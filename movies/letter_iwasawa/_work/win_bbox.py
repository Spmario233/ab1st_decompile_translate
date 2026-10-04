"""Measure the subtitle bounding box inside the two dissolve windows."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
import render_full as rf
from Rfit import estimate_R

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj, mos, sky, sp = rf.assets()
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
xb = pickle.load(open(os.path.join(WS, 'xalpha2.pkl'), 'rb'))
for key in ('a', 'b'):
    src = xb[key]; ks = sorted(src); vals = [src[k] for k in ks]; win = rf.XFADE[key]
    xa[key] = {n: (min(float(src[ks[0]]), 1.0) if n <= ks[0] else
                   (max(float(src[ks[-1]]), 0.0) if n >= ks[-1] else
                    float(np.clip(np.interp(n, ks, vals), 0.0, 1.0))))
               for n in range(win[2], win[3] + 1)}

for key in ('a', 'b'):
    w0, w1 = rf.XFADE[key][2], rf.XFADE[key][3]
    rl, rh, cl, ch = [], [], [], []
    for n in range(w0, w1 + 1, 2):
        terms = rf.terms_for(n, xa)
        den = rf.den_for(n, terms, traj, mos)
        F = pf.frame_rgb(n)
        bg = WHITE + estimate_R(F, den) * den
        d = np.abs(bg - F).max(axis=2)
        ob = np.concatenate([d[:300].ravel(), d[430:].ravel()])
        thr = float(np.clip(1.15 * np.percentile(ob, 98), 20.0, 32.0))
        m = d > thr
        m[:300] = False; m[430:] = False
        m[:, :60] = False; m[:, 1240:] = False
        if m.sum() < 800:
            continue
        rr = np.nonzero(m.any(axis=1))[0]; cc = np.nonzero(m.any(axis=0))[0]
        rl.append(rr.min()); rh.append(rr.max()); cl.append(cc.min()); ch.append(cc.max())
    a = np.array([rl, rh, cl, ch]).T
    print('window %s (%d..%d), %d frames with a subtitle' % (key, w0, w1, len(a)))
    for i, nm in enumerate(['row_lo', 'row_hi', 'col_lo', 'col_hi']):
        print('   %-7s min %4d  p2 %4d  p50 %4d  p98 %4d  max %4d' %
              (nm, a[:, i].min(), np.percentile(a[:, i], 2), np.percentile(a[:, i], 50),
               np.percentile(a[:, i], 98), a[:, i].max()))
    print('   union rows %d..%d  cols %d..%d' % (a[:, 0].min(), a[:, 1].max(), a[:, 2].min(), a[:, 3].max()))
