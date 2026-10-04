"""Diagnose the 'white dirt' the user reported: dump bg, mask and mosaic coverage for frames."""
import os, sys
import numpy as np, cv2
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, YUV
import platefit as pf
import render_full as rf
from Rfit import estimate_R
from mosaic_build import sim_from_params, PLATES, PERIOD

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
import pickle
xa = pickle.load(open(os.path.join(WS,'xalpha.pkl'),'rb'))
traj, mos, sky, sp = rf.assets()

# coverage (sample count) per plate: re-derive cheaply from the trajectory footprint
print('plate canvas coverage vs plate mosaic extent')
for p in PLATES:
    tt, P = traj[p]
    cov = np.zeros((H, W), np.uint8)
    for k in range(len(tt)):
        M = sim_from_params(P[k]); Minv = cv2.invertAffineTransform(M)
        c = np.float32([[0, 0], [W, 0], [W, H], [0, H]]).reshape(-1, 1, 2)
        pc = cv2.transform(c, Minv).reshape(-1, 2).astype(np.int32)
        cv2.fillConvexPoly(cov, pc, 1)
    print('  %s union footprint %.3f of canvas' % (p[5:9], cov.mean()))
    np.save(os.path.join(WS, 'cover_%s.npy' % p[5:9]), cov)

tiles = []
for n in (1353, 1443, 2463, 3273, 1200, 3000):
    terms = rf.terms_for(n, xa)
    den = rf.den_for(n, terms, traj, mos)
    F = pf.frame_rgb(n)
    R = estimate_R(F, den)
    bg = WHITE + R * den
    diff = np.abs(bg - F).max(axis=2)
    ob = np.concatenate([diff[:rf.BAND_ROWS[0]].ravel(), diff[rf.BAND_ROWS[1]:].ravel()])
    thr = float(np.clip(1.15 * np.percentile(ob, 98), rf.MASK_THR, 32.0))
    m = diff > thr
    # uncovered mosaic pixels inside the footprint
    unc = np.zeros((H, W), np.uint8)
    for pname, w in terms:
        M = rf.M_of(traj, pname, n); Minv = cv2.invertAffineTransform(M)
        cv2.warpAffine(1 - np.load(os.path.join(WS, 'cover_%s.npy' % pname[5:9])), Minv, (W, H),
                       dst=unc, flags=cv2.INTER_NEAREST | cv2.WARP_INVERSE_MAP)
    print('n=%4d terms=%s thr=%.1f  mask=%6d  uncovered(uint8>0)=%6d' %
          (n, [(t[0][5:9], round(t[1], 2)) for t in terms], thr, m.sum(), (unc > 0).sum()))
    tiles.append((n, F, bg, m, unc > 0))

y0, y1, x0, x1 = 200, 620, 0, 1280
sc = 0.5
w = int((x1 - x0) * sc); h = int((y1 - y0) * sc)
canvas = Image.new('RGB', (w, (h + 16) * len(tiles) * 3), (0, 0, 0))
d = ImageDraw.Draw(canvas)
k = 0
for n, F, bg, m, un in tiles:
    for lab, img in (('orig', F), ('bg', bg), ('mask', np.dstack([m * 255, un * 255, np.zeros_like(m, np.uint8)]).astype(np.float32))):
        y = k * (h + 16) + 16
        canvas.paste(Image.fromarray(np.clip(img[y0:y1, x0:x1], 0, 255).astype(np.uint8)).resize((w, h), Image.LANCZOS), (0, y))
        d.text((3, y - 13), 'n=%d %s (mask=red, uncovered=green)' % (n, lab) if lab == 'mask' else 'n=%d %s' % (n, lab), fill=(255, 255, 0))
        k += 1
canvas.save(os.path.join(WS, 'diag_dirt.png'))
print('saved diag_dirt.png', canvas.size)
