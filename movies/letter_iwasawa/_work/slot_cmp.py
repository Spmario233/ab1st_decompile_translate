"""Compare decoded-ogv frames with rendered frames around a suspicious slot."""
import os, sys
import numpy as np
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, yuv2rgb

WS = os.path.dirname(os.path.abspath(__file__))
SLOTS = [int(x) for x in (sys.argv[1] if len(sys.argv) > 1 else '152,153,154,155,156').split(',')]
A = open(os.path.join(WS, 'out_full.yuv'), 'rb')
B = open(os.path.join(WS, 'dec_ogv.yuv'), 'rb')


def rd(f, i):
    f.seek(i * FSIZE)
    a = np.frombuffer(f.read(FSIZE), np.uint8)
    if len(a) != FSIZE:
        return None
    return yuv2rgb(a[:W * H].reshape(H, W), a[W * H:W * H * 2].reshape(H, W), a[W * H * 2:].reshape(H, W))


sw, sh = 400, 225
c = Image.new('RGB', (2 * sw + 8, (sh + 16) * len(SLOTS)), (0, 0, 0))
d = ImageDraw.Draw(c)
for i, s in enumerate(SLOTS):
    y = i * (sh + 16) + 16
    for j, f in enumerate((A, B)):
        im = rd(f, s)
        if im is not None:
            c.paste(Image.fromarray(np.clip(im, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS),
                    (j * (sw + 6), y))
    d.text((3, y - 13), 'slot %d   LEFT = rendered (out_full)   RIGHT = decoded ogv' % s, fill=(255, 255, 0))
c.save(os.path.join(WS, 'diag_slot_cmp.png'))
print(c.size)
