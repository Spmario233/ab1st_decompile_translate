"""Refit the crossfade weights with INDEPENDENT scale factors for the two plates.

    F - white  ~=  a*den_A + b*den_B      ->   alpha_A = a / (a + b)

A single shared scale (what the old fit used) is biased: the memory filter drifts with
time, so each plate's mosaic has its own effective gain at a given frame.
"""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
import render_full as rf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj, mos, sky, sp = rf.assets()
BAND = (310, 412)


def den(n, pname):
    return cv2.warpAffine(mos[pname], rf.M_of(traj, pname, n), (W, H),
                          flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE


WINDOWS = (('a', 'eviw_0801.png', 'eviw_0301.png', 1340, 1490),
           ('b', 'eviw_0301.png', 'eviw_0401.png', 1890, 2050),
           ('c', 'eviw_0401.png', 'eviw_0701.png', 2470, 2650))
out = {}
for key, pa, pb, w0, w1 in WINDOWS:
    print('\n=== xfade %s : %s -> %s ===' % (key, pa[5:9], pb[5:9]))
    al = {}
    for n in range(w0, w1 + 1, 2):
        F = pf.frame_rgb(n)[::4, ::4]
        da = den(n, pa)[::4, ::4]
        db = den(n, pb)[::4, ::4]
        m = np.ones(F.shape[:2], bool)
        m[BAND[0] // 4:BAND[1] // 4, :] = False
        m &= (np.abs(da).max(axis=2) > 25) | (np.abs(db).max(axis=2) > 25)
        m3 = np.repeat(m[..., None], 3, axis=2)
        A = np.stack([da[m3], db[m3]], 1).astype(np.float64)
        y = (F - WHITE)[m3].astype(np.float64)
        sol, *_ = np.linalg.lstsq(A, y, rcond=None)
        a, b = float(sol[0]), float(sol[1])
        r = y - A @ sol
        aa = a / (a + b) if (a + b) > 1e-6 else np.nan
        al[n] = aa
        if n % 10 == 0:
            print('  n=%4d  a=%.4f b=%.4f  alpha_A=%.3f  rms=%.2f' % (n, a, b, aa, np.sqrt((r ** 2).mean())), flush=True)
    out[key] = al
with open(os.path.join(WS, 'xalpha2.pkl'), 'wb') as f:
    pickle.dump(out, f)
print('\nsaved xalpha2.pkl')
