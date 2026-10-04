"""How much of each plate mosaic is backed ONLY by crossfade (blended) frames?"""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
from mosaic_build import sim_from_params, PLATES

WS = os.path.dirname(os.path.abspath(__file__))
traj = pickle.load(open(os.path.join(WS, 'traj_smooth.pkl'), 'rb'))
PERIOD = {'eviw_0801.png': (874, 1425), 'eviw_0301.png': (1420, 1990),
          'eviw_0401.png': (1988, 2570), 'eviw_0701.png': (2556, 3320)}
# frames where the plate is at full strength (alpha == 1), from the wide-window fit
CLEAN = {'eviw_0801.png': (874, 1372), 'eviw_0301.png': (1462, 1917),
         'eviw_0401.png': (2024, 2511), 'eviw_0701.png': (2613, 3320)}

for pname in PLATES:
    tt, P = traj[pname]
    n0, n1 = PERIOD[pname]
    ca, cb = CLEAN[pname]
    wclean = np.zeros((H, W), np.float32)
    wall = np.zeros((H, W), np.float32)
    for k in range(len(tt)):
        n = int(tt[k])
        M = sim_from_params(P[k]); Minv = cv2.invertAffineTransform(M)
        ones = np.ones((H, W), np.float32)
        foot = cv2.warpAffine(ones, Minv, (W, H), flags=cv2.INTER_LINEAR)
        wall += foot
        if ca <= n <= cb:
            wclean += foot
    bad = (wall > 1) & (wclean < 1)
    print('%-6s  canvas covered %.3f  of which backed only by blended frames: %.4f (%.1f%% of covered)'
          % (pname[5:9], (wall > 1).mean(), bad.mean(), 100.0 * bad.sum() / max((wall > 1).sum(), 1)))
    np.save(os.path.join(WS, 'wclean_%s.npy' % pname[5:9]), wclean)
    np.save(os.path.join(WS, 'wblend_%s.npy' % pname[5:9]), wall - wclean)
