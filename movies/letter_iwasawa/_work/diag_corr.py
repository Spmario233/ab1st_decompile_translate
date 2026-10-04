"""Diagnose model mismatch: is the video a blurred version of the raw plate?"""
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
BAND = (300, 500)

# --- ECC convention test -------------------------------------------------
a = np.zeros((200, 200), np.float32)
a[80:120, 90:130] = 1.0
a = cv2.GaussianBlur(a, (0, 0), 3)
b = cv2.warpAffine(a, np.float32([[1, 0, 5], [0, 1, 3]]), (200, 200))
crit = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 200, 1e-8)
cc, Wm = cv2.findTransformECC(a, b, np.eye(2, 3, dtype=np.float32), cv2.MOTION_AFFINE, crit, None, 5)
print('ECC synthetic: true shift of b = (+5,+3); returned', np.array2string(Wm, precision=3).replace('\n', ' '))
Cc, Wc = cv2.findTransformECC(b, a, np.eye(2, 3, dtype=np.float32), cv2.MOTION_AFFINE, crit, None, 5)
print('  reversed:', np.array2string(Wc, precision=3).replace('\n', ' '))
print('   (warpAffine(a, Wm) should equal b if Wm maps a->b)')
print('   warpAffine(a,Wm) vs b rms =', np.sqrt(((cv2.warpAffine(a, Wm, (200, 200)) - b) ** 2).mean()))
print('   warpAffine(b,Wm) vs a rms =', np.sqrt(((cv2.warpAffine(b, Wm, (200, 200)) - a) ** 2).mean()))

# --- blur test -----------------------------------------------------------
for n, pname in ANCH:
    M = M4[n - lo, plates.index(pname)]
    F = pf.frame_rgb(n)
    plate = pf.plate(pname)
    m = np.ones((H, W), bool); m[BAND[0]:BAND[1], :] = False
    f = (F - WHITE)[m]
    print('\nn=%d %s' % (n, pname[5:9]))
    for sg in (0.0, 0.4, 0.7, 1.0, 1.4, 2.0, 3.0):
        pl = plate if sg == 0 else cv2.GaussianBlur(plate, (0, 0), sg)
        P = cv2.warpAffine(pl, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        dd = (P - WHITE)[m]
        c = np.corrcoef(f.ravel(), dd.ravel())[0, 1]
        # best scalar scale
        s = float((f * dd).sum() / (dd * dd).sum())
        r = np.sqrt(((f - s * dd) ** 2).mean())
        print('   blur %.1f : corr=%.5f  scale=%.4f  rms(resid)=%.2f' % (sg, c, s, r))
