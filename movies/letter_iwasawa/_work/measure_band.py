"""Measure the true subtitle extent using reliable references (anchor warps / sky mosaic / white)."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT, load_png_rgb
import platefit as pf
from mosaic_build import sim_from_params

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj = pickle.load(open(os.path.join(WS, 'traj_smooth.pkl'), 'rb'))
mos = {p: np.load(os.path.join(WS, 'mosaic5_%s.npy' % p[5:9])).astype(np.float32)
       for p in ['eviw_0801.png', 'eviw_0301.png', 'eviw_0401.png', 'eviw_0701.png']}
sky = load_png_rgb(os.path.join(ROOT, 'sky_mosaic_full.png')).astype(np.float32)
sp = np.load(os.path.join(WS, 'sky_params.npz'))
dy = sp['dy']; gam = sp['gamma']; slo = int(sp['lo'])
ANCHOR = {'eviw_0801.png': ('001167.png', 1049), 'eviw_0301.png': ('001576.png', 1458),
          'eviw_0401.png': ('002160.png', 2042), 'eviw_0701.png': ('002810.png', 2692)}
anchors = {p: pf.load_png_rgb(os.path.join(ROOT, 'refrences', f)).astype(np.float32) for p, (f, n) in ANCHOR.items()}
import render_full as rf


def sky_crop(d):
    MH = sky.shape[0]
    r = np.clip(d + np.arange(H, dtype=np.float32), 0, MH - 1.001)
    r0 = np.floor(r).astype(np.int32)
    a = (r - r0)[:, None, None]
    return (1 - a) * sky[r0] + a * sky[r0 + 1]


rows_lo, rows_hi, cols_lo, cols_hi = H, 0, W, 0
hist = np.zeros(H, np.int64)
per_frame = []
for n in range(0, 3442, 5):
    F = pf.frame_rgb(n)
    if rf.ILL_LO <= n <= rf.ILL_HI:
        # pick the plate with the largest weight
        terms = rf.terms_for(n, pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb')))
        pname, w = max(terms, key=lambda t: t[1])
        tt, P = traj[pname]
        M = sim_from_params(P[min(max(n, int(tt[0])), int(tt[-1])) - int(tt[0])])
        refname, nanchor = ANCHOR[pname]
        Ma = sim_from_params(P[nanchor - int(tt[0])])
        R = (np.vstack([M, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]
        bg = cv2.warpAffine(anchors[pname], R, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT, borderValue=(255, 255, 255))
        d = np.abs(bg - F).max(axis=2)
        m = d > 26
    elif rf.SKY_LO <= n <= rf.SKY_HI:
        i = n - slo
        bg = WHITE + gam[i] * (sky_crop(dy[i]) - WHITE)
        d = np.abs(bg - F).max(axis=2)
        m = d > 20
    else:
        d = (WHITE - F).max(axis=2)
        m = d > 20
    if m.sum() < 200:
        continue
    rr = np.nonzero(m.any(axis=1))[0]
    cc = np.nonzero(m.any(axis=0))[0]
    # trim 0.2% outliers
    rr = rr[(rr >= np.percentile(rr, 0.5)) & (rr <= np.percentile(rr, 99.5))]
    cc = cc[(cc >= np.percentile(cc, 0.5)) & (cc <= np.percentile(cc, 99.5))]
    rows_lo = min(rows_lo, int(rr.min())); rows_hi = max(rows_hi, int(rr.max()))
    cols_lo = min(cols_lo, int(cc.min())); cols_hi = max(cols_hi, int(cc.max()))
    hist[rr.min():rr.max() + 1] += 1
    per_frame.append((n, int(rr.min()), int(rr.max()), int(cc.min()), int(cc.max()), int(m.sum())))

print('union rows %d..%d   cols %d..%d' % (rows_lo, rows_hi, cols_lo, cols_hi))
print('row occupancy (fraction of sampled frames with subtitle pixels):')
for r in range(0, H, 10):
    v = hist[r:r + 10].max() / max(1, len(per_frame))
    if v > 0.001:
        print('  %3d %.3f %s' % (r, v, '#' * int(v * 60)))
import collections
print('\ncol range distribution:')
cl = [p[3] for p in per_frame]; ch = [p[4] for p in per_frame]
print('  min-col p1/p50/p99:', np.percentile(cl, [1, 50, 99]).astype(int))
print('  max-col p1/p50/p99:', np.percentile(ch, [1, 50, 99]).astype(int))
rl = [p[1] for p in per_frame]; rh = [p[2] for p in per_frame]
print('  min-row p1/p50/p99:', np.percentile(rl, [1, 50, 99]).astype(int))
print('  max-row p1/p50/p99:', np.percentile(rh, [1, 50, 99]).astype(int))
big = sorted(per_frame, key=lambda x: -x[5])[:10]
print('  largest masks:', big)
