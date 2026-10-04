"""Coarse-match every provided reference image against the whole video (structure only)."""
import os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, yuv2rgb, load_png_rgb, ROOT, NFRAMES

DS = 8  # downsample factor -> 160x90


def ds_y(y):
    return y.reshape(H // DS, DS, W // DS, DS).mean(axis=(1, 3))


def ds_rgb(rgb):
    g = rgb.mean(axis=2)
    return g.reshape(H // DS, DS, W // DS, DS).mean(axis=(1, 3))


def zn(a):
    a = a - a.mean()
    s = a.std()
    return a / s if s > 1e-6 else a


def main():
    refs = [(os.path.join(ROOT, 'refrences', f), f) for f in sorted(os.listdir(os.path.join(ROOT, 'refrences'))) if f.endswith('.png')]
    refs += [(os.path.join(ROOT, 'refrences', 'raw_color', f), 'raw/' + f) for f in sorted(os.listdir(os.path.join(ROOT, 'refrences', 'raw_color')))]
    pats = [(ds_rgb(load_png_rgb(p)), nm) for p, nm in refs]
    pats = [(zn(a), nm) for a, nm in pats]
    best = [(-9, -1) for _ in pats]
    with open(YUV, 'rb') as f:
        for n in range(NFRAMES):
            buf = f.read(FSIZE)
            y = np.frombuffer(buf[:W * H], np.uint8).reshape(H, W)
            d = zn(ds_y(y))
            for i, (p, nm) in enumerate(pats):
                c = float((d * p).mean())
                if c > best[i][0]:
                    best[i] = (c, n)
    for (p, nm), (c, n) in zip(pats, best):
        print('%-22s  best corr=%.4f at n=%4d (t=%.2f s)' % (nm, c, n, n / 30))


if __name__ == '__main__':
    main()
