"""Detect the subtitle band: thin dark strokes on a locally-light background."""
import os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE

R = 12  # half window for local mean


def boxmean(a, r):
    p = np.pad(a, r, mode='edge').cumsum(0).cumsum(1)
    p = np.pad(p, ((1, 0), (1, 0)))
    n = 2 * r + 1
    return (p[n:, n:] - p[:-n, n:] - p[n:, :-n] + p[:-n, :-n]) / (n * n)


def textmask(y):
    lm = boxmean(y.astype(np.float32), R)
    return (lm - y) > 38


def main(lo, hi, x0=0, x1=1280, out='submask.npz'):
    N = hi - lo
    rows = np.zeros((N, H), np.int16)
    with open(YUV, 'rb') as f:
        for i, n in enumerate(range(lo, hi)):
            f.seek(n * FSIZE + 0)
            buf = f.read(W * H)
            y = np.frombuffer(buf, np.uint8).reshape(H, W)
            m = textmask(y[:, x0:x1])
            rows[i] = m.sum(axis=1)
            if i % 300 == 0:
                print(i, n, flush=True)
    np.savez_compressed(out, rows=rows, lo=lo, hi=hi, x0=x0, x1=x1)
    prof = (rows > 2).mean(axis=0)
    for r in range(0, H, 8):
        print('%4d  %.3f  %s' % (r, prof[r], '#' * int(prof[r] * 120)))


if __name__ == '__main__':
    main(int(sys.argv[1]), int(sys.argv[2]), out=sys.argv[3])
