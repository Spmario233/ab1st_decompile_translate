import numpy as np, os, sys
import cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
d = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'geo_sweep.npz'))
frames = d['frames']; plates = list(d['plates']); M = d['M']; ninl = d['ninl']; ng = d['ngood']; mr = d['medres']
print('plates', plates)
print('%5s | %s' % ('n', ' | '.join('%-26s' % p for p in plates)))
for i, n in enumerate(frames):
    parts = []
    for j, p in enumerate(plates):
        A = M[i, j]
        sc = float(np.hypot(A[0, 0], A[1, 0]))
        rot = float(np.degrees(np.arctan2(A[1, 0], A[0, 0])))
        parts.append('%4d %5.2f %+6.2f %6.1f%6.1f r%.1f' % (ninl[i, j], sc, rot, A[0, 2], A[1, 2], mr[i, j]) if ninl[i, j] > 0 else '%4d ----' % ninl[i, j])
    if i % 4 == 0:
        print('%5d | %s' % (n, ' | '.join(parts)))
