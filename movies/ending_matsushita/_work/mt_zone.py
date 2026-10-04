import numpy as np, os
W = r"E:\Projects\ab1st_decompile\video\ending_matsushita\_work"
H0, W0 = 720, 1280
N = 7890
MM = np.memmap(os.path.join(W, "raw.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))

print("text extent for frames with credits (x limited to < 800 to exclude the inset)")
xmin, xmax, ymin, ymax = 9999, -1, 9999, -1
worst = []
for n in range(714, 6630, 3):
    y = np.asarray(MM[n, 0])
    sub = y[:, :800]
    m = sub < 246
    if not m.any():
        continue
    ys, xs = np.nonzero(m)
    xmin = min(xmin, xs.min()); xmax = max(xmax, xs.max())
    ymin = min(ymin, ys.min()); ymax = max(ymax, ys.max())
    if xs.max() > 700:
        worst.append((n, int(xs.max()), int(ys.min()), int(ys.max())))
print(f"overall text bbox (x<800 limit): x {xmin}..{xmax}   y {ymin}..{ymax}")
print("frames whose text reaches x>700 (first 25):")
for w in worst[:25]:
    print("   n=%5d t=%7.2f  xmax=%4d  y=%4d..%4d" % (w[0], w[0] / 30, w[1], w[2], w[3]))
print("total such frames:", len(worst))

print("\nsunflower inset left edge over time (x of first non-white for x>=790):")
for n in range(360, 6630, 300):
    y = np.asarray(MM[n, 0])
    sub = y[:, 790:]
    m = sub < 246
    if m.any():
        xs = np.nonzero(m)[1]
        print(f"   n={n:5d} t={n/30:7.2f}  inset x0={790+int(xs.min())}")
