import os
import numpy as np
from PIL import Image

FR = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work\frames"

def rowprof(t):
    n = int(round(t * 30)) + 1
    a = np.asarray(Image.open(os.path.join(FR, f"f{n:05d}.png")).convert("L"), dtype=np.float32)
    # text-free columns only
    band = np.concatenate([a[:, 0:400], a[:, 880:1280]], axis=1)
    return band.mean(axis=1)

print("row-mean luminance per 60-row block (text-free bands)")
print("t(s)  " + "".join(f"{b*60:>7}" for b in range(12)))
for t in [64, 66, 67, 68, 68.5, 68.8, 69.0, 69.3, 69.6, 70.0, 70.4, 70.8, 71.2, 71.6, 72.0]:
    p = rowprof(t)
    blocks = [p[b * 60:(b + 1) * 60].mean() for b in range(12)]
    print(f"{t:5.1f} " + "".join(f"{v:7.2f}" for v in blocks))

# chroma check: is U/V pulled toward 128 proportionally?
print()
print("chroma check on a bright cloud pixel region across the fade")
for t in [67.0, 68.5, 69.0, 69.5, 70.0, 70.5, 71.0]:
    n = int(round(t * 30)) + 1
    im = Image.open(os.path.join(FR, f"f{n:05d}.png")).convert("RGB")
    a = np.asarray(im, dtype=np.float32)
    reg = a[400:520, 0:200]          # cloud area
    print(f"t={t:5.1f}  RGB mean = {reg.reshape(-1,3).mean(axis=0)}")
