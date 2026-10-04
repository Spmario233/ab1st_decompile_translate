"""Sky segment: sub-pixel mosaic crop, residual analysis, subtitle band discovery."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, load_png_rgb, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
mosaic = load_png_rgb(os.path.join(ROOT, 'sky_mosaic_full.png')).astype(np.float32)
MH = mosaic.shape[0]


def crop(dy):
    r = dy + np.arange(H, dtype=np.float32)
    r = np.clip(r, 0, MH - 1.001)
    r0 = np.floor(r).astype(np.int32)
    a = (r - r0)[:, None, None]
    return (1 - a) * mosaic[r0] + a * mosaic[r0 + 1]


def main():
    offs = np.load(os.path.join(WS, 'sky_off.npy'))
    lo, hi = [int(x) for x in np.load(os.path.join(WS, 'sky_lo.npy'))]
    acc = np.zeros((H, W), np.float32)
    cnt = 0
    errs = []
    for i, n in enumerate(range(lo, hi)):
        if n < 112 or n > 800:
            continue
        F = pf.frame_rgb(n)
        bg = crop(offs[i])
        d = F - bg
        dm = np.abs(d).max(axis=2)
        acc = np.maximum(acc, dm)
        errs.append(np.sqrt((d ** 2).mean()))
        cnt += 1
    print('frames %d  rms mean %.3f max %.3f' % (cnt, np.mean(errs), np.max(errs)))
    np.save(os.path.join(WS, 'sky_resmax.npy'), acc)
    vis = np.clip(acc * 8, 0, 255).astype(np.uint8)
    from PIL import Image
    Image.fromarray(vis).save(os.path.join(WS, 'diag_sky_resmax.png'))
    # rows/cols with strong residual
    rows = np.nonzero((acc > 25).sum(axis=1) > 3)[0]
    cols = np.nonzero((acc > 25).sum(axis=0) > 3)[0]
    print('strong-residual rows', rows.min() if len(rows) else None, rows.max() if len(rows) else None)
    print('strong-residual cols', cols.min() if len(cols) else None, cols.max() if len(cols) else None)
    prof = (acc > 25).mean(axis=1)
    for r in range(0, H, 10):
        v = prof[r:r + 10].max()
        if v > 0.002:
            print('  row %3d  %.4f %s' % (r, v, '#' * int(v * 60)))


if __name__ == '__main__':
    main()
