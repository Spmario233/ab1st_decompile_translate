"""Joint (offset, fade-gamma) fit for the sky fade-in/fade-out frames."""
import os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, load_png_rgb, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
mosaic = load_png_rgb(os.path.join(ROOT, 'sky_mosaic_full.png')).astype(np.float32)
MH = mosaic.shape[0]
DS = 8
ms = mosaic[::DS, ::DS, :]           # ~146 x 160 x 3
ms = np.concatenate([ms, np.repeat(ms[-1:], 12, axis=0)], axis=0)   # pad bottom
msh = H // DS                        # rows needed for one frame
BAND = (300, 500)
WHITE = 254.0


def crop_ds(dy):
    r = dy / DS + np.arange(msh, dtype=np.float32)
    r = np.clip(r, 0, msh - 1.001)
    r0 = np.floor(r).astype(np.int32)
    a = (r - r0)[:, None, None]
    return (1 - a) * ms[r0] + a * ms[r0 + 1]


def fit_frame(n):
    F = pf.frame_rgb(n)[::DS, ::DS, :]
    b0, b1 = BAND[0] // DS, BAND[1] // DS
    m = np.ones(msh, bool); m[b0:b1] = False
    best = None
    for dyq in np.arange(-30, 480, 1.0):
        M = crop_ds(dyq)
        num = ((F - WHITE) * (M - WHITE))[m].sum()
        den = ((M - WHITE) ** 2)[m].sum()
        g = num / den
        res = (((F - WHITE) - g * (M - WHITE)) ** 2)[m].mean()
        if best is None or res < best[0]:
            best = (res, dyq, g)
    # refine dy by parabola on residual
    res0, dy0, g0 = best
    def at(d):
        M = crop_ds(d)
        num = ((F - WHITE) * (M - WHITE))[m].sum()
        den = ((M - WHITE) ** 2)[m].sum()
        g = num / den
        return (((F - WHITE) - g * (M - WHITE)) ** 2)[m].mean(), g
    rm, gm = at(dy0 - 1.0); rp, gp = at(dy0 + 1.0)
    dd = (rm - 2 * res0 + rp)
    sub = 0.5 * (rm - rp) / dd if abs(dd) > 1e-12 else 0.0
    sub = max(-1.0, min(1.0, sub))
    rr, gg = at(dy0 + sub)
    return dy0 + sub, gg, np.sqrt(rr)


if __name__ == '__main__':
    for lo, hi in [(58, 118), (790, 850)]:
        print('--- %d..%d ---' % (lo, hi))
        for n in range(lo, hi):
            dy, g, rms = fit_frame(n)
            print('n=%4d t=%7.3f  dy=%8.3f  gamma=%7.4f  rms=%6.2f' % (n, n / 30, dy, g, rms))
