import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
OUT = r"E:\Projects\ab1st_decompile\video\ending_iwasawa"
H0, W0 = 720, 1280
FS = H0 * W0 * 3
orig = np.memmap(os.path.join(W, "raw_0_73.yuv"), dtype=np.uint8, mode="r",
                 shape=(2190, 3, H0, W0))
new = np.memmap(os.path.join(W, "out_full.yuv"), dtype=np.uint8, mode="r",
                shape=(7830, 3, H0, W0))


def toyuv(fr):
    return np.ascontiguousarray(fr).tobytes()


def save_png(fr, path, scale=1):
    Y = fr[0].astype(np.float64)
    U = fr[1].astype(np.float64) - 128.0
    V = fr[2].astype(np.float64) - 128.0
    # limited-range BT.601, matching how the source decodes
    y = (Y - 16.0) * 255.0 / 219.0
    u, v = U * 255.0 / 224.0, V * 255.0 / 224.0
    kr, kb = 0.299, 0.114
    kg = 1 - kr - kb
    r = y + 2 * (1 - kr) * v
    b = y + 2 * (1 - kb) * u
    g = y - (2 * (1 - kr) * kr / kg) * v - (2 * (1 - kb) * kb / kg) * u
    rgb = np.clip(np.stack([r, g, b]), 0, 255).transpose(1, 2, 0).astype(np.uint8)
    im = Image.fromarray(rgb)
    if scale != 1:
        im = im.resize((W0 // scale, H0 // scale), Image.LANCZOS)
    im.save(path)


print(" n      t     vs original:  RMS   max|d|   max Y  mean Y   text px(Y>150)")
for n in [0, 300, 600, 700, 732, 733, 750, 900, 1200, 1500, 1800, 2050, 2060, 2085, 2100,
          2130, 2145, 2160, 2163, 2200, 3000, 7500, 7829]:
    fr = np.asarray(new[n], dtype=np.float32)
    if n < 2190:
        o = np.asarray(orig[n], dtype=np.float32)
        d = np.abs(fr - o)
        ds = f"  RMS={np.sqrt((d**2).mean()):6.2f}  max={d.max():6.1f}"
    else:
        ds = " " * 24
    print(f"{n:5d} {n/30:7.2f}{ds}   {fr[0].max():6.0f} {fr[0].mean():7.3f}   {(fr[0]>150).mean()*100:6.3f}%")

for tag, n in [("chk_t020", 600), ("chk_t025", 750), ("chk_t040", 1200), ("chk_t060", 1800),
               ("chk_t069", 2070), ("chk_t070", 2100), ("chk_t071", 2130), ("chk_t072", 2163),
               ("chk_t100", 3000), ("chk_t250", 7500)]:
    save_png(np.asarray(new[n]), os.path.join(W, tag + ".png"))
print("crops written")
