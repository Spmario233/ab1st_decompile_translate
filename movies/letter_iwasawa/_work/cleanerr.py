"""On clean pixels inside the box, how wrong is each candidate background?

clean  = the frame's own subtitle is absent there (judged by the exact anchor warps)
error  = |F - candidate| on those clean pixels -> this is exactly how visible the box is
"""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import render_full as rf
from Rfit import estimate_R

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj, mos, sky, sp = rf.assets()
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
ANCH = {'eviw_0801.png': ('001167.png', 1049), 'eviw_0301.png': ('001842.png', 1724),
        'eviw_0401.png': ('002160.png', 2042), 'eviw_0701.png': ('002810.png', 2692)}
AC = {p: pf.load_png_rgb(os.path.join(ROOT, 'refrences', f)).astype(np.float32) for p, (f, n) in ANCH.items()}


def aw(pname, n):
    M = rf.M_of(traj, pname, n); Ma = rf.M_of(traj, pname, ANCH[pname][1])
    R = (np.vstack([M, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]
    return (cv2.warpAffine(AC[pname], R, (W, H), flags=cv2.INTER_LINEAR,
                           borderMode=cv2.BORDER_CONSTANT, borderValue=(255, 255, 255)) - WHITE)


box = np.zeros((H, W), bool); box[318:404, 92:1208] = True
print('  n    alpha   | mosaic-model err | anchor-model err | anchor-truth err   (clean px, box)')
for key, ns in (('a', [1375, 1390, 1410, 1430, 1450, 1465]),
                ('b', [1945, 1960, 1980, 2000, 2020, 2035]),
                ('c', [2505, 2530, 2555, 2580, 2605])):
    for n in ns:
        terms = rf.terms_for(n, xa)
        if len(terms) == 1:
            print('%5d   pure    (skipped)' % n); continue
        den = rf.den_for(n, terms, traj, mos)
        F = pf.frame_rgb(n)
        bgm = WHITE + estimate_R(F, den) * den
        g = np.zeros((H, W, 3), np.float32)
        for pname, w in terms:
            g += w * aw(pname, n)
        bga = WHITE + g
        clean = (np.abs(F - bga).max(axis=2) < 18) & box
        e_m = np.abs(F - bgm).max(axis=2)[clean]
        e_a = np.abs(F - bga).max(axis=2)[clean]
        print('%5d   %.3f   %8.2f (p95 %5.1f) %8.2f (p95 %5.1f)   n=%d' %
              (n, terms[0][1], e_m.mean(), np.percentile(e_m, 95), e_a.mean(), np.percentile(e_a, 95), clean.sum()))
