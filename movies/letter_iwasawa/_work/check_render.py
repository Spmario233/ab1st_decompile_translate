"""Check the rendered background quality on the four exact anchors."""
import os, sys, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import render_full as rf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
BAND = rf.BAND_ROWS
ANCH = [(1049, 'eviw_0801.png', '001167.png'), (1458, 'eviw_0301.png', '001576.png'),
        (2042, 'eviw_0401.png', '002160.png'), (2692, 'eviw_0701.png', '002810.png')]

xa = rf.compute_xalpha()
traj, mos, sky, sp = rf.assets()
for n, pname, refname in ANCH:
    terms = rf.terms_for(n, xa)
    den = rf.den_for(n, terms, traj, mos)
    F = pf.frame_rgb(n)
    R = rf.estimate_R(F, den)
    bg = WHITE + R * den
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname))
    e = np.abs(bg - ref).max(axis=2)
    print('ANCHOR n=%4d %s: all rms=%.2f | band rms=%.2f p95=%.0f | outside rms=%.2f p95=%.0f' %
          (n, pname[5:9], np.sqrt(((bg - ref) ** 2).mean()),
           np.sqrt((e[BAND[0]:BAND[1]] ** 2).mean()), np.percentile(e[BAND[0]:BAND[1]], 95),
           np.sqrt((np.concatenate([e[:BAND[0]], e[BAND[1]:]]) ** 2).mean()),
           np.percentile(np.concatenate([e[:BAND[0]], e[BAND[1]:]]), 95)))
    # residual between frame and model -> subtitle mask extent
    from PIL import Image
    Image.fromarray(np.clip(e * 6, 0, 255).astype(np.uint8)).save(os.path.join(WS, 'diag_final_err_%d.png' % n))
