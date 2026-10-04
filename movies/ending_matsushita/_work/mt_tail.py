import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_matsushita\_work"
H0, W0 = 720, 1280
N = 7890
MM = np.memmap(os.path.join(W, "raw.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))


def yuv2rgb(a):
    Y = a[0].astype(np.float64); U = a[1].astype(np.float64) - 128.0; V = a[2].astype(np.float64) - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([Y + 2 * (1 - kr) * V,
                     Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                     Y + 2 * (1 - kb) * U], -1)


print(" n      t     Ymin Ymax Ymean   Umean  Vmean   nonwhite_px(Y<246)")
for n in [7420, 7425, 7430, 7431, 7440, 7500, 7700, 7820, 7829, 7830, 7831, 7832, 7833,
          7840, 7850, 7860, 7870, 7880, 7885, 7889]:
    fr = np.asarray(MM[n], np.float64)
    nw = int((fr[0] < 246).sum())
    print(f"{n:5d} {n/30:7.2f} {fr[0].min():5.0f} {fr[0].max():5.0f} {fr[0].mean():7.2f}  "
          f"{fr[1].mean():7.3f} {fr[2].mean():7.3f}   {nw:8d}")

for n in (7833, 7850, 7880, 7889):
    Image.fromarray(np.clip(yuv2rgb(np.asarray(MM[n])), 0, 255).astype(np.uint8)).save(
        os.path.join(W, f"tail_{n}.png"))
print("tail crops written")
