"""Validate the extended trajectories and measure the model residual improvement."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
import render_full as rf
from Rfit import estimate_R
from mosaic_build import sim_params, sim_from_params

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj, mos, sky, sp = rf.assets()
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); M = d['M']; ninl = d['ninl']
plates = [str(x) for x in d['plates']]

print('--- extended trajectory vs raw SIFT fits (where usable) ---')
for pname, ns in (('eviw_0401.png', [1975, 1980, 1985]), ('eviw_0301.png', [1405, 1410, 1415])):
    j = plates.index(pname)
    for n in ns:
        tt, P = traj[pname]
        k = n - int(tt[0])
        pt = sim_params(sim_from_params(P[k]))
        ps = sim_params(M[n - lo, j])
        print('%s n=%d  traj: scale %.4f rot %7.3f tx %8.2f ty %8.2f   sift: scale %.4f rot %7.3f tx %8.2f ty %8.2f' %
              (pname[5:9], n, pt[0], np.degrees(pt[1]), pt[2], pt[3], ps[0], np.degrees(ps[1]), ps[2], ps[3]))

print('\n--- model residual inside the box (rows 318-404, cols 92-1208) ---')
box = np.zeros((H, W), bool); box[318:404, 92:1208] = True
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
xb = pickle.load(open(os.path.join(WS, 'xalpha2.pkl'), 'rb'))
for key in ('a', 'b'):
    src = xb[key]; ks = sorted(src); vals = [src[k] for k in ks]; win = rf.XFADE[key]
    xa[key] = {n: (min(float(src[ks[0]]), 1.0) if n <= ks[0] else
                   (max(float(src[ks[-1]]), 0.0) if n >= ks[-1] else
                    float(np.clip(np.interp(n, ks, vals), 0.0, 1.0))))
               for n in range(win[2], win[3] + 1)}

old = pickle.load(open(os.path.join(WS, 'traj_smooth_v4.pkl'), 'rb'))
for key, ns in (('a', [1380, 1400, 1420, 1440, 1455]), ('b', [1950, 1965, 1980, 2000, 2020])):
    for n in ns:
        terms = rf.terms_for(n, xa)
        F = pf.frame_rgb(n)
        out = []
        for tr in (old, traj):
            rf._A['traj'] = tr
            den = rf.den_for(n, terms, tr, mos)
            bg = WHITE + estimate_R(F, den) * den
            out.append(np.abs(F - bg).max(axis=2)[box].mean())
        print('  n=%4d terms=%s  box mean|F-bg|: frozen-traj %.2f  ->  extended-traj %.2f' %
              (n, [(t[0][5:9], round(t[1], 2)) for t in terms], out[0], out[1]))
