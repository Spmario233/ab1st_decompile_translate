"""Measure the spatial structure of the drift field between an exact anchor and a distant frame."""
import os, sys
import numpy as np, cv2
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import model as md

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']
BAND = (280, 520)
mask = np.ones((H, W), bool); mask[BAND[0]:BAND[1], :] = False


def rel(Mn, Ma):
    return (np.vstack([Mn, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]


for anchor, refname, pname, targets in [(2042, '002160.png', 'eviw_0401.png', [2200, 2500]),
                                        (1049, '001167.png', 'eviw_0801.png', [1250, 1350]),
                                        (2692, '002810.png', 'eviw_0701.png', [3000, 3280])]:
    j = plates.index(pname)
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname)).astype(np.float32)
    Ma = M4[anchor - lo, j]
    print('\n=== anchor %d %s ===' % (anchor, pname[5:9]))
    for n in targets:
        Mn = M4[n - lo, j]
        bg = cv2.warpAffine(ref, rel(Mn, Ma), (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        F = pf.frame_rgb(n)
        den = bg - WHITE
        ok = (np.abs(den).max(axis=2) > 40) & mask
        R = np.full((H, W, 3), np.nan, np.float32)
        R[ok] = (F - WHITE)[ok] / den[ok]
        Rf = np.stack([md._fill_nan(R[..., c]) for c in range(3)], 2)
        for sg in (0, 10, 30, 60):
            Rs = Rf if sg == 0 else cv2.GaussianBlur(Rf, (0, 0), sg, borderType=cv2.BORDER_REPLICATE)
            e = (WHITE + Rs * den - F)[mask]
            print('  n=%4d sigma=%3d  rms=%6.2f p90=%5.1f' % (n, sg, np.sqrt((e ** 2).mean()), np.percentile(np.abs(e).max(axis=1) if e.ndim > 1 else np.abs(e), 90)))
        Rsm = cv2.GaussianBlur(Rf, (0, 0), 30.0, borderType=cv2.BORDER_REPLICATE)
        Image.fromarray(np.clip(Rsm[..., 0] * 128 + 64, 0, 255).astype(np.uint8)).save(
            os.path.join(WS, 'diag_Rfield_%d_%d.png' % (anchor, n)))
        v = Rsm[..., 0][mask]
        print('     R(sigma30): p5=%.3f med=%.3f p95=%.3f std=%.4f' % (*np.percentile(v, [5, 50, 95]), v.std()))
