"""Zoomed original-vs-delivered comparison across the two transitions."""
import os, sys, pickle
import numpy as np, cv2
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, YUV
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
cfr = np.load(os.path.join(WS, 'cfr_map.npy'))
OUT = os.path.join(WS, 'out_full.yuv')
which = sys.argv[1] if len(sys.argv) > 1 else 'a'
NS = list(range(1380, 1441, 10)) if which == 'a' else list(range(1950, 2021, 10))
Y0, Y1 = 200, 500

tiles = []
with open(OUT, 'rb') as fo:
    for n in NS:
        slot = int(np.nonzero(cfr == n)[0][0])
        fo.seek(slot * FSIZE)
        a = np.frombuffer(fo.read(FSIZE), np.uint8).reshape(3, H, W)
        new = np.dstack([a[0], a[1], a[2]])
        old = pf.frame_rgb(n)
        tiles.append((n, old, new))

sw = 560
sh = int(sw * (Y1 - Y0) / W)
canvas = Image.new('RGB', (2 * sw + 8, (sh + 18) * len(tiles)), (0, 0, 0))
d = ImageDraw.Draw(canvas)
for i, (n, old, new) in enumerate(tiles):
    y = i * (sh + 18) + 18
    canvas.paste(Image.fromarray(np.clip(old[Y0:Y1], 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (0, y))
    canvas.paste(Image.fromarray(np.clip(new[Y0:Y1], 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (sw + 8, y))
    d.text((3, y - 14), 'stored %d   LEFT = original   RIGHT = delivered' % n, fill=(255, 255, 0))
canvas.save(os.path.join(WS, 'diag_xzoom_%s.png' % which))
print(canvas.size)
