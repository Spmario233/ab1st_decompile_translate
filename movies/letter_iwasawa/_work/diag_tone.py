"""Is the video a *tone curve* of the raw plate (plus a smooth screen vignette)?"""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']
ANCH = [(1049, 'eviw_0801.png'), (1458, 'eviw_0301.png'), (2042, 'eviw_0401.png'), (2692, 'eviw_0701.png')]

NB = 48
edges = np.linspace(-260, 0, NB + 1)


def binfit(x, y):
    idx = np.clip(np.digitize(x, edges) - 1, 0, NB - 1)
    keep = (x > edges[0]) & (x < edges[-1])
    mx = np.full(NB, np.nan); my = np.full(NB, np.nan); sy = np.full(NB, np.nan)
    for b in range(NB):
        m = keep & (idx == b)
        if m.sum() > 200:
            mx[b] = x[m].mean(); my[b] = y[m].mean(); sy[b] = y[m].std()
    return mx, my, sy


for n, pname in ANCH:
    M = M4[n - lo, plates.index(pname)]
    F = pf.frame_rgb(n)
    plate = pf.plate(pname)
    N = cv2.warpAffine(plate, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
    print('\n=== n=%d %s ===' % (n, pname[5:9]))
    for c, nm in enumerate('RGB'):
        x = (N[..., c] - WHITE).ravel()
        y = (F[..., c] - WHITE).ravel()
        mx, my, sy = binfit(x, y)
        v = np.isfinite(my)
        # R^2 of y vs binned mean
        pred = np.interp(x, mx[v], my[v])
        r2 = 1 - ((y - pred) ** 2).mean() / y.var()
        print('  %s: R2(bin)=%.4f   curve sampled:' % (nm, r2))
        s = '    '
        for b in range(0, NB, 4):
            if np.isfinite(my[b]):
                s += 'P%4.0f->F%4.0f(s%2.0f) ' % (mx[b], my[b], sy[b])
        print(s)
