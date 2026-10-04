import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
BX0, BX1, BY0, BY1 = 746, 1163, 292, 390


def load(i):
    return np.asarray(Image.open(os.path.join(W, f"all_{i:03d}.png")).convert("RGB"),
                      np.float64)[BY0:BY1, BX0:BX1]


final = load(26)
ink_f = 255.0 - final                      # (h,w,3)
den = (ink_f ** 2).sum()
print("global alpha and per-column alpha profile of the logo layer")
print(f"{'#':>3}  {'global a':>8}  {'rms resid':>9}   per-column alpha (every 8th of 32 cols)")
for i in range(5, 30):
    a = load(i)
    ink = 255.0 - a
    al = float((ink * ink_f).sum() / den)
    resid = float(np.sqrt(((al * ink_f - ink) ** 2).mean()))
    # column-wise alpha (luma ink)
    col_f = ink_f.mean(axis=2)
    col_i = ink.mean(axis=2)
    num = (col_i * col_f).sum(axis=0)
    d = (col_f ** 2).sum(axis=0)
    prof = np.where(d > 50, num / np.maximum(d, 1e-9), np.nan)
    step = max(1, len(prof) // 16)
    s = " ".join("  .  " if not np.isfinite(v) else f"{v:5.2f}" for v in prof[::step])
    print(f"{i:>3}  {al:8.3f}  {resid:9.2f}   {s}")
