"""Final sky-segment parameters: per-frame vertical offset and fade factor."""
import os, sys, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, load_png_rgb, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
mosaic = load_png_rgb(os.path.join(ROOT, 'sky_mosaic_full.png')).astype(np.float32)
MH = mosaic.shape[0]
DS = 4
ms = mosaic[::DS, ::DS, :]
ms = np.concatenate([ms, np.repeat(ms[-1:], 8, axis=0)], axis=0)
FS = H // DS
WHITE = 254.0
LO, HI = 64, 840
BAND = (280, 520)


def crop_ds(dy):
    r = dy / DS + np.arange(FS, dtype=np.float32)
    r = np.clip(r, 0, ms.shape[0] - 1.001)
    r0 = np.floor(r).astype(np.int32)
    a = (r - r0)[:, None, None]
    return (1 - a) * ms[r0] + a * ms[r0 + 1]


def cost(F, m, dy):
    M = crop_ds(dy)
    num = ((F - WHITE) * (M - WHITE))[m].sum()
    den = ((M - WHITE) ** 2)[m].sum()
    g = num / den if den > 0 else 0.0
    r = (((F - WHITE) - g * (M - WHITE)) ** 2)[m].mean()
    return r, g


def main():
    dys = np.full(HI - LO + 1, np.nan)
    gam = np.full(HI - LO + 1, np.nan)
    rms = np.full(HI - LO + 1, np.nan)
    b0, b1 = BAND[0] // DS, BAND[1] // DS
    mask = np.ones(FS, bool); mask[b0:b1] = False
    prev = 443.0
    t0 = time.time()
    for i, n in enumerate(range(LO, HI + 1)):
        F = pf.frame_rgb(n)[::DS, ::DS, :]
        best = None
        for dy in np.arange(prev - 3.0, prev + 3.01, 0.5):
            r, g = cost(F, mask, dy)
            if best is None or r < best[0]:
                best = (r, dy, g)
        r0, d0, g0 = best
        rm, gm = cost(F, mask, d0 - 0.5)
        rp, gp = cost(F, mask, d0 + 0.5)
        dd = rm - 2 * r0 + rp
        sub = 0.5 * (rm - rp) / dd if abs(dd) > 1e-12 else 0.0
        sub = max(-1.0, min(1.0, sub))
        rr, gg = cost(F, mask, d0 + sub)
        dys[i] = d0 + sub; gam[i] = gg; rms[i] = np.sqrt(rr)
        prev = d0 + sub
        if i % 100 == 0:
            print('n=%4d dy=%8.3f gamma=%.4f rms=%.2f  (%.0fs)' % (n, dys[i], gam[i], rms[i], time.time() - t0), flush=True)
    np.savez(os.path.join(WS, 'sky_params.npz'), lo=LO, hi=HI, dy=dys, gamma=gam, rms=rms)
    print('rms: mean %.2f max %.2f' % (np.nanmean(rms), np.nanmax(rms)))
    for i in range(0, len(dys), 25):
        print('  n=%4d dy=%8.3f gamma=%.4f rms=%.2f' % (LO + i, dys[i], gam[i], rms[i]))


if __name__ == '__main__':
    main()
