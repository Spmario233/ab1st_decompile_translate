"""Test whether the drift is a per-frame 1-D tone curve rather than a per-pixel gain."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']
BAND = (280, 520)
mask = np.ones((H, W), bool); mask[BAND[0]:BAND[1], :] = False


def rel(Mn, Ma):
    return (np.vstack([Mn, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]


NB = 64
edges = np.linspace(-260, 5, NB + 1)
ctr = 0.5 * (edges[1:] + edges[:-1])

for anchor, refname, pname, targets in [(2042, '002160.png', 'eviw_0401.png', [2100, 2250, 2400, 2500]),
                                        (1049, '001167.png', 'eviw_0801.png', [960, 1150, 1300, 1380]),
                                        (2692, '002810.png', 'eviw_0701.png', [2800, 3050, 3280])]:
    j = plates.index(pname)
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname)).astype(np.float32)
    Ma = M4[anchor - lo, j]
    print('\n=== anchor %d %s ===' % (anchor, pname[5:9]))
    for n in targets:
        bg = cv2.warpAffine(ref, rel(M4[n - lo, j], Ma), (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        F = pf.frame_rgb(n)
        a = (bg - WHITE)[mask].ravel(); b = (F - WHITE)[mask].ravel()
        # per-pixel gain model
        s = float((a * b).sum() / (a * a).sum())
        r_gain = b - s * a
        # 1-D tone curve, per channel
        idx = np.clip(np.digitize(a, edges) - 1, 0, NB - 1)
        keep = (a > edges[0]) & (a < edges[-1])
        curve = np.full(NB, np.nan)
        for k in range(NB):
            m = keep & (idx == k)
            if m.sum() > 300:
                curve[k] = b[m].mean()
        v = np.isfinite(curve)
        pred = np.interp(a, ctr[v], curve[v])
        r_tone = b - pred
        print('  n=%4d  gain: s=%.4f rms=%.2f | tone: rms=%.2f  R2=%.4f' %
              (n, s, np.sqrt((r_gain ** 2).mean()), np.sqrt((r_tone ** 2).mean()),
               1 - (r_tone ** 2).mean() / b.var()))
        if n == targets[-1]:
            print('     curve (bg-w -> F-w):', ' '.join('%.0f:%.0f' % (ctr[k], curve[k]) for k in range(0, NB, 6) if np.isfinite(curve[k])))
