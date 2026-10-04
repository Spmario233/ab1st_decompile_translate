"""Decisive test: is the 'memory filter' attached to the artwork (plate space) or to the screen?

If plate space, warp(clean_anchor, M_n o M_anchor^-1) reproduces frame n exactly
outside the subtitle band.  If screen space it will not.
"""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']
i0 = lo
BAND = (300, 500)

ANCH = {1049: ('eviw_0801.png', '001167.png'),
        1458: ('eviw_0301.png', '001576.png'),
        2042: ('eviw_0401.png', '002160.png'),
        2692: ('eviw_0701.png', '002810.png')}


def rel(Mn, Ma):
    """similarity mapping: screen coords of anchor -> screen coords of frame n."""
    Mai = cv2.invertAffineTransform(Ma)
    A3 = np.vstack([Mn, [0, 0, 1]])
    B3 = np.vstack([Mai, [0, 0, 1]])
    return (A3 @ B3)[:2]


def test(anchor, targets):
    pname, refname = ANCH[anchor]
    j = plates.index(pname)
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname)).astype(np.float32)
    Ma = M4[anchor - i0, j]
    print('\n=== anchor %d (%s) ===' % (anchor, pname[5:9]))
    for n in targets:
        Mn = M4[n - i0, j]
        if not np.isfinite(Mn).all() or (Mn == 0).all():
            print('  n=%4d no transform' % n); continue
        R = rel(Mn, Ma)
        bg = cv2.warpAffine(ref, R, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        # coverage mask (where the warped anchor frame really covers)
        ones = np.ones((H, W), np.uint8)
        cov = cv2.warpAffine(ones, R, (W, H), flags=cv2.INTER_NEAREST, borderMode=cv2.BORDER_CONSTANT, borderValue=0)
        F = pf.frame_rgb(n)
        m = (cov > 0)
        m[BAND[0]:BAND[1], :] = False
        e = (bg - F)[m]
        eo = np.abs(bg - F).max(axis=2)
        eo2 = eo[m]
        print('  n=%4d  cover=%.3f  outband rms=%.2f  p90=%.1f p99=%.1f' %
              (n, cov.mean() / 255, np.sqrt((e ** 2).mean()), np.percentile(eo2, 90), np.percentile(eo2, 99)))


test(1049, [920, 980, 1100, 1200, 1300, 1350, 1390])
test(1458, [1440, 1500, 1600, 1750, 1900, 1950])
test(2042, [2000, 2100, 2250, 2400, 2500])
test(2692, [2620, 2700, 2850, 3000, 3150, 3280])
