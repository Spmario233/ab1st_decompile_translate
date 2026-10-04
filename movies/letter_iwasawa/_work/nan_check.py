import os, sys
import numpy as np, cv2, pickle
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
from mosaic_build import sim_from_params

WS = os.path.dirname(os.path.abspath(__file__))
traj = pickle.load(open(os.path.join(WS, 'traj_smooth.pkl'), 'rb'))
for p in ['eviw_0801.png', 'eviw_0301.png', 'eviw_0401.png', 'eviw_0701.png']:
    a = np.load(os.path.join(WS, 'mosaic2_%s.npy' % p[5:9]))
    nan = np.isnan(a[..., 0]).astype(np.uint8)
    tt, P = traj[p]
    worst = 0; wn = -1
    for k in range(len(tt)):
        n = int(tt[k])
        M = sim_from_params(P[k]); Minv = cv2.invertAffineTransform(M)
        c = np.float32([[0, 0], [W, 0], [W, H], [0, H]]).reshape(-1, 1, 2)
        pc = cv2.transform(c, Minv).reshape(-1, 2).astype(np.int32)
        m = np.zeros((H, W), np.uint8); cv2.fillConvexPoly(m, pc, 1)
        ov = int((nan & m).sum())
        if ov > worst:
            worst = ov; wn = n
    print('%-6s nan %.4f  worst footprint overlap %7d px (%.3f%%) at n=%d' %
          (p[5:9], nan.mean(), worst, 100 * worst / (W * H), wn))
