"""Inside-the-box comparison of the model background vs the original, at crossfade frames."""
import os, sys, pickle
import numpy as np, cv2
from PIL import Image, ImageDraw
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
    tt, P = traj[pname]
    M = rf.M_of(traj, pname, n)
    Ma = rf.M_of(traj, pname, ANCH[pname][1])
    R = (np.vstack([M, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]
    return cv2.warpAffine(AC[pname], R, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT,
                          borderValue=(255, 255, 255)) - WHITE


box = np.zeros((H, W), bool); box[318:404, 92:1208] = True
nobox = ~box
tiles = []
for key, n in (('b', 1980), ('b', 2000), ('a', 1400)):
    terms = rf.terms_for(n, xa)
    den = rf.den_for(n, terms, traj, mos)
    F = pf.frame_rgb(n)
    R = estimate_R(F, den)
    bg = WHITE + R * den
    # ground truth from the exact anchors
    g = np.zeros((H, W, 3), np.float32)
    for pname, w in terms:
        g += w * aw(pname, n)
    gt = WHITE + g
    # alpha implied by the anchors, fitted on the non-box region
    t1 = aw(terms[0][0], n); t2 = aw(terms[-1][0], n)
    m = nobox & ((np.abs(t1).max(axis=2) > 20) | (np.abs(t2).max(axis=2) > 20))
    m3 = np.repeat(m[..., None], 3, axis=2)
    A = np.stack([t1[m3], t2[m3]], 1).astype(np.float64)
    y = (F - WHITE)[m3].astype(np.float64)
    sol, *_ = np.linalg.lstsq(A, y, rcond=None)
    al_true = sol[0] / (sol[0] + sol[1])
    print('\nn=%d terms=%s  alpha(model)=%.3f  alpha(anchor-fit)=%.3f  (rms %.2f)' %
          (n, [(t[0][5:9], round(t[1], 3)) for t in terms], terms[0][1], al_true,
           np.sqrt(((y - A @ sol) ** 2).mean())))
    print('   inside box: |F-model| mean %.2f  |F-anchor| mean %.2f' %
          (np.abs(F - bg).max(axis=2)[box].mean(), np.abs(F - gt).max(axis=2)[box].mean()))
    tiles.append((n, F, bg, gt, np.clip(np.abs(F - bg).max(axis=2) * 3, 0, 255).astype(np.uint8)))

sw, sh = 420, 236
c = Image.new('RGB', (4 * sw + 18, (sh + 16) * len(tiles)), (0, 0, 0))
d = ImageDraw.Draw(c)
for i, (n, F, bg, gt, dv) in enumerate(tiles):
    yy = i * (sh + 16) + 16
    for j, img in enumerate((F, bg, gt, np.dstack([dv] * 3).astype(np.float32))):
        c.paste(Image.fromarray(np.clip(img, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS),
                (j * (sw + 6), yy))
    d.text((3, yy - 13), 'n=%d   original | model bg | anchor-truth bg | |F-model|x3' % n, fill=(255, 255, 0))
c.save(os.path.join(WS, 'diag_boxcmp.png'))
print(c.size)
