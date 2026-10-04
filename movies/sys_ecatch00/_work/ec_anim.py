import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
CROP = (620, 250, 1280, 420)          # x0,y0,x1,y1 around the logo


def load(i):
    return Image.open(os.path.join(W, f"all_{i:03d}.png")).convert("RGB").crop(CROP)


rows = []
for i in list(range(13, 28)):
    im = load(i)
    rows.append(np.asarray(im, dtype=np.uint8))

Wc, Hc = rows[0].shape[1], rows[0].shape[0]
tiles = []
for r in range(0, len(rows), 3):
    grp = rows[r:r + 3]
    while len(grp) < 3:
        grp.append(np.full((Hc, Wc, 3), 200, np.uint8))
    tiles.append(np.concatenate(grp, axis=1))
sheet = np.concatenate([np.concatenate([t, np.full((6, t.shape[1], 3), 0, np.uint8)], 0)
                        for t in tiles], 0)
Image.fromarray(sheet).save(os.path.join(W, "anim_sheet.png"))
print("wrote anim_sheet.png", sheet.shape, " frames 13..27 of", CROP)

# how the logo region differs from the final logo, per animation frame
final = np.asarray(Image.open(os.path.join(W, "all_027.png")).convert("RGB").crop(CROP), np.float64)
print("\nframes 14..27 : rms difference of the logo crop vs the final held logo")
for i in range(14, 28):
    a = np.asarray(load(i), np.float64)
    print(f"  frame {i:2d}  rms={np.sqrt(((a-final)**2).mean()):7.3f}  "
          f"meanink(final-region)={np.abs(255-a).mean():7.3f}")
