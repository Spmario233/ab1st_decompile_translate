import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
import render_full as rf

WHITE = 254.0
xa = rf.compute_xalpha()
traj, mos, sky, sp = rf.assets()
BAND = rf.BAND_ROWS

for n, pname in [(1049, 'eviw_0801.png'), (2042, 'eviw_0401.png')]:
    terms = rf.terms_for(n, xa)
    print('n=%d terms=%s' % (n, terms))
    den = rf.den_for(n, terms, traj, mos)
    F = pf.frame_rgb(n)
    outmask = np.ones((H, W), bool); outmask[BAND[0]:BAND[1], :] = False
    for sg in (0, 4, 8, 16):
        tot = []
        for c in range(3):
            v = (np.abs(den[..., c]) > 45) & outmask
            R = np.zeros((H, W), np.float32)
            R[v] = (F[..., c] - WHITE)[v] / den[..., c][v]
            msk = v.astype(np.float32)
            if sg:
                num = cv2.GaussianBlur(R * msk, (0, 0), sg, borderType=cv2.BORDER_REPLICATE)
                dn = cv2.GaussianBlur(msk, (0, 0), sg, borderType=cv2.BORDER_REPLICATE)
                Rs = num / np.maximum(dn, 1e-6)
            else:
                Rs = R
            tot.append((WHITE + Rs * den[..., c] - F[..., c])[v])
        e = np.concatenate(tot)
        print('   direct smooth sigma=%2d rms=%.2f' % (sg, np.sqrt((e ** 2).mean())))
    R = rf.estimate_R(F, den)
    bg = WHITE + R * den
    e = np.abs(bg - F).max(axis=2)[outmask]
    print('   estimate_R rms=%.2f p95=%.0f   R stats: p5=%.3f med=%.3f p95=%.3f' %
          (np.sqrt((e ** 2).mean()), np.percentile(e, 95),
           *np.percentile(R[..., 0][outmask], [5, 50, 95])))
