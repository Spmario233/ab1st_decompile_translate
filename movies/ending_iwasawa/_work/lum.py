import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
profs = np.load(os.path.join(W, "band_profiles.npy"))   # (2190, 1440)
# band0 = x 0..400 (400 cols), band1 = x 880..1280 (400 cols)
lum = np.concatenate([profs[:, :720].mean(axis=1, keepdims=True),
                      profs[:, 720:].mean(axis=1, keepdims=True)], axis=1)
mean_lum = lum.mean(axis=1)
np.save(os.path.join(W, "mean_lum.npy"), mean_lum)

print("t(s)  mean_lum(bands)   [per-frame diff]")
for n in range(0, 2190):
    t = n / 30.0
    if 58.0 <= t <= 73.0:
        if n % 3 == 0:
            print(f"{t:6.2f}  {mean_lum[n]:8.3f}")
