import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280

refs = {}
for f in sorted(os.listdir(R)):
    refs[os.path.splitext(f)[0]] = np.asarray(
        Image.open(os.path.join(R, f)).convert("RGB"), dtype=np.float64)

# subtitle columns: left ~x 90..350, right ~x 940..1220  -> use the middle band
XL, XR, Y0, Y1 = 400, 900, 10, 710
sl = (slice(Y0, Y1), slice(XL, XR))


def load(t):
    a = np.fromfile(os.path.join(W, "fr", f"f{t:03d}.yuv"), dtype=np.uint8).reshape(3, H0, W0)
    Y = a[0].astype(np.float64); U = a[1].astype(np.float64) - 128.0; V = a[2].astype(np.float64) - 128.0
    y = (Y - 16.0) * 255.0 / 219.0
    u, v = U * 255.0 / 224.0, V * 255.0 / 224.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    r = y + 2 * (1 - kr) * v
    b = y + 2 * (1 - kb) * u
    g = y - (2 * (1 - kr) * kr / kg) * v - (2 * (1 - kb) * kb / kg) * u
    return np.clip(np.stack([r, g, b], -1), 0, 255)


def fit1(F, ref):
    d = ref - 255.0
    den = float((d * d).sum())
    a = float(((F - 255.0) * d).sum()) / den if den else 0.0
    return a, float(np.sqrt((((255.0 + a * d) - F) ** 2).mean()))


def fit2(F, P1, P3):
    A = np.stack([P1 - 255.0, P3 - P1], -1).reshape(-1, 2)
    bb = (F - 255.0).reshape(-1)
    x, *_ = np.linalg.lstsq(A, bb, rcond=None)
    pred = (255.0 + A @ x).reshape(F.shape)
    return x, float(np.sqrt(((pred - F) ** 2).mean()))


P1 = refs["evsp_1301"][sl]
P2 = refs["evsp_1302"][sl]
P3 = refs["evsp_1303"][sl]
P4 = refs["evsp_1304"][sl]

print(f"{'t':>4} | best single-plate fit                 | two-layer fit u*1301 + v*(1303-1301)")
for t in [10, 12, 15, 18, 20, 22, 25, 28, 30, 33, 36, 40, 44, 48, 52, 56, 59, 61, 63, 66, 70]:
    F = load(t)[sl]
    rows = []
    best = None
    for nm, P in (("1301", P1), ("1302", P2), ("1303", P3), ("1304", P4)):
        a, r = fit1(F, P)
        rows.append(f"{nm}:a={a:5.3f} r={r:5.2f}")
        if best is None or r < best[0]:
            best = (r, nm)
    x, r2 = fit2(F, P1, P3)
    print(f"{t:>4} | " + "  ".join(rows) + f"  -> {best[1]}  || u={x[0]:6.3f} v={x[1]:6.3f} rms={r2:5.2f}")
