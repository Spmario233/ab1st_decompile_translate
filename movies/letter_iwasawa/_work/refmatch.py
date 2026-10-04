"""Match the provided reference PNGs against video frames."""
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

def get_y(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE); buf = f.read(W * H)
    return np.frombuffer(buf, np.uint8).reshape(H, W)

refs = sorted(os.listdir(os.path.join(ROOT, 'refrences', 'raw_color')))
cands = [int(os.path.splitext(x)[0]) for x in sorted(os.listdir(os.path.join(ROOT, 'refrences'))) if x.endswith('.png')]
print('candidate video frame numbers from filenames:', cands)

# 1) do refrences/NNNNNN.png equal video frame NNNNNN?
for c in cands:
    p = os.path.join(ROOT, 'refrences', '%06d.png' % c)
    rgb = load_png_rgb(p)
    for dn in (0, -1, 1):
        v = get_rgb(c + dn)
        d = np.abs(v - rgb)
        print('  %06d vs video %d : mean|d|=%.3f max=%.1f  frac>2=%.4f' % (c, c + dn, d.mean(), d.max(), (d > 2).mean()))
