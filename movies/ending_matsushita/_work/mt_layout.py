import numpy as np, os

W = r"E:\Projects\ab1st_decompile\video\ending_matsushita\_work"
SW, SH = 320, 180
FS = SW * SH * 3
raw = np.memmap(os.path.join(W, "mt_small.rgb"), np.uint8, mode="r")
N = raw.shape[0] // FS
A = raw[:N * FS].reshape(N, SH, SW, 3)

g = A.mean(axis=3)                      # 0..255 luminance-ish
nonwhite = g < 246                      # anything not near-white

print(f"frames: {N}")
print(" n      t    nonwhite%  bbox x0..x1  y0..y1   (scaled to 1280x720)   right-half%  left-half%")
for n in range(0, N, 30):
    m = nonwhite[n]
    frac = m.mean() * 100
    if m.any():
        ys, xs = np.nonzero(m)
        x0, x1, y0, y1 = xs.min() * 4, xs.max() * 4, ys.min() * 4, ys.max() * 4
    else:
        x0 = x1 = y0 = y1 = -1
    left = nonwhite[n][:, :SW // 2].mean() * 100
    right = nonwhite[n][:, SW // 2:].mean() * 100
    print(f"{n:5d} {n/30:7.2f}  {frac:8.3f}   {x0:4d}..{x1:4d}  {y0:4d}..{y1:4d}   {right:9.3f}  {left:9.3f}")
