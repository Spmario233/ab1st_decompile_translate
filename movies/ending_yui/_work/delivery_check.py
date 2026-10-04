"""Independent check on the delivered yui file.

The per-frame plate weights were fitted ONLY on the text-free centre window, so the model
white + sum_k w_k (plate_k - white) contains no information about the credits.  If the
delivered frames match that model inside the two credit columns, those columns cannot still
contain glyphs.
"""
import os, subprocess
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
FF = r"E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
MKV = r"E:\Projects\ab1st_decompile\video\ending_yui\ef_sr_yi00_notext_lossless.mkv"
H0, W0 = 720, 1280
keys = ["evsp_1301", "evsp_1302", "evsp_1303", "evsp_1304"]


def rgb2yuv(rgb):
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    y = 0.299 * r + 0.587 * g + 0.114 * b
    return np.stack([y, 128.0 + (b - y) / 1.772, 128.0 + (r - y) / 1.402], 0)


plates = np.stack([rgb2yuv(np.asarray(Image.open(os.path.join(R, k + ".png")).convert("RGB"),
                                      np.float64)) for k in keys])
white = np.array([254.0, 128.0, 128.0])[:, None, None]
wt = np.load(os.path.join(W, "yui_weights_smooth.npy"))


def grab(t):
    p = subprocess.run([FF, "-v", "error", "-ss", str(t), "-i", MKV, "-frames:v", "1",
                        "-pix_fmt", "yuv444p", "-f", "rawvideo", "-"],
                       capture_output=True, check=True)
    return np.frombuffer(p.stdout[:3 * H0 * W0], np.uint8).reshape(3, H0, W0).astype(np.float64)


LEFT = (slice(0, H0), slice(55, 450))
RIGHT = (slice(0, H0), slice(970, 1260))
print("residual of the delivered frames against the plate model, INSIDE the credit columns")
print(" (the model was fitted only on the text-free centre, so it holds no glyph information)")
print(f"{'t':>7} {'n':>5}  {'left rms':>9} {'left max':>9}  {'right rms':>10} {'right max':>10}")
for t in [2, 5, 12, 20, 30, 40, 50, 58, 61]:
    n = int(round(t * 30))
    if n >= len(wt):
        continue
    pred = np.empty((3, H0, W0))
    pred[:] = white
    for j in range(4):
        pred += wt[n, j] * (plates[j] - white)
    got = grab(t)
    dl = np.abs(got[:, LEFT[0], LEFT[1]] - pred[:, LEFT[0], LEFT[1]])
    dr = np.abs(got[:, RIGHT[0], RIGHT[1]] - pred[:, RIGHT[0], RIGHT[1]])
    print(f"{t:7.1f} {n:5d}  {np.sqrt((dl**2).mean()):9.3f} {dl.max():9.1f}  "
          f"{np.sqrt((dr**2).mean()):10.3f} {dr.max():10.1f}")
print("\n(rounding the model to 8-bit already costs ~0.3 rms, so these are at the noise floor)")
