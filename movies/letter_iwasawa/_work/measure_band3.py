"""Measure the subtitle band (rows+cols) from the mosaic6-based model on plausible frames."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import render_full as rf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj, mos, sky, sp = rf.assets()
for p in mos:
    mos[p] = np.load(os.path.join(WS, 'mosaic6_%s.npy' % p[5:9])).astype(np.float32)
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
from Rfit import estimate_R

hist_r = np.zeros(H, np.int64)
hist_c = np.zeros(W, np.int64)
ok = 0
sizes = []
for n in range(0, 3442, 3):
    F = pf.frame_rgb(n)
    if rf.ILL_LO <= n <= rf.ILL_HI:
        den = rf.den_for(n, rf.terms_for(n, xa), traj, mos)
        R = estimate_R(F, den)
        bg = WHITE + R * den
    elif rf.SKY_LO <= n <= rf.SKY_HI:
        i = n - int(sp['lo'])
        bg = WHITE + sp['gamma'][i] * (rf.sky_crop(sky, sp['dy'][i]) - WHITE)
    else:
        bg = np.full((H, W, 3), WHITE, np.float32)
    d = np.abs(bg - F).max(axis=2)
    ob = np.concatenate([d[:250].ravel(), d[560:].ravel()])
    thr = float(np.clip(1.15 * np.percentile(ob, 98), 18.0, 32.0))
    m = d > thr
    s = int(m.sum())
    sizes.append(s)
    if not (1200 <= s <= 45000):
        continue
    ok += 1
    hist_r += m.sum(axis=1)
    hist_c += m.sum(axis=0)

print('frames used %d / %d' % (ok, len(sizes)))
print('rows (share of subtitle pixels):')
tot = hist_r.sum()
for r in range(280, 460, 5):
    v = hist_r[r:r + 5].sum() / tot
    print('  row %3d  %.4f %s' % (r, v, '#' * int(v * 400)))
print('cols (share):')
for c in range(0, W, 20):
    v = hist_c[c:c + 20].sum() / hist_c.sum()
    if v > 0.005:
        print('  col %4d  %.4f %s' % (c, v, '#' * int(v * 300)))
print('col cumulative:')
cum = np.cumsum(hist_c) / hist_c.sum()
for c in (0, 40, 60, 80, 100, 120, 1140, 1160, 1180, 1200, 1220, 1279):
    print('   <=%4d : %.5f' % (c, cum[c]))
