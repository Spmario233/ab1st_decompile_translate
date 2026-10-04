"""Estimate the screen-space 'memory filter' gain map A(x,y) for the illustration segment.

Model:   frame = white + A(x,y) * (warp(raw_plate, M) - white)      [single plate, no fade]

A is estimated at quarter resolution from frames well inside each plate's plateau.
Because the artwork is always darker than white, (plate-white) <= 0 and the subtitle
(darker than the artwork) always pushes the per-frame ratio UP, so a low temporal
percentile recovers the un-subtitled value.
"""
import os, sys, time
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
DS = 4
HH, WW = H // DS, W // DS
WHITE = 254.0

PLATES = ['eviw_0801.png', 'eviw_0301.png', 'eviw_0401.png', 'eviw_0701.png']
PLATEAU = {
    'eviw_0801.png': (908, 1392),
    'eviw_0301.png': (1448, 1962),
    'eviw_0401.png': (2008, 2528),
    'eviw_0701.png': (2604, 3288),
}
STEP = 8
NBAND = (300, 500)   # subtitle band rows (full res) to be extra careful about


def blockmean(a):
    if a.ndim == 2:
        return a.reshape(HH, DS, WW, DS).mean(axis=(1, 3))
    return a.reshape(HH, DS, WW, DS, 3).mean(axis=(1, 3))


def main():
    d = np.load(os.path.join(WS, 'geo_full.npz'))
    lo, hi = int(d['lo']), int(d['hi'])
    plates = [str(x) for x in d['plates']]
    M = d['M']
    i0 = lo

    for pname in PLATES:
        j = plates.index(pname)
        p0, p1 = PLATEAU[pname]
        fr = list(range(p0, p1 + 1, STEP))
        plate = pf.plate(pname)
        stack = np.full((len(fr), HH, WW, 3), np.nan, np.float32)
        t0 = time.time()
        for t, n in enumerate(fr):
            Mi = M[n - i0, j]
            if not np.isfinite(Mi).all() or (Mi == 0).all():
                continue
            P = cv2.warpAffine(plate, Mi, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
            F = pf.frame_rgb(n)
            dP = blockmean(P - WHITE)
            dF = blockmean(F - WHITE)
            ok = np.abs(dP) > 25
            A = np.full((HH, WW, 3), np.nan, np.float32)
            A[ok] = dF[ok] / dP[ok]
            stack[t] = A
        valid = np.isfinite(stack[..., 0])
        cnt = valid.sum(axis=0)
        good = cnt >= max(6, int(0.5 * len(fr)))
        with np.errstate(all='ignore'):
            Ap = np.nanpercentile(stack, 15, axis=0)     # low percentile: subtitle biases up
        Ap[~good] = np.nan
        print('%s: %d samples in %.0fs  valid px %.3f  -> %s' %
              (pname, len(fr), time.time() - t0, good.mean(), 'ok'))
        np.save(os.path.join(WS, 'gainA_%s.npy' % pname[5:9]), Ap)
        for c, nm in enumerate('RGB'):
            v = Ap[..., c][np.isfinite(Ap[..., c])]
            if v.size:
                print('   %s: med=%.4f p5=%.3f p95=%.3f' % (nm, np.median(v), *np.percentile(v, [5, 95])))


if __name__ == '__main__':
    main()
