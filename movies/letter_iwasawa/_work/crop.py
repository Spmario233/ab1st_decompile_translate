"""Crop a region out of frames and save (optionally upscaled) for inspection."""
import sys, os
import numpy as np
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, yuv2rgb

def get_rgb(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE); buf = f.read(FSIZE)
    a = np.frombuffer(buf, np.uint8)
    y = a[:W*H].reshape(H, W); u = a[W*H:W*H*2].reshape(H, W); v = a[W*H*2:].reshape(H, W)
    return yuv2rgb(y, u, v).astype(np.uint8)

if __name__ == '__main__':
    frames = [int(x) for x in sys.argv[1].split(',')]
    x0, y0, x1, y1 = [int(x) for x in sys.argv[2].split(',')]
    out = sys.argv[3]
    scale = float(sys.argv[4]) if len(sys.argv) > 4 else 1.0
    crops = [get_rgb(n)[y0:y1, x0:x1] for n in frames]
    hh, ww = crops[0].shape[:2]
    ws = int(ww * scale); hs = int(hh * scale)
    canvas = Image.new('RGB', (ws, hs * len(crops) + 12 * len(crops)), (0, 0, 0))
    from PIL import ImageDraw
    dr = ImageDraw.Draw(canvas)
    for i, c in enumerate(crops):
        im = Image.fromarray(c).resize((ws, hs), Image.NEAREST if scale > 1 else Image.LANCZOS)
        canvas.paste(im, (0, i * (hs + 12) + 12))
        dr.text((3, i * (hs + 12) + 1), 'n=%d' % frames[i], fill=(0, 255, 0))
    canvas.save(out); print(out, canvas.size)
