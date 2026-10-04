"""Ground-truth check: reconstruct the four anchor frames and compare with the exact clean PNGs."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import model as md

WS = os.path.dirname(os.path.abspath(__file__))
ANCH = [(1049, 'eviw_0801.png', '001167.png'), (1458, 'eviw_0301.png', '001576.png'),
        (2042, 'eviw_0401.png', '002160.png'), (2692, 'eviw_0701.png', '002810.png')]
BAND = (300, 500)

d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']

for n, pname, refname in ANCH:
    M = M4[n - lo, plates.index(pname)]
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname))
    for sigma in (0.0, 1.0, 2.0, 3.0):
        A = md.gain_full(pname, sigma=sigma)
        den = md.den_of(pname, M)
        bg = md.WHITE + A * den
        e = bg - ref
        eout = np.abs(e).max(axis=2)
        band = eout[BAND[0]:BAND[1], :]
        out = np.concatenate([eout[:BAND[0]], eout[BAND[1]:]], axis=0)
        print('n=%4d %s sigma=%.1f | all rms=%.2f p99=%.1f | band rms=%.2f p99=%.1f max=%.0f | outside rms=%.2f p99=%.1f' %
              (n, pname[5:9], sigma,
               np.sqrt((e ** 2).mean()), np.percentile(eout, 99),
               np.sqrt((e[BAND[0]:BAND[1]] ** 2).mean()), np.percentile(band, 99), band.max(),
               np.sqrt((out ** 2).mean()), np.percentile(out, 99)))
    # save a visual of the best
    A = md.gain_full(pname, sigma=2.0)
    den = md.den_of(pname, M)
    bg = md.WHITE + A * den
    vis = np.clip(np.abs(bg - ref).max(axis=2) * 4, 0, 255).astype(np.uint8)
    from PIL import Image
    Image.fromarray(vis).save(os.path.join(WS, 'diag_anch_err_%d.png' % n))
