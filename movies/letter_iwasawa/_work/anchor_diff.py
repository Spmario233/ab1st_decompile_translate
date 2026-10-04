"""Difference between the anchor video frames and their exact clean reference frames."""
import os, sys
import numpy as np
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, yuv2rgb, load_png_rgb, ROOT

def get_rgb(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE); buf = f.read(FSIZE)
    a = np.frombuffer(buf, np.uint8)
    y = a[:W*H].reshape(H, W); u = a[W*H:W*H*2].reshape(H, W); v = a[W*H*2:].reshape(H, W)
    return yuv2rgb(y, u, v)

ANCH = [(1049, '001167.png'), (1458, '001576.png'), (2042, '002160.png'), (2692, '002810.png')]
out = Image.new('RGB', (W, len(ANCH) * (H // 2 + 14)), (0, 0, 0))
from PIL import ImageDraw
dr = ImageDraw.Draw(out)
for i, (n, rf) in enumerate(ANCH):
    ref = load_png_rgb(os.path.join(ROOT, 'refrences', rf))
    fr = get_rgb(n)
    d = np.abs(fr - ref).max(axis=2)
    print('n=%d  mean=%.3f  frac>4=%.5f  frac>10=%.5f  max=%.0f' % (n, d.mean(), (d > 4).mean(), (d > 10).mean(), d.max()))
    rows = np.nonzero((d > 8).sum(axis=1) > 3)[0]
    cols = np.nonzero((d > 8).sum(axis=0) > 3)[0]
    if len(rows):
        print('    diff rows %d..%d   cols %d..%d' % (rows.min(), rows.max(), cols.min(), cols.max()))
    vis = np.clip(d * 6, 0, 255).astype(np.uint8)
    im = Image.fromarray(vis).resize((W, H // 2), Image.LANCZOS)
    out.paste(im, (0, i * (H // 2 + 14) + 14))
    dr.text((3, i * (H // 2 + 14) + 1), 'n=%d  %s' % (n, rf), fill=(0, 255, 0))
out.save(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'diag_anchor_diff.png'))
print('saved diag_anchor_diff.png')
