import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
H0, W0 = 720, 1280
MM = np.memmap(os.path.join(W, "all.yuv"), np.uint8, mode="r", shape=(39, 3, H0, W0))


def yuv2rgb(a):
    Y, U, V = a[0], a[1] - 128.0, a[2] - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([Y + 2 * (1 - kr) * V,
                     Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                     Y + 2 * (1 - kb) * U], -1)


BOX = (slice(280, 405), slice(730, 1185))
print("dark pixels (shadow) and red pixels inside the logo box, per stored frame")
print(f"{'#':>3} {'t':>7}  {'dark px':>8} {'red px':>8}  {'meanR':>7} {'meanG':>7} {'meanB':>7}")
for i in range(39):
    rgb = np.clip(yuv2rgb(np.asarray(MM[i], np.float64)), 0, 255)[BOX]
    mx = rgb.max(axis=2)
    dark = int((mx < 110).sum())
    red = int(((rgb[..., 0] > 150) & (rgb[..., 1] < 120)).sum())
    t = 0.0 if i == 0 else (0.366667 + 0.033333 * i if i <= 26 else 0)
    print(f"{i+1:>3} {t:7.3f}  {dark:8d} {red:8d}  {rgb[...,0].mean():7.2f} "
          f"{rgb[...,1].mean():7.2f} {rgb[...,2].mean():7.2f}")

# where is the shadow relative to the logo?  correlate dark mask with the silhouette
rgb = np.clip(yuv2rgb(np.asarray(MM[26], np.float64)), 0, 255)
box = rgb[BOX]
dark = box.max(axis=2) < 110
print("\nshadow(dark) bbox inside the box:")
if dark.any():
    ys, xs = np.nonzero(dark)
    print("   x", xs.min() + 730, "..", xs.max() + 730, " y", ys.min() + 280, "..", ys.max() + 280)
sil = (255 - box.min(axis=2)) > 40
print("silhouette bbox inside the box:")
ys, xs = np.nonzero(sil)
print("   x", xs.min() + 730, "..", xs.max() + 730, " y", ys.min() + 280, "..", ys.max() + 280)
