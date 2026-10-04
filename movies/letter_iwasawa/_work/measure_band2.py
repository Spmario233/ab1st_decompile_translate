"""Measure the true subtitle extent (v2): blend both anchors during crossfades, reject model failures."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT, load_png_rgb
import platefit as pf
from mosaic_build import sim_from_params
import render_full as rf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj = pickle.load(open(os.path.join(WS, 'traj_smooth.pkl'), 'rb'))
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
sky = load_png_rgb(os.path.join(ROOT, 'sky_mosaic_full.png')).astype(np.float32)
sp = np.load(os.path.join(WS, 'sky_params.npz'))
dy = sp['dy']; gam = sp['gamma']; slo = int(sp['lo'])
ANCHOR = {'eviw_0801.png': ('001167.png', 1049), 'eviw_0301.png': ('001576.png', 1458),
          'eviw_0401.png': ('002160.png', 2042), 'eviw_0701.png': ('002810.png', 2692)}
anchors = {p: pf.load_png_rgb(os.path.join(ROOT, 'refrences', f)).astype(np.float32) for p, (f, n) in ANCHOR.items()}


def anchor_warp(pname, n):
    tt, P = traj[pname]
    M = sim_from_params(P[min(max(n, int(tt[0])), int(tt[-1])) - int(tt[0])])
    Ma = sim_from_params(P[ANCHOR[pname][1] - int(tt[0])])
    R = (np.vstack([M, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]
    A = cv2.warpAffine(anchors[pname], R, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT, borderValue=(255, 255, 255))
    c = cv2.warpAffine(np.ones((H, W), np.float32), R, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT, borderValue=0)
    return A, c > 0.99


def sky_crop(d):
    MH = sky.shape[0]
    r = np.clip(d + np.arange(H, dtype=np.float32), 0, MH - 1.001)
    r0 = np.floor(r).astype(np.int32)
    a = (r - r0)[:, None, None]
    return (1 - a) * sky[r0] + a * sky[r0 + 1]


hist = np.zeros(H, np.int64)
ok = 0
rows_lo, rows_hi, cols_lo, cols_hi = H, 0, W, 0
sizes = []
for n in range(0, 3442, 3):
    F = pf.frame_rgb(n)
    if rf.ILL_LO <= n <= rf.ILL_HI:
        terms = rf.terms_for(n, xa)
        bg = np.zeros((H, W, 3), np.float32)
        cov = np.ones((H, W), bool)
        tot = 0.0
        for pname, w in terms:
            A, c = anchor_warp(pname, n)
            bg += w * A
            cov &= c
            tot += w
        bg /= max(tot, 1e-9)
        m = cov & (np.abs(bg - F).max(axis=2) > 26)
    elif rf.SKY_LO <= n <= rf.SKY_HI:
        i = n - slo
        bg = WHITE + gam[i] * (sky_crop(dy[i]) - WHITE)
        m = np.abs(bg - F).max(axis=2) > 20
    else:
        m = (WHITE - F).max(axis=2) > 20
    s = int(m.sum())
    sizes.append((n, s))
    if not (1500 <= s <= 50000):
        continue
    ok += 1
    rr = np.nonzero(m.any(axis=1))[0]; cc = np.nonzero(m.any(axis=0))[0]
    rows_lo = min(rows_lo, int(rr.min())); rows_hi = max(rows_hi, int(rr.max()))
    cols_lo = min(cols_lo, int(cc.min())); cols_hi = max(cols_hi, int(cc.max()))
    hist[rr.min():rr.max() + 1] += 1

print('frames used %d / %d' % (ok, len(sizes)))
print('union rows %d..%d   cols %d..%d' % (rows_lo, rows_hi, cols_lo, cols_hi))
for r in range(200, 560, 5):
    v = hist[r:r + 5].max() / max(1, ok)
    if v > 0.002:
        print('  row %3d  %.3f %s' % (r, v, '#' * int(v * 80)))
s = np.array([x[1] for x in sizes])
print('mask size p50 %d p90 %d p99 %d max %d' % tuple(np.percentile(s, [50, 90, 99]).astype(int)) + (s.max(),))
