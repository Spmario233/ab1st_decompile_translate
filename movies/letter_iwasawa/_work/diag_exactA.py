"""Look at the *exact* per-pixel gain at an anchor and judge smoothness / geometry error."""
import os, sys
import numpy as np, cv2
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']

n, pname = 1049, 'eviw_0801.png'
M = M4[n - lo, plates.index(pname)]
F = pf.frame_rgb(n)
plate = pf.plate(pname)
P = cv2.warpAffine(plate, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
den = P - WHITE
A = np.full((H, W, 3), np.nan, np.float32)
ok = np.abs(den) > 60
A[ok] = (F - WHITE)[ok] / den[ok]
print('valid', ok.mean())
for c, nm in enumerate('RGB'):
    v = A[..., c][np.isfinite(A[..., c])]
    print(' %s p5=%.3f med=%.3f p95=%.3f std=%.4f' % (nm, *np.percentile(v, [5, 50, 95]), v.std()))

# smoothed version of A
Af = np.stack([np.where(np.isfinite(A[..., c]), A[..., c], np.nan) for c in range(3)], 2)
As = np.zeros_like(A)
for c in range(3):
    a = A[..., c].copy()
    m = np.isfinite(a)
    a[~m] = 0
    num = cv2.GaussianBlur(a, (0, 0), 3)
    den2 = cv2.GaussianBlur(m.astype(np.float32), (0, 0), 3)
    As[..., c] = num / np.maximum(den2, 1e-6)
res = np.abs(A - As).max(axis=2)
print('A vs smoothed A: rms=%.4f p95=%.4f' % (np.sqrt(np.nanmean((A - As) ** 2)), np.nanpercentile(res, 95)))

vis = np.clip(np.nan_to_num(As[..., 0]) * 255, 0, 255).astype(np.uint8)
Image.fromarray(vis).save(os.path.join(WS, 'diag_A_exact.png'))
dv = np.clip(np.nan_to_num(res) * 600, 0, 255).astype(np.uint8)
Image.fromarray(dv).save(os.path.join(WS, 'diag_A_exact_res.png'))

# model error using the exact A where available and smoothed elsewhere
bg = WHITE + As * den
e = np.abs(bg - F).max(axis=2)
print('residual with smoothed exact A: rms=%.2f p95=%.1f' % (np.sqrt((e ** 2).mean()), np.percentile(e, 95)))

# how does the residual scale with the local gradient magnitude?  (=> geometry error)
g = cv2.Laplacian(cv2.cvtColor(F.astype(np.uint8), cv2.COLOR_RGB2GRAY), cv2.CV_32F)
for lo_, hi_ in [(0, 1), (1, 3), (3, 8), (8, 20), (20, 1e9)]:
    m = (np.abs(g) >= lo_) & (np.abs(g) < hi_)
    if m.sum():
        print('  |lap| in [%5.1f,%5.1f): %7d px  resid rms=%.2f' % (lo_, hi_, m.sum(), np.sqrt((e[m] ** 2).mean())))
