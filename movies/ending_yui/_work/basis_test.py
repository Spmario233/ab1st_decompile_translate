import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280


def to_rgb(a):
    Y = a[0].astype(np.float64); U = a[1].astype(np.float64) - 128.0; V = a[2].astype(np.float64) - 128.0
    y = (Y - 16.0) * 255.0 / 219.0
    u, v = U * 255.0 / 224.0, V * 255.0 / 224.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([y + 2 * (1 - kr) * v,
                     y - (2 * (1 - kr) * kr / kg) * v - (2 * (1 - kb) * kb / kg) * u,
                     y + 2 * (1 - kb) * u], -1)


P = {k: np.asarray(Image.open(os.path.join(R, k + ".png")).convert("RGB"), np.float64)
     for k in ("evsp_1301", "evsp_1302", "evsp_1303", "evsp_1304")}

# centre only (definitely text free)
sel = np.zeros((H0, W0), bool)
sel[20:700, 450:975] = True
idx = sel.ravel()


def flat(img):
    return img.reshape(-1, 3)[idx].reshape(-1)


one = {k: flat(P[k] - 255.0) for k in P}
bases = {
    "1:D": None,
    "2:C,S": np.stack([flat(P["evsp_1301"] - 255.0),
                       flat(P["evsp_1303"] - P["evsp_1301"])], 1),
    "2:P1,P3": np.stack([flat(P["evsp_1301"] - 255.0),
                         flat(P["evsp_1303"] - 255.0)], 1),
    "3:C,S,P4": np.stack([flat(P["evsp_1301"] - 255.0),
                          flat(P["evsp_1303"] - P["evsp_1301"]),
                          flat(P["evsp_1304"] - P["evsp_1301"])], 1),
    "4:all": np.stack([flat(P[k] - 255.0) for k in sorted(P)], 1),
}
print(f"{'t':>4} " + " ".join(f"{k:>22}" for k in bases))
for t in (10, 14, 18, 22, 26, 30, 34, 38, 42, 46, 50, 54, 58):
    p = os.path.join(W, "fr", f"f{t:03d}.yuv")
    if not os.path.exists(p):
        continue
    F = to_rgb(np.fromfile(p, np.uint8).reshape(3, H0, W0))
    b = flat(F - 255.0)
    out = []
    for name, A in bases.items():
        if A is None:
            r = min(float(np.sqrt((((b * d).sum() / (d * d).sum()) * d - b) ** 2).mean())
                    for d in one.values())
        else:
            x, *_ = np.linalg.lstsq(A, b, rcond=None)
            pred = A @ x
            r = float(np.sqrt(((pred - b) ** 2).mean()))
        out.append(r)
    print(f"{t:>4} " + " ".join(f"{v:22.2f}" for v in out))
print("\ncolumns:", list(bases))
