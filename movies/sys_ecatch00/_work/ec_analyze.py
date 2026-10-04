import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
H0, W0 = 720, 1280

frames = []
for i in range(1, 40):
    im = Image.open(os.path.join(W, f"all_{i:03d}.png")).convert("RGB")
    frames.append(np.asarray(im, dtype=np.int16))

pts = [0.0] + [0.366667 + 0.033333 * k for k in range(25)]
print("right/bottom of non-white content per stored frame:")
print(f"{'#':>3} {'t':>7}   bbox x0..x1  y0..y1     nonwhite  minRGB")
for i, a in enumerate(frames):
    d = 255 - a.min(axis=2)              # distance from white
    m = d > 6
    if m.any():
        ys, xs = np.nonzero(m)
        bb = f"{xs.min():4d}..{xs.max():4d} {ys.min():4d}..{ys.max():4d}"
    else:
        bb = "     (blank)       "
    t = pts[i] if i < len(pts) else float("nan")
    print(f"{i+1:>3} {t:7.3f}   {bb}   {m.mean()*100:7.3f}%  {a.min():3d}")

# colour / range of the source
blank = frames[0]
print("\nblank frame RGB:", blank.reshape(-1, 3).mean(axis=0))
logo = frames[26]
print("held logo frame RGB min/max:", logo.reshape(-1, 3).min(axis=0), logo.reshape(-1, 3).max(axis=0))
d = 255 - logo.min(axis=2)
m = d > 6
ys, xs = np.nonzero(m)
print(f"held logo bbox: x {xs.min()}..{xs.max()}  y {ys.min()}..{ys.max()}  "
      f"({xs.max()-xs.min()+1} x {ys.max()-ys.min()+1})")
