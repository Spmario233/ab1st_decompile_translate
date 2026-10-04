"""Analyse the similarity-parameter trajectories and produce smoothed, denoised transforms."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H

WS = os.path.dirname(os.path.abspath(__file__))
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo, hi = int(d['lo']), int(d['hi'])
plates = [str(x) for x in d['plates']]
M = d['M']; ninl = d['ninl']
N = M.shape[0]
t = np.arange(lo, hi + 1)


def params(A):
    sc = np.hypot(A[0, 0], A[1, 0])
    rot = np.arctan2(A[1, 0], A[0, 0])
    return np.array([sc, rot, A[0, 2], A[1, 2]])


def smooth(x, w=31, deg=3):
    """Savitzky-Golay-like local polynomial smoothing, NaN aware."""
    n = len(x)
    y = x.copy()
    for i in range(n):
        a, b = max(0, i - w // 2), min(n, i + w // 2 + 1)
        seg = y[a:b]
        m = np.isfinite(seg)
        if m.sum() < deg + 2:
            continue
        tt = np.arange(a, b)[m]
        c = np.polyfit(tt, seg[m], deg)
        y[i] = np.polyval(c, i + 0)
    return y


PLATEAU = {
    'eviw_0801.png': (900, 1425),
    'eviw_0301.png': (1425, 1990),
    'eviw_0401.png': (1990, 2570),
    'eviw_0701.png': (2560, 3305),
}
out = {}
for pname in plates:
    j = plates.index(pname)
    p0, p1 = PLATEAU[pname]
    sel = (t >= p0) & (t <= p1) & (ninl[:, j] >= 20) & np.isfinite(M[:, j, 0, 0])
    idx = np.nonzero(sel)[0]
    P = np.array([params(M[i, j]) for i in idx])       # (K,4)
    T = t[idx].astype(np.float64)
    print('\n%s: usable %d frames in [%d,%d]' % (pname[5:9], len(idx), p0, p1))
    for c, nm in enumerate(['scale', 'rot_deg', 'tx', 'ty']):
        v = P[:, c].copy()
        if c == 1:
            v = np.degrees(v)
        f = smooth(v, w=41, deg=3)
        r = v - f
        print('   %-8s range %9.4f .. %9.4f   resid rms=%.4f  max=%.4f' %
              (nm, v.min(), v.max(), np.sqrt(np.nanmean(r ** 2)), np.nanmax(np.abs(r))))
    out[pname] = (T, P)
np.save(os.path.join(WS, 'traj.npy'), np.array(list(out.keys()), dtype=object), allow_pickle=True)
import pickle
with open(os.path.join(WS, 'traj.pkl'), 'wb') as f:
    pickle.dump(out, f)
