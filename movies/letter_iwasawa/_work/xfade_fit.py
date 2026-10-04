"""Re-estimate the crossfade weights over a wide window to find the true dissolve range."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
import render_full as rf

WS = os.path.dirname(os.path.abspath(__file__))
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
traj, mos, sky, sp = rf.assets()
WHITE = 254.0
BOX = (300, 430)          # used only for the fit; the subtitle band is excluded instead


def den(n, pname):
    return cv2.warpAffine(mos[pname], rf.M_of(traj, pname, n), (W, H),
                          flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE


for key, (pa, pb, w0, w1) in (('a', ('eviw_0801.png', 'eviw_0301.png', 1280, 1500)),
                              ('b', ('eviw_0301.png', 'eviw_0401.png', 1880, 2090)),
                              ('c', ('eviw_0401.png', 'eviw_0701.png', 2440, 2700))):
    print('\n=== xfade %s : %s -> %s ===' % (key, pa[5:9], pb[5:9]))
    prev = None
    for n in range(w0, w1 + 1, 5):
        F = pf.frame_rgb(n)[::4, ::4]
        da = den(n, pa)[::4, ::4]
        db = den(n, pb)[::4, ::4]
        m = np.ones(F.shape[:2], bool)
        m[BOX[0] // 4:BOX[1] // 4, :] = False
        best = (1e18, 0.0)
        for al in np.arange(0, 1.001, 0.01):
            g = al * da + (1 - al) * db
            s = float(((F - WHITE) * g)[m].sum() / max((g * g)[m].sum(), 1e-9))
            r = float((((F - WHITE) - s * g) ** 2)[m].mean())
            if r < best[0]:
                best = (r, al)
        r_all = best[0]
        # also the residual if we pretend it is a pure plate (alpha from my old window)
        print('  n=%4d alpha=%.2f  rms=%.2f' % (n, best[1], np.sqrt(r_all)), flush=True)
