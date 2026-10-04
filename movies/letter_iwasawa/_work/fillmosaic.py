"""Fill the uncovered (NaN) areas of the plate mosaics with a smooth pyramid interpolation."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H

WS = os.path.dirname(os.path.abspath(__file__))
PLATES = ['eviw_0801.png', 'eviw_0301.png', 'eviw_0401.png', 'eviw_0701.png']


def simple_fill(A, iters=200):
    A = A.copy()
    for _ in range(iters):
        m = ~np.isfinite(A)
        if not m.any():
            break
        V = np.where(m, 0.0, A)
        C = (~m).astype(np.float32)
        k = np.ones((3, 3), np.float32)
        s = cv2.filter2D(V, -1, k, borderType=cv2.BORDER_REPLICATE)
        c = cv2.filter2D(C, -1, k, borderType=cv2.BORDER_REPLICATE)
        A = np.where(m, s / np.maximum(c, 1e-6), A)
    return A


def fill_mosaic(A):
    A = A.astype(np.float32).copy()
    if not np.isnan(A).any():
        return A
    for f in (16, 8, 4, 2, 1):
        m2 = np.isnan(A[..., 0])
        if not m2.any():
            break
        if f == 1:
            up = simple_fill(A)
            A = np.where(m2[..., None], up, A)
            break
        hh, ww = max(1, H // f), max(1, W // f)
        V = np.nan_to_num(A, nan=0.0)
        M = (~m2).astype(np.float32)
        Vs = cv2.resize(V, (ww, hh), interpolation=cv2.INTER_AREA)
        Ms = cv2.resize(M, (ww, hh), interpolation=cv2.INTER_AREA)[..., None]
        Cs = Vs / np.maximum(Ms, 1e-6)
        Cs = np.where(np.isfinite(Cs), Cs, np.nan)
        Cs = simple_fill(Cs, iters=400)
        up = cv2.resize(Cs, (W, H), interpolation=cv2.INTER_CUBIC)
        A = np.where(m2[..., None], up, A)
    return np.clip(A, 0, 255)


if __name__ == '__main__':
    for p in PLATES:
        a = np.load(os.path.join(WS, 'mosaic2_%s.npy' % p[5:9]))
        print(p[5:9], 'nan %.4f ->' % np.isnan(a[..., 0]).mean(), end=' ')
        b = fill_mosaic(a)
        print('nan %.4f  range %.1f..%.1f' % (np.isnan(b[..., 0]).mean(), b.min(), b.max()))
        np.save(os.path.join(WS, 'mosaic3_%s.npy' % p[5:9]), b)
        from PIL import Image
        Image.fromarray(np.clip(b, 0, 255).astype(np.uint8)).save(
            os.path.join(WS, 'diag_mosaic3_%s.png' % p[5:9]))
