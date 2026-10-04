import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280


def yuv2rgb(a):
    Y = a[0].astype(np.float64); U = a[1].astype(np.float64) - 128.0; V = a[2].astype(np.float64) - 128.0
    y = (Y - 16.0) * 255.0 / 219.0
    u, v = U * 255.0 / 224.0, V * 255.0 / 224.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    r = y + 2 * (1 - kr) * v
    b = y + 2 * (1 - kb) * u
    g = y - (2 * (1 - kr) * kr / kg) * v - (2 * (1 - kb) * kb / kg) * u
    return np.clip(np.stack([r, g, b], -1), 0, 255)


def load(t):
    a = np.fromfile(os.path.join(W, "fr", f"f{t:03d}.yuv"), dtype=np.uint8).reshape(3, H0, W0)
    return yuv2rgb(a)


ref = np.asarray(Image.open(os.path.join(R, "evsp_1303.png")).convert("RGB"), dtype=np.float64)
F = load(36)

regions = {
    "centre  x400-900": (slice(10, 710), slice(400, 900)),
    "left col x90-350": (slice(10, 710), slice(90, 350)),
    "right col x940-1220": (slice(10, 710), slice(940, 1220)),
    "top-left white": (slice(0, 40), slice(0, 300)),
    "bottom-left white": (slice(680, 720), slice(0, 300)),
    "top-right white": (slice(0, 40), slice(1000, 1280)),
}
print("frame is from t=36 s (illustration near full opacity, evsp_1303)")
for nm, sl in regions.items():
    d = ref[sl] - 255.0
    a = float(((F[sl] - 255.0) * d).sum()) / float((d * d).sum()) if (d * d).sum() else 0
    pred = 255.0 + a * d
    res = pred - F[sl]
    print(f"  {nm:22s} frame mean={F[sl].mean():7.2f}  ref mean={ref[sl].mean():7.2f}  "
          f"a={a:6.3f}  resid mean={res.mean():7.2f} rms={np.sqrt((res**2).mean()):6.2f}")

print()
print("per-channel affine fit  F_c = A_c * ref_c + B_c   over the centre region:")
sl = regions["centre  x400-900"]
for c, nm in enumerate("RGB"):
    x = ref[sl][..., c].ravel(); yv = F[sl][..., c].ravel()
    A = np.stack([x, np.ones_like(x)], 1)
    coef, *_ = np.linalg.lstsq(A, yv, rcond=None)
    res = A @ coef - yv
    print(f"   {nm}: A={coef[0]:.4f} B={coef[1]:8.3f}   resid rms={np.sqrt((res**2).mean()):6.2f}")

print()
print("global alpha fit over the whole frame (text columns excluded):")
mask = np.ones((H0, W0), bool)
mask[:, 80:360] = False
mask[:, 930:1230] = False
d = (ref - 255.0)[mask]
a = float(((F - 255.0)[mask] * d).sum()) / float((d * d).sum())
res = (255.0 + a * d) - (F[mask])
print(f"   a={a:.4f}  resid mean={res.mean():7.3f} rms={np.sqrt((res**2).mean()):6.2f}")

print()
print("residual vs local reference gradient (is the error edge-concentrated?):")
gy, gx = np.gradient(ref[..., 1])
gmag = np.sqrt(gy ** 2 + gx ** 2)[sl]
rr = np.abs(res.reshape(H0 - 20, 500, 3)).mean(-1) if res.ndim == 3 else None
res3 = np.abs((255.0 + a * (ref - 255.0)) - F)[sl].mean(-1)
q = np.percentile(gmag, [50, 90, 99])
for lo, hi in ((0, q[0]), (q[0], q[1]), (q[1], q[2]), (q[2], 1e9)):
    m = (gmag >= lo) & (gmag < hi)
    if m.sum():
        print(f"   gradient {lo:7.2f}..{hi:7.2f} : {m.mean()*100:5.1f}% of px, residual mean={res3[m].mean():7.2f}")
