import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
H0, W0, N = 720, 1280, 39
MM = np.memmap(os.path.join(W, "all.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))
NN = np.memmap(os.path.join(W, "new_all.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))


def yuv2rgb(a):
    Y, U, V = a[0], a[1] - 128.0, a[2] - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([Y + 2 * (1 - kr) * V,
                     Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                     Y + 2 * (1 - kb) * U], -1)


BOX = (slice(275, 405), slice(715, 1195))
print("frame   original ink px   new ink px   original dark px   new dark px")
for i in range(N):
    a = np.clip(yuv2rgb(np.asarray(MM[i], np.float64)), 0, 255)[BOX]
    b = np.clip(yuv2rgb(np.asarray(NN[i], np.float64)), 0, 255)[BOX]
    ia = int((255 - a.min(axis=2) > 30).sum())
    ib = int((255 - b.min(axis=2) > 30).sum())
    da = int((a.max(axis=2) < 110).sum())
    db = int((b.max(axis=2) < 110).sum())
    print(f"  {i+1:2d}   {ia:12d}   {ib:10d}   {da:15d}   {db:11d}")

print("\noutside the box, original vs new (must be identical):")
outs = 0
for i in range(N):
    m = np.ones((H0, W0), bool); m[BOX] = False
    d = np.abs(MM[i].astype(np.int16) - NN[i].astype(np.int16))
    outs = max(outs, int(d[:, m].max()))
print("  max abs difference outside the box:", outs)
