"""Clean-pixel box error before/after the fix_box correction."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import render_full as rf
from Rfit import estimate_R

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj, mos, sky, sp = rf.assets()
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
xb = pickle.load(open(os.path.join(WS, 'xalpha2.pkl'), 'rb'))
xa['a'] = xb['a']; xa['b'] = xb['b']
al = rf._alpha(*rf.BAND_ROWS_ILL, rf.BAND_COLS[0], rf.BAND_COLS[1], rf.FEATHER)
box = al > 0.999

print('   n   alpha     before (clean px)      after (clean px)')
for key, ns in (('a', [1380, 1390, 1400, 1410, 1420, 1430, 1440, 1450, 1458]),
                ('b', [1948, 1960, 1970, 1980, 1990, 2000, 2010, 2020])):
    for n in ns:
        terms = rf.terms_for(n, xa)
        den = rf.den_for(n, terms, traj, mos)
        F = pf.frame_rgb(n)
        bg = WHITE + estimate_R(F, den) * den
        # clean pixels judged by the exact anchor warps
        g = np.zeros((H, W, 3), np.float32)
        for pname, w in terms:
            g += w * rf.anchor_den(pname, n)
        clean = (np.abs(F - (WHITE + g)).max(axis=2) < 18) & box
        b2 = rf.fix_box(F, bg, terms, al, n)
        e1 = np.abs(F - bg).max(axis=2)[clean]
        e2 = np.abs(F - b2).max(axis=2)[clean]
        print('%5d  %.2f   %6.2f (p95 %5.1f)   %6.2f (p95 %5.1f)   n=%d' %
              (n, terms[0][1], e1.mean(), np.percentile(e1, 95), e2.mean(), np.percentile(e2, 95), clean.sum()))
