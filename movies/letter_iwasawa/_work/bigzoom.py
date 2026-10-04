"""Large 1:1 crop of the box band, original vs delivered, at the reported frames."""
import os, sys
import numpy as np
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, yuv2rgb
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
cfr = np.load(os.path.join(WS, 'cfr_map.npy'))
OUT = os.path.join(WS, 'out_full.yuv')
NS = [int(x) for x in (sys.argv[1] if len(sys.argv) > 1 else '1383,1400,1953,1975').split(',')]
Y0, Y1 = 300, 425
X0, X1 = 0, 1280

tiles = []
fo = open(OUT, 'rb')
for n in NS:
    slot = int(np.nonzero(cfr == n)[0][0])
    fo.seek(slot * FSIZE)
    a = np.frombuffer(fo.read(FSIZE), np.uint8)
    y = a[:W * H].reshape(H, W); u = a[W * H:W * H * 2].reshape(H, W); v = a[W * H * 2:].reshape(H, W)
    tiles.append((n, pf.frame_rgb(n), yuv2rgb(y, u, v)))
fo.close()

sw = 1280
sh = Y1 - Y0
canvas = Image.new('RGB', (sw, (sh + 18) * len(tiles) * 2), (0, 0, 0))
d = ImageDraw.Draw(canvas)
k = 0
for n, old, new in tiles:
    for lab, img in (('original', old), ('delivered', new)):
        y = k * (sh + 18) + 18
        canvas.paste(Image.fromarray(np.clip(img[Y0:Y1, X0:X1], 0, 255).astype(np.uint8)), (0, y))
        d.text((3, y - 14), 'stored %d  %s  (rows %d-%d, 1:1)' % (n, lab, Y0, Y1), fill=(255, 255, 0))
        k += 1
canvas.save(os.path.join(WS, 'diag_bigzoom.png'))
print(canvas.size)
