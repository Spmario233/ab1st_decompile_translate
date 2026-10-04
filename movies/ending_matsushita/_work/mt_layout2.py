import numpy as np, os

W = r"E:\Projects\ab1st_decompile\video\ending_matsushita\_work"
SW, SH = 320, 180
FS = SW * SH * 3
raw = np.memmap(os.path.join(W, "mt_small.rgb"), np.uint8, mode="r")
N = raw.shape[0] // FS
A = raw[:N * FS].reshape(N, SH, SW, 3)
g = A.mean(axis=3)
nw = g < 246

XS = 4          # small->full scale
print(" n      t     Lbbox(x,y)            Rbbox(x,y)            L%     R%    LeftWhiteMean")
for n in list(range(0, 7890, 150)) + list(range(660, 760, 10)) + list(range(6540, 7500, 60)):
    if n >= N:
        continue
    ml = nw[n][:, :SW // 2]
    mr = nw[n][:, SW // 2:]

    def bb(m, xoff):
        if not m.any():
            return "  none          "
        ys, xs = np.nonzero(m)
        return f"{xs.min()*XS+xoff:4d},{ys.min()*XS:3d}..{xs.max()*XS+xoff:4d},{ys.max()*XS:3d}"
    lb = bb(ml, 0); rb = bb(mr, SW // 2 * XS)
    whitel = A[n][:, :SW // 2].reshape(-1, 3)
    wm = whitel[~ml.reshape(-1)].mean(axis=0) if (~ml.reshape(-1)).any() else [0, 0, 0]
    print(f"{n:5d} {n/30:7.2f}  {lb}   {rb}   {ml.mean()*100:5.2f} {mr.mean()*100:5.2f}   "
          f"{np.round(wm,1)}")
