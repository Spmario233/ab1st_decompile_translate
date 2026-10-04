"""Shared helpers for the letter_iwasawa subtitle-removal work.

Video facts (measured, see README):
  * source: Theora 1280x720 yuv444p, 30 fps, 3442 *stored* frames = 114.733 s of unique content
    (the Ogg container claims 126.167 s because trailing still frames are folded into granulepos).
  * full-range BT.601:  Y = 0.299R+0.587G+0.114B, U = 128+(B-Y)/1.772, V = 128+(R-Y)/1.402
    white == (254,128,128) after the video's encode/decode round trip.
All analysis uses a full sequential decode written to all.yuv (no -ss seeking, see root README 2.2).
"""
import os
import numpy as np

W_DIR = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.dirname(W_DIR)
YUV = os.path.join(W_DIR, 'all.yuv')
H, W = 720, 1280
FSIZE = W * H * 3          # yuv444p frame size
NFRAMES = 3442


def frame(n, buf=None, path=YUV):
    """Return (Y, U, V) uint8 planes for frame index n (0-based)."""
    off = n * FSIZE
    if buf is None:
        with open(path, 'rb') as f:
            f.seek(off)
            buf = f.read(FSIZE)
        if len(buf) != FSIZE:
            raise EOFError(n)
    y = np.frombuffer(buf[0:W * H], np.uint8).reshape(H, W)
    u = np.frombuffer(buf[W * H:W * H * 2], np.uint8).reshape(H, W)
    v = np.frombuffer(buf[W * H * 2:], np.uint8).reshape(H, W)
    return y, u, v


def yuv2rgb(y, u, v, full=True):
    """int16-safe conversion to float RGB 0..255."""
    Y = y.astype(np.float32)
    U = u.astype(np.float32) - 128.0
    V = v.astype(np.float32) - 128.0
    r = Y + 1.402 * V
    g = Y - 0.344136 * U - 0.714136 * V
    b = Y + 1.772 * U
    return np.dstack([r, g, b]).clip(0, 255)


def rgb2yuv(rgb):
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    Y = 0.299 * r + 0.587 * g + 0.114 * b
    U = 128.0 + (b - Y) / 1.772
    V = 128.0 + (r - Y) / 1.402
    return Y, U, V


def load_png_rgb(path):
    from PIL import Image
    im = Image.open(path)
    if im.mode != 'RGB':
        im = im.convert('RGB')
    return np.asarray(im, np.float32)
