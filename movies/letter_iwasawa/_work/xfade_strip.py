"""Contact strip across a crossfade, to locate which stored frame matches the user's pause."""
import os, sys, pickle
import numpy as np
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
cfr = np.load(os.path.join(WS, 'cfr_map.npy'))


def strip(ns, out, cols=6, sw=300):
    sh = int(sw * 720 / 1280)
    rows = (len(ns) + cols - 1) // cols
    canvas = Image.new('RGB', (cols * sw, rows * (sh + 15)), (20, 20, 20))
    d = ImageDraw.Draw(canvas)
    for i, n in enumerate(ns):
        im = Image.fromarray(pf.frame_rgb(n).astype(np.uint8)).resize((sw, sh), Image.LANCZOS)
        x = (i % cols) * sw; y = (i // cols) * (sh + 15)
        canvas.paste(im, (x, y + 15))
        slot = int(np.nonzero(cfr == n)[0][0])
        d.text((x + 3, y + 2), 'stored %d  t=%.2fs' % (n, slot / 30.0), fill=(255, 255, 0))
    canvas.save(out)
    print(out, canvas.size)


if __name__ == '__main__':
    which = sys.argv[1]
    if which == 'a':
        strip(list(range(1380, 1471, 5)), os.path.join(WS, 'diag_strip_a.png'))
    else:
        strip(list(range(1950, 2031, 5)), os.path.join(WS, 'diag_strip_b.png'))
