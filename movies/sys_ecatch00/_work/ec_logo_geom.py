import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
PNG = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\logo_chinese_small.png"

final = np.asarray(Image.open(os.path.join(W, "all_026.png")).convert("RGB"), np.float64)
ink = 255.0 - final
m = ink.max(axis=2) > 6
ys, xs = np.nonzero(m)
print(f"video logo (Japanese) ink bbox: x {xs.min()}..{xs.max()}  y {ys.min()}..{ys.max()}  "
      f"= {xs.max()-xs.min()+1} x {ys.max()-ys.min()+1}")

rgba = np.asarray(Image.open(PNG).convert("RGBA"), np.float64)
a = rgba[..., 3]
m = a > 6
ys2, xs2 = np.nonzero(m)
print(f"chinese PNG alpha bbox: x {xs2.min()}..{xs2.max()}  y {ys2.min()}..{ys2.max()}  "
      f"= {xs2.max()-xs2.min()+1} x {ys2.max()-ys2.min()+1}   (canvas {rgba.shape[1]}x{rgba.shape[0]})")

# horizontal ink profile of both, to locate the wordmark vs the small sub-text line
def prof(img_ink, name):
    p = img_ink.max(axis=2)
    rows = p.mean(axis=1)
    print(f"\n{name}: row-mean ink profile (per 4 rows)")
    for i in range(0, len(rows), 4):
        bar = "#" * int(rows[i] / 255 * 60)
        print(f"   y={i:4d} {rows[i]:7.2f} {bar}")


prof(ink, "video logo")
ci = a[..., None] / 255.0 * 255.0
prof(np.repeat(ci, 3, axis=2), "chinese logo (alpha as ink)")
