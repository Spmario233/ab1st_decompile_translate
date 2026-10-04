"""Characterise the residual: photometric drift vs geometry error."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
from mosaic_build import sim_from_params

WS = os.path.dirname(os.path.abspath(__file__))
with open(os.path.join(WS, 'traj_smooth.pkl'), 'rb') as f:
    traj = pickle.load(f)
BAND = (280, 520)
WHITE = 254.0


def rec(pname, n, extra=None):
    tt, P = traj[pname]
    M = sim_from_params(P[int(n - tt[0])])
    if extra is not None:
        M = (np.vstack([extra, [0, 0, 1]]) @ np.vstack([M, [0, 0, 1]]))[:2].astype(np.float32)
    m = np.nan_to_num(np.load(os.path.join(WS, 'mosaic_%s.npy' % pname[5:9])), nan=WHITE)
    return cv2.warpAffine(m, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)


mask = np.ones((H, W), bool); mask[BAND[0]:BAND[1], :] = False
for pname, ns in [('eviw_0801.png', range(900, 1421, 40)),
                  ('eviw_0301.png', range(1440, 1981, 40)),
                  ('eviw_0401.png', range(2000, 2561, 40)),
                  ('eviw_0701.png', range(2570, 3301, 40))]:
    print('\n%s' % pname[5:9])
    for n in ns:
        bg = rec(pname, n)
        F = pf.frame_rgb(n)
        a = (bg - WHITE)[mask].ravel()
        b = (F - WHITE)[mask].ravel()
        # global scale through origin
        s = float((a * b).sum() / (a * a).sum())
        r = b - s * a
        c = np.corrcoef(a, b)[0, 1]
        # structural residual after removing the global scale
        rs = np.sqrt((r ** 2).mean())
        print('  n=%4d  scale=%.4f  corr=%.4f  rms(raw)=%.2f  rms(scale-corrected)=%.2f' %
              (n, s, c, np.sqrt(((b - a) ** 2).mean()), rs))
