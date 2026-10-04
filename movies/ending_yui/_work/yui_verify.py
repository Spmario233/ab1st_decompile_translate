import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
OUT = r"E:\Projects\ab1st_decompile\video\ending_yui"
H0, W0 = 720, 1280
new = np.memmap(os.path.join(W, "yui_out.yuv"), np.uint8, mode="r", shape=(4440, 3, H0, W0))
orig = np.memmap(os.path.join(W, "raw_0_62.yuv"), np.uint8, mode="r", shape=(1859, 3, H0, W0))


def save(fr, path):
    Y = fr[0].astype(np.float64); U = fr[1].astype(np.float64) - 128.0; V = fr[2].astype(np.float64) - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    rgb = np.stack([Y + 2 * (1 - kr) * V,
                    Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                    Y + 2 * (1 - kb) * U], -1)
    Image.fromarray(np.clip(rgb, 0, 255).astype(np.uint8)).save(path)


print(" n     t     Ymin Ymax  Ymean   dark_px(Y<200)   vs original: rms  max")
for n in [0, 60, 150, 300, 600, 720, 900, 1080, 1320, 1500, 1740, 1830, 1858, 1860, 2000,
          3000, 4000, 4439]:
    fr = np.asarray(new[n], np.float64)
    dark = (fr[0] < 200).mean() * 100
    if n < 1859:
        o = np.asarray(orig[n], np.float64)
        d = np.abs(fr - o)
        ds = f"  {np.sqrt((d**2).mean()):6.2f} {d.max():6.1f}"
    else:
        r, g, b = fr[0], fr[1], fr[2]
        rgb = np.stack([r + 1.402 * (b - 128), r - 0.344 * (g - 128) - 0.714 * (b - 128),
                        r + 1.772 * (g - 128)], -1)
        ds = f"  rgb mean={rgb.mean():7.3f}"
    print(f"{n:5d} {n/30:7.2f} {fr[0].min():5.0f} {fr[0].max():5.0f} {fr[0].mean():7.2f}   {dark:7.3f}%{ds}")

for tag, n in [("y_chk_t006", 180), ("y_chk_t012", 360), ("y_chk_t022", 660),
               ("y_chk_t036", 1080), ("y_chk_t048", 1440), ("y_chk_t058", 1740),
               ("y_chk_t062", 1860), ("y_chk_t100", 3000), ("y_chk_t145", 4350)]:
    save(np.asarray(new[n]), os.path.join(W, tag + ".png"))
print("crops written")
