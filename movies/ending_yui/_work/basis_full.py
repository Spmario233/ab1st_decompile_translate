import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280


def to_rgb_full(a):
    Y = a[0].astype(np.float64); U = a[1].astype(np.float64) - 128.0; V = a[2].astype(np.float64) - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([Y + 2 * (1 - kr) * V,
                     Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                     Y + 2 * (1 - kb) * U], -1)


P = {k: np.asarray(Image.open(os.path.join(R, k + ".png")).convert("RGB"), np.float64)
     for k in ("evsp_1301", "evsp_1302", "evsp_1303", "evsp_1304")}
keys = sorted(P)

mask = np.ones((H0, W0), bool)
mask[:, 60:445] = False       # left subtitle block
mask[:, 975:1255] = False     # right subtitle block
mask[:20, :] = False
mask[-20:, :] = False
idx = mask.ravel()


def fl(img):
    return img.reshape(-1, 3)[idx].reshape(-1)


one = {k: fl(P[k] - 255.0) for k in keys}
bases = {
    "1": None,
    "2:C,S": np.stack([one["evsp_1301"], fl(P["evsp_1303"] - P["evsp_1301"])], 1),
    "2:P1,P3": np.stack([one["evsp_1301"], one["evsp_1303"]], 1),
    "3": np.stack([one["evsp_1301"], fl(P["evsp_1303"] - P["evsp_1301"]), one["evsp_1304"]], 1),
    "4": np.stack([one[k] for k in keys], 1),
}
print(f"{'t':>4} " + " ".join(f"{k:>18}" for k in bases) + "   best-plate / alpha")
for t in range(8, 62, 2):
    p = os.path.join(W, "fr", f"f{t:03d}.yuv")
    if not os.path.exists(p):
        continue
    F = to_rgb_full(np.fromfile(p, np.uint8).reshape(3, H0, W0))
    b = fl(F - 255.0)
    vals = []
    for name, A in bases.items():
        if A is None:
            v = min(float(np.sqrt((((b * d).sum() / (d * d).sum()) * d - b) ** 2).mean())) if False else None
            row = []
            for d in one.values():
                al = float((b * d).sum()) / float((d * d).sum())
                row.append(float(np.sqrt(((al * d - b) ** 2).mean())))
            vals.append(min(row))
            bp = int(np.argmin(row))
        else:
            x, *_ = np.linalg.lstsq(A, b, rcond=None)
            vals.append(float(np.sqrt(((A @ x - b) ** 2).mean())))
    d = one[keys[bp]]
    al = float((b * d).sum()) / float((d * d).sum())
    print(f"{t:>4} " + " ".join(f"{v:18.2f}" for v in vals) + f"   {keys[bp][-4:]} a={al:5.3f}")
