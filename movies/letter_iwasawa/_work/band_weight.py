"""Measure the mosaic sample weight inside the subtitle band, for every frame."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import render_full as rf

WS = os.path.dirname(os.path.abspath(__file__))
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
traj, mos, sky, sp = rf.assets()
wtmap = rf._A['wt']

worst = []
for n in range(rf.ILL_LO, rf.ILL_HI + 1, 5):
    terms = rf.terms_for(n, xa)
    w = np.zeros((H, W), np.float32)
    for pname, ww in terms:
        w += ww * cv2.warpAffine(wtmap[pname], rf.M_of(traj, pname, n), (W, H),
                                 flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
    band = w[rf.BAND_ROWS_ILL[0]:rf.BAND_ROWS_ILL[1], rf.BAND_COLS[0]:rf.BAND_COLS[1]]
    row_band = w[rf.BAND_ROWS_SKY[0]:rf.BAND_ROWS_SKY[1], rf.BAND_COLS[0]:rf.BAND_COLS[1]]
    worst.append((float(np.percentile(band, 1)), float(band.min()), float(band.mean()), n,
                  float(np.percentile(row_band, 1))))
worst.sort()
print('lowest 1st-percentile weights inside the illustration band:')
for w1, wmin, wmean, n, w1s in worst[:12]:
    print('  n=%4d  band p1=%8.2f min=%8.2f mean=%8.2f   (sky-band p1=%8.2f)' % (n, w1, wmin, wmean, w1s))
a = np.array([x[0] for x in worst])
print('p1-weight over sampled frames: min %.2f  p5 %.2f  median %.2f' % (a.min(), np.percentile(a, 5), np.median(a)))
