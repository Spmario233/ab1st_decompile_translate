"""Dump a contact sheet of frames (RGB, full-range) for eyeballing."""
import sys, os
import numpy as np
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, NFRAMES, yuv2rgb

def get_rgb(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE)
        buf = f.read(FSIZE)
    a = np.frombuffer(buf, np.uint8)
    y = a[:W * H].reshape(H, W); u = a[W * H:W * H * 2].reshape(H, W); v = a[W * H * 2:].reshape(H, W)
    return yuv2rgb(y, u, v).astype(np.uint8)

def sheet(frames, out, cols=6, sw=320):
    sh = int(round(sw * H / W))
    rows = (len(frames) + cols - 1) // cols
    canvas = Image.new('RGB', (cols * sw, rows * (sh + 14)), (32, 32, 32))
    dr = ImageDraw.Draw(canvas)
    for i, n in enumerate(frames):
        im = Image.fromarray(get_rgb(n)).resize((sw, sh), Image.LANCZOS)
        x = (i % cols) * sw; y = (i // cols) * (sh + 14)
        canvas.paste(im, (x, y + 14))
        dr.text((x + 3, y + 2), 'n=%d t=%.2f' % (n, n / 30), fill=(255, 255, 0))
    canvas.save(out)
    print(out, canvas.size)

if __name__ == '__main__':
    mode = sys.argv[1]
    if mode == 'list':
        frames = [int(x) for x in sys.argv[2].split(',')]
        sheet(frames, sys.argv[3])
