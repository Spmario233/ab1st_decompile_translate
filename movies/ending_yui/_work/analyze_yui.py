import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
SW, SH = 320, 180
FS = SW * SH * 3

raw = np.memmap(os.path.join(W, "yui_small.rgb"), dtype=np.uint8, mode="r")
N = raw.shape[0] // FS
print("small frames:", N)
small = raw[:N * FS].reshape(N, SH, SW, 3).astype(np.float64)

refs = {}
for f in sorted(os.listdir(R)):
    im = Image.open(os.path.join(R, f)).convert("RGB").resize((SW, SH), Image.LANCZOS)
    refs[os.path.splitext(f)[0]] = np.asarray(im, dtype=np.float64)

# text-free window (left/right subtitle columns excluded)
X0, X1, Y0, Y1 = 92, 228, 4, 178
sl = (slice(Y0, Y1), slice(X0, X1))
names = sorted(refs)

print(f"{'n':>5} {'t':>7}  {'nonwhite':>8} | best ref / alpha / rms   (all refs)")
for n in range(0, N, 15):
    F = small[n][sl]
    nw = np.abs(F - 255.0).mean()
    row = []
    best = None
    for k in names:
        ref = refs[k][sl]
        d = ref - 255.0
        den = float((d * d).sum())
        a = float(((F - 255.0) * d).sum()) / den if den else 0.0
        rms = float(np.sqrt((((255.0 + a * d) - F) ** 2).mean()))
        row.append(f"{k[-4:]}:a={a:5.3f},r={rms:6.2f}")
        if best is None or rms < best[0]:
            best = (rms, k, a)
    print(f"{n:5d} {n/30:7.2f}  {nw:8.2f} | {best[1][-4:]} a={best[2]:6.3f} rms={best[0]:6.2f} || " + "  ".join(row))
