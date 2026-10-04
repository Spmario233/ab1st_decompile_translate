"""Measure the per-frame subtitle bounding box (rows/cols) with the rebuilt mosaics."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
import render_full as rf
from Rfit import estimate_R

WS = os.path.dirname(os.path.abspath(__file__))
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
traj, mos, sky, sp = rf.assets()
WHITE = 254.0

rows_lo, rows_hi, cols_lo, cols_hi = [], [], [], []
for n in range(0, 3442, 3):
    F = pf.frame_rgb(n)
    if rf.ILL_LO <= n <= rf.ILL_HI:
        bands = rf.BAND_ROWS_ILL
        den = rf.den_for(n, rf.terms_for(n, xa), traj, mos)
        bg = WHITE + estimate_R(F, den) * den
    elif rf.SKY_LO <= n <= rf.SKY_HI:
        bands = rf.BAND_ROWS_SKY
        i = n - int(sp['lo'])
        bg = WHITE + sp['gamma'][i] * (rf.sky_crop(sky, sp['dy'][i]) - WHITE)
    else:
        bands = rf.BAND_ROWS_WHITE
        bg = np.full((H, W, 3), WHITE, np.float32)
    d = np.abs(bg - F).max(axis=2)
    ob = np.concatenate([d[:bands[0]].ravel(), d[bands[1]:].ravel()])
    thr = float(np.clip(1.15 * np.percentile(ob, 98), 20.0, 32.0))
    m = d > thr
    m[:bands[0]] = False; m[bands[1]:] = False
    m[:, :rf.BAND_COLS[0]] = False; m[:, rf.BAND_COLS[1]:] = False
    s = int(m.sum())
    if not (1200 <= s <= 45000):
        continue
    rr = np.nonzero(m.any(axis=1))[0]; cc = np.nonzero(m.any(axis=0))[0]
    # trim isolated outliers
    rows_lo.append(int(np.percentile(rr, 0.5))); rows_hi.append(int(np.percentile(rr, 99.5)))
    cols_lo.append(int(np.percentile(cc, 0.5))); cols_hi.append(int(np.percentile(cc, 99.5)))

a = np.array([rows_lo, rows_hi, cols_lo, cols_hi]).T
print('frames used', len(a))
for i, nm in enumerate(['row_lo', 'row_hi', 'col_lo', 'col_hi']):
    print('  %-7s min %4d  p1 %4d  p50 %4d  p99 %4d  max %4d' %
          (nm, a[:, i].min(), np.percentile(a[:, i], 1), np.percentile(a[:, i], 50),
           np.percentile(a[:, i], 99), a[:, i].max()))
print('union: rows %d..%d  cols %d..%d' % (a[:, 0].min(), a[:, 1].max(), a[:, 2].min(), a[:, 3].max()))
