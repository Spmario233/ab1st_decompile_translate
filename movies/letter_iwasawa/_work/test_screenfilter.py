"""Decisive test #2 (uses plate 0401, whose transform is a pure translation).

Track a fixed artwork pixel through time.  If the memory filter lives on the screen,
its observed contrast must follow the screen-space vignette; if it lives on the
artwork it must stay constant.
"""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']
j = plates.index('eviw_0401.png')
plate = pf.plate('eviw_0401.png')
pt = plate - WHITE

NS = list(range(2010, 2530, 20))
canvas = np.zeros((H, W, 3), np.float32)
cnt = np.zeros((H, W), np.float32)

# plate pixel coordinates to track (dark artwork features)
PXS = [(300, 400), (500, 300), (400, 500), (700, 350)]

rows = []
for n in NS:
    M = M4[n - lo, j]
    if not np.isfinite(M).all():
        continue
    Minv = cv2.invertAffineTransform(M)
    F = pf.frame_rgb(n)
    canvas += cv2.warpAffine(F, Minv, (W, H), flags=cv2.INTER_LINEAR)
    cnt += cv2.warpAffine(np.ones((H, W), np.float32), Minv, (W, H), flags=cv2.INTER_LINEAR)
    rec = []
    for (px, py) in PXS:
        # where does this artwork pixel land on screen?
        s = M @ np.array([px, py, 1.0])
        x, y = s[0], s[1]
        if 2 <= x < W - 2 and 2 <= y < H - 2:
            v = float(F[int(round(y)), int(round(x))].mean())
            rec.append((px, py, x, y, v))
    rows.append((n, rec))

print('screen position and observed value of fixed artwork pixels (plate 0401)')
for (px, py) in PXS:
    print('\n  artwork pixel (%d,%d): P=%.1f (P-w=%.1f)' % (px, py, plate[py, px].mean(), pt[py, px].mean()))
    for n, rec in rows:
        for (a, b, x, y, v) in rec:
            if (a, b) == (px, py):
                print('    n=%4d  screen=(%6.1f,%6.1f)  F=%6.1f  (F-w)/(P-w)=%.4f' %
                      (n, x, y, v, (v - WHITE) / pt[py, px].mean()))
