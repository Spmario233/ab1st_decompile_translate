import subprocess, os
import numpy as np
from PIL import Image

FF = r"E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
SRC = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\ef_sr_iw00.ogv"
W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
png = os.path.join(W, "cs.png")
yuv = os.path.join(W, "cs.yuv")
subprocess.run([FF, "-v", "error", "-y", "-ss", "0", "-i", SRC, "-frames:v", "1", png], check=True)
subprocess.run([FF, "-v", "error", "-y", "-ss", "0", "-i", SRC, "-frames:v", "1",
                "-pix_fmt", "yuv444p", "-f", "rawvideo", yuv], check=True)

rgb = np.asarray(Image.open(png).convert("RGB"), dtype=np.float64)
raw = np.fromfile(yuv, dtype=np.uint8).reshape(3, 720, 1280).astype(np.float64)
Y, U, V = raw[0], raw[1] - 128.0, raw[2] - 128.0


def conv(kind, rng):
    if rng == "full":
        y = Y
    else:
        y = (Y - 16.0) * 255.0 / 219.0
    if kind == "bt601":
        kr, kb = 0.299, 0.114
    else:
        kr, kb = 0.2126, 0.0722
    kg = 1 - kr - kb
    if rng == "full":
        u, v = U, V
    else:
        u, v = U * 255.0 / 224.0, V * 255.0 / 224.0
    r = y + 2 * (1 - kr) * v
    b = y + 2 * (1 - kb) * u
    g = y - (2 * (1 - kr) * kr / kg) * v - (2 * (1 - kb) * kb / kg) * u
    return np.clip(np.stack([r, g, b]), 0, 255).transpose(1, 2, 0)


for kind in ("bt601", "bt709"):
    for rng in ("full", "limited"):
        c = conv(kind, rng)
        err = np.abs(c - rgb).mean()
        print(f"{kind:6s} {rng:8s} mean|err|={err:7.3f}  max={np.abs(c-rgb).max():7.2f}")

print("\nsample pixel rgb[360,640] =", rgb[360, 640], " YUV =", raw[:, 360, 640])
