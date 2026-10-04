"""Verify the plate mosaics: reconstruct frames and measure the error."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
from mosaic_build import sim_from_params

WS = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(WS, 'traj_smooth.pkl'), 'rb') as f:
    traj = pickle.load(f)
BAND = (300, 500)
WHITE = 254.0
ANCH = [(1049, 'eviw_0801.png', '001167.png'), (1458, 'eviw_0301.png', '001576.png'),
        (2042, 'eviw_0401.png', '002160.png'), (2692, 'eviw_0701.png', '002810.png')]


def bg_of(pname, n):
    tt, P = traj[pname]
    k = int(n - tt[0])
    M = sim_from_params(P[k])
    m = np.load(os.path.join(WS, 'mosaic_%s.npy' % pname[5:9]))
    mm = np.nan_to_num(m, nan=WHITE)
    return cv2.warpAffine(mm, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)


for n, pname, refname in ANCH:
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname))
    bg = bg_of(pname, n)
    e = np.abs(bg - ref).max(axis=2)
    band = e[BAND[0]:BAND[1]]
    oth = np.concatenate([e[:BAND[0]], e[BAND[1]:]])
    print('ANCHOR n=%4d %s: all rms=%.2f  band rms=%.2f p99=%.0f  outside rms=%.2f p99=%.0f' %
          (n, pname[5:9], np.sqrt(((bg - ref) ** 2).mean()),
           np.sqrt((e[BAND[0]:BAND[1]] ** 2).mean()), np.percentile(band, 99),
           np.sqrt((oth ** 2).mean()), np.percentile(oth, 99)))
    from PIL import Image
    Image.fromarray(np.clip(e * 5, 0, 255).astype(np.uint8)).save(os.path.join(WS, 'diag_moserr_%d.png' % n))

for pname, ns in [('eviw_0801.png', [950, 1100, 1250, 1390]),
                  ('eviw_0301.png', [1500, 1700, 1900]),
                  ('eviw_0401.png', [2050, 2250, 2450]),
                  ('eviw_0701.png', [2650, 2900, 3150, 3280])]:
    for n in ns:
        bg = bg_of(pname, n)
        F = pf.frame_rgb(n)
        e = np.abs(bg - F).max(axis=2)
        oth = np.concatenate([e[:BAND[0]], e[BAND[1]:]])
        print('      n=%4d %s: outside rms=%.2f p90=%.0f p99=%.0f' %
              (n, pname[5:9], np.sqrt((oth ** 2).mean()), np.percentile(oth, 90), np.percentile(oth, 99)))
