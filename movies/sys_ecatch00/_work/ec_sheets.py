import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
CROP = (735, 280, 1175, 400)


def load(i):
    return Image.open(os.path.join(W, f"all_{i:03d}.png")).convert("RGB").crop(CROP)


def sheet(idxs, cols, path, sep=4):
    ims = [np.asarray(load(i), np.uint8) for i in idxs]
    h, w, _ = ims[0].shape
    rows = []
    for r in range(0, len(ims), cols):
        grp = ims[r:r + cols]
        while len(grp) < cols:
            grp.append(np.full((h, w, 3), 180, np.uint8))
        rows.append(np.concatenate(
            [np.concatenate([g, np.full((h, sep, 3), 0, np.uint8)], 1) for g in grp], 1))
    out = np.concatenate([np.concatenate([r, np.full((sep, r.shape[1], 3), 0, np.uint8)], 0)
                          for r in rows], 0)
    Image.fromarray(out).save(os.path.join(W, path))
    print(path, out.shape)


sheet(list(range(2, 15)), 4, "logo_sheet_a.png")
sheet(list(range(15, 28)), 4, "logo_sheet_b.png")

final = np.asarray(load(27), np.float64)
print("\nper-frame ink inside the logo box (mean of 255-min(RGB)):")
for i in range(2, 40):
    a = np.asarray(load(i), np.float64)
    print(f"  frame {i:2d}  ink={np.abs(255-a).mean():7.3f}  "
          f"rms vs final={np.sqrt(((a-final)**2).mean()):7.3f}")
