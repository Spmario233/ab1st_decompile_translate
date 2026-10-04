"""Test the LK similarity refinement on the anchors."""
import os, sys, time
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import render_full as rf
from Rfit import estimate_R
from lkrefine import refine_sim, compose

WHITE = 254.0
xa = rf.compute_xalpha()
traj, mos, sky, sp = rf.assets()
BAND = rf.BAND_ROWS
FACTOR = int(sys.argv[1]) if len(sys.argv) > 1 else 2

for n, pname, refname in [(1049, 'eviw_0801.png', '001167.png'), (1458, 'eviw_0301.png', '001576.png'),
                          (2042, 'eviw_0401.png', '002160.png'), (2692, 'eviw_0701.png', '002810.png')]:
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname))
    F = pf.frame_rgb(n)
    Mi = rf.M_of(traj, pname, n)
    den0 = cv2.warpAffine(mos[pname], Mi, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE
    R0 = estimate_R(F, den0)
    bg0 = WHITE + R0 * den0
    e0 = np.abs(bg0 - ref).max(axis=2)
    t0 = time.time()
    T, p = refine_sim(F, bg0, rows=BAND, iters=5, ds_factor=FACTOR)
    dt = time.time() - t0
    Mnew = compose(T, Mi)
    den1 = cv2.warpAffine(mos[pname], Mnew, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE
    R1 = estimate_R(F, den1)
    bg1 = WHITE + R1 * den1
    e1 = np.abs(bg1 - ref).max(axis=2)
    print('n=%4d base rms=%.2f band=%.2f | refined rms=%.2f band=%.2f | dp=(%.3f,%.3f,%.5f,%.5f) %.2fs' %
          (n, np.sqrt(((bg0 - ref) ** 2).mean()), np.sqrt((e0[BAND[0]:BAND[1]] ** 2).mean()),
           np.sqrt(((bg1 - ref) ** 2).mean()), np.sqrt((e1[BAND[0]:BAND[1]] ** 2).mean()),
           p[0], p[1], p[2], p[3], dt))
