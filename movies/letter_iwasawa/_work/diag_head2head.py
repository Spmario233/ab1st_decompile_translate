"""Head-to-head: screen-space gain field vs plate-space transfer, both derived from the exact
clean anchor frame, predicting other frames of the same plate."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import model as md

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']
BAND = (280, 520)

CASES = [(2042, '002160.png', 'eviw_0401.png', [2100, 2200, 2300, 2400, 2500]),
         (1049, '001167.png', 'eviw_0801.png', [960, 1000, 1150, 1250, 1350])]


def rel(Mn, Ma):
    return (np.vstack([Mn, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]


mask = np.ones((H, W), bool); mask[BAND[0]:BAND[1], :] = False

for anchor, refname, pname, targets in CASES:
    j = plates.index(pname)
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname)).astype(np.float32)
    plate = pf.plate(pname)
    Ma = M4[anchor - lo, j]
    denA = cv2.warpAffine(plate, Ma, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE
    A = np.full((H, W, 3), np.nan, np.float32)
    okA = np.abs(denA).max(axis=2) > 40
    A[okA] = (ref - WHITE)[okA] / denA[okA]
    Af = np.stack([md._fill_nan(A[..., c]) for c in range(3)], 2)
    Af = cv2.GaussianBlur(Af, (0, 0), 3.0, borderType=cv2.BORDER_REPLICATE)
    print('\n=== anchor %d %s ===' % (anchor, pname[5:9]))
    for n in targets:
        Mn = M4[n - lo, j]
        F = pf.frame_rgb(n)
        # (1) screen-space model
        denN = cv2.warpAffine(plate, Mn, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE
        bg_s = WHITE + Af * denN
        # (2) plate-space model
        bg_p = cv2.warpAffine(ref, rel(Mn, Ma), (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        out = []
        for nm, bg in (('screen', bg_s), ('plate ', bg_p)):
            a = (bg - WHITE)[mask].ravel(); b = (F - WHITE)[mask].ravel()
            s = float((a * b).sum() / (a * a).sum())
            e = (WHITE + s * (bg - WHITE) - F)[mask]
            out.append('%s: scale=%.4f rms=%6.2f' % (nm, s, np.sqrt((e ** 2).mean())))
        print('  n=%4d   %s | %s' % (n, out[0], out[1]))
