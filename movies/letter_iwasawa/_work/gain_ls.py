"""Per-pixel least squares for the screen-space gain.

For every screen pixel p the model  F_n(p) - white = A(p) * (warp(P_n)(p) - white)
is linear in the single unknown A(p), so all frames of a plate's plateau can be
accumulated in one streaming pass.  Subtitle pixels are outliers and are rejected
with a second, reweighted pass.
"""
import os, sys, time
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
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


def bm(a):
    if a.ndim == 2:
        return a.reshape(HH, DS, WW, DS).mean(axis=(1, 3))
    return a.reshape(HH, DS, WW, DS, 3).mean(axis=(1, 3))


def build(pname, extra_skip=()):
    d = np.load(os.path.join(WS, 'geo_full.npz'))
    lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']
    j = plates.index(pname)
    p0, p1 = PLATEAU[pname]
    fr = [n for n in range(p0, p1 + 1) if n not in extra_skip]
    num = np.zeros((HH, WW, 3), np.float64)
    den2 = np.zeros((HH, WW, 3), np.float64)
    nfr = np.zeros((HH, WW, 1), np.float32)
    plate = pf.plate(pname)
    t0 = time.time()
    for n in fr:
        M = M4[n - lo, j]
        P = cv2.warpAffine(plate, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        dP = bm(P - WHITE)
        dF = bm(pf.frame_rgb(n) - WHITE)
        num += dP * dF
        den2 += dP * dP
        nfr += 1
    A = num / np.maximum(den2, 1e-9)
    # keep a record before reweighting
    A1 = A.copy()
    # second pass, robust reweighting
    num[:] = 0; den2[:] = 0
    for n in fr:
        M = M4[n - lo, j]
        P = cv2.warpAffine(plate, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        dP = bm(P - WHITE)
        dF = bm(pf.frame_rgb(n) - WHITE)
        r = dF - A1 * dP
        w = (np.abs(r) < 12).astype(np.float64)
        num += w * dP * dF
        den2 += w * dP * dP
    A2 = num / np.maximum(den2, 1e-9)
    good = np.isfinite(A2) & (den2 > 0)
    print('%s: %d frames %.0fs  A1 med=%.4f A2 med=%.4f  good=%.3f' %
          (pname[5:9], len(fr), time.time() - t0, np.median(A1[..., 0]), np.median(A2[..., 0]), good[..., 0].mean()))
    return A2, good, d  # noqa


if __name__ == '__main__':
    out = {}
    for p in PLATES:
        A, good, _ = build(p)
        A[~good] = np.nan
        np.save(os.path.join(WS, 'gainLS_%s.npy' % p[5:9]), A.astype(np.float32))
        out[p] = (A, good)
    # report the reconstruction residual achieved at the four anchors
    d = np.load(os.path.join(WS, 'geo_full.npz'))
    lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']
    ANCH = [(1049, 'eviw_0801.png'), (1458, 'eviw_0301.png'), (2042, 'eviw_0401.png'), (2692, 'eviw_0701.png')]
    import model as md
    for n, pname in ANCH:
        A = out[pname][0]
        Af = np.stack([md._fill_nan(A[..., c]) for c in range(3)], 2)
        Af = cv2.GaussianBlur(Af, (0, 0), 2.0, borderType=cv2.BORDER_REPLICATE)
        Af = cv2.resize(Af, (W, H), interpolation=cv2.INTER_CUBIC)
        M = M4[n - lo, plates.index(pname)]
        P = cv2.warpAffine(pf.plate(pname), M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        bg = WHITE + Af * (P - WHITE)
        F = pf.frame_rgb(n)
        e = np.abs(bg - F).max(axis=2)
        print('anchor %d %s: rms=%.2f p90=%.1f p99=%.1f' %
              (n, pname[5:9], np.sqrt(((bg - F) ** 2).mean()), np.percentile(e, 90), np.percentile(e, 99)))
