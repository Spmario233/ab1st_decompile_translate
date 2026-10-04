"""Correct per-channel test: can a SMOOTH spatial gain field absorb the drift?"""
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
outmask = np.ones((H, W), bool); outmask[BAND[0]:BAND[1], :] = False


def rel(Mn, Ma):
    return (np.vstack([Mn, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]


for anchor, refname, pname, targets in [(2042, '002160.png', 'eviw_0401.png', [2100, 2250, 2400, 2500]),
                                        (1049, '001167.png', 'eviw_0801.png', [960, 1150, 1300, 1380])]:
    j = plates.index(pname)
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname)).astype(np.float32)
    Ma = M4[anchor - lo, j]
    print('\n=== anchor %d %s ===' % (anchor, pname[5:9]))
    for n in targets:
        bg = cv2.warpAffine(ref, rel(M4[n - lo, j], Ma), (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        F = pf.frame_rgb(n)
        den = bg - WHITE
        msg = []
        for sg in (0, 8, 20, 40, 80):
            tot = []; totn = 0
            for c in range(3):
                v = (np.abs(den[..., c]) > 40) & outmask
                R = np.zeros((H, W), np.float32)
                R[v] = (F[..., c] - WHITE)[v] / den[..., c][v]
                msk = v.astype(np.float32)
                if sg > 0:
                    num = cv2.GaussianBlur(R * msk, (0, 0), sg, borderType=cv2.BORDER_REPLICATE)
                    dn = cv2.GaussianBlur(msk, (0, 0), sg, borderType=cv2.BORDER_REPLICATE)
                    Rs = num / np.maximum(dn, 1e-6)
                else:
                    Rs = R
                e = (WHITE + Rs * den[..., c] - F[..., c])[v]
                tot.append(e); totn += v.sum()
            e = np.concatenate(tot)
            msg.append('sg%2d rms=%5.2f' % (sg, np.sqrt((e ** 2).mean())))
        print('  n=%4d  %s' % (n, ' | '.join(msg)))
