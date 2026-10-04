"""Zoomed original-vs-delivered comparison across the two transitions (proper RGB)."""
import os, sys, pickle
import numpy as np
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, YUV, yuv2rgb
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
cfr = np.load(os.path.join(WS, 'cfr_map.npy'))
OUT = os.path.join(WS, 'out_full.yuv')
which = sys.argv[1] if len(sys.argv) > 1 else 'a'
NS = list(range(1380, 1441, 10)) if which == 'a' else list(range(1950, 2021, 10))
Y0, Y1 = 250, 460

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
    box = np.zeros((H, W), bool); box[318:404, 92:1208] = True
    print('stored %4d  |new-old| in box: mean %.2f p95 %.0f max %.0f' %
          (n, d[box].mean(), np.percentile(d[box], 95), d[box].max()))
    tiles.append((n, old, new))
fo.close()

sw = 560
sh = int(sw * (Y1 - Y0) / W)
canvas = Image.new('RGB', (2 * sw + 8, (sh + 18) * len(tiles)), (0, 0, 0))
dr = ImageDraw.Draw(canvas)
for i, (n, old, new) in enumerate(tiles):
    y = i * (sh + 18) + 18
    canvas.paste(Image.fromarray(np.clip(old[Y0:Y1], 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (0, y))
    canvas.paste(Image.fromarray(np.clip(new[Y0:Y1], 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (sw + 8, y))
    dr.text((3, y - 14), 'stored %d   LEFT = original   RIGHT = delivered' % n, fill=(255, 255, 0))
canvas.save(os.path.join(WS, 'diag_xzoom_%s.png' % which))
print(canvas.size)
