"""Difference map between the original and the delivered frame, across the transitions."""
import os, sys
import numpy as np
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, yuv2rgb
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
cfr = np.load(os.path.join(WS, 'cfr_map.npy'))
OUT = os.path.join(WS, 'out_full.yuv')
which = sys.argv[1] if len(sys.argv) > 1 else 'b'
NS = list(range(1940, 2041, 20)) if which == 'b' else list(range(1370, 1471, 20))
box = np.zeros((H, W), bool); box[318:404, 92:1208] = True
d_out = np.zeros((H, W), bool); d_out[322:400, 96:1204] = True

tiles = []
fo = open(OUT, 'rb')
for n in NS:
    slot = int(np.nonzero(cfr == n)[0][0])
    fo.seek(slot * FSIZE)
    a = np.frombuffer(fo.read(FSIZE), np.uint8)
    y = a[:W * H].reshape(H, W); u = a[W * H:W * H * 2].reshape(H, W); v = a[W * H * 2:].reshape(H, W)
    new = yuv2rgb(y, u, v)
    old = pf.frame_rgb(n)
    d = np.abs(new - old).max(axis=2)
    print('stored %4d  outside box: mean %.2f p99 %.0f | inside box: mean %.2f p99 %.0f' %
          (n, d[~box].mean(), np.percentile(d[~box], 99), d[box].mean(), np.percentile(d[box], 99)))
    tiles.append((n, old, new, np.clip(d * 3, 0, 255).astype(np.uint8)))
fo.close()

sw, sh = 400, 225
canvas = Image.new('RGB', (3 * sw + 12, (sh + 16) * len(tiles)), (0, 0, 0))
dr = ImageDraw.Draw(canvas)
for i, (n, old, new, dv) in enumerate(tiles):
    yy = i * (sh + 16) + 16
    for j, img in enumerate((old, new, np.dstack([dv] * 3).astype(np.float32))):
        canvas.paste(Image.fromarray(np.clip(img, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS),
                     (j * (sw + 6), yy))
    dr.text((3, yy - 13), 'stored %d   original | delivered | |diff|x3' % n, fill=(255, 255, 0))
canvas.save(os.path.join(WS, 'diag_xdiff_%s.png' % which))
print(canvas.size)
