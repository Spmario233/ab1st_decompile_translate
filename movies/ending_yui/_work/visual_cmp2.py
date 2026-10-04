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
mask = np.ones((H0, W0), bool)
mask[:, 80:370] = False
mask[:, 920:1240] = False
mask[:30, :] = False
mask[-30:, :] = False

rows = []
for t in (12, 20, 30, 36, 44, 48):
    F = to_rgb(np.fromfile(os.path.join(W, "fr", f"f{t:03d}.yuv"), np.uint8).reshape(3, H0, W0))
    best = None
    for k, ref in P.items():
        d = (ref - 255.0)[mask]
        a = float(((F - 255.0)[mask] * d).sum()) / float((d * d).sum())
        r = float(np.sqrt((((255.0 + a * d) - F[mask]) ** 2).mean()))
        if best is None or r < best[0]:
            best = (r, k, a)
    r, k, a = best
    pred = 255.0 + a * (P[k] - 255.0)
    print(f"t={t:>3}  plate={k[-4:]} alpha={a:6.3f}  rms={r:6.2f}")
    strip = np.concatenate([np.clip(F, 0, 255).astype(np.uint8)[160:560],
                            np.full((400, 10, 3), 0, np.uint8),
                            np.clip(pred, 0, 255).astype(np.uint8)[160:560]], axis=1)
    rows.append(strip)

# stack vertically for a compact contact sheet
sheet = np.concatenate([np.concatenate([s, np.full((400, s.shape[1], 3), 255, np.uint8)], 0) for s in rows], 0)
Image.fromarray(sheet).save(os.path.join(W, "cmp_bestplate.png"))
print("wrote cmp_bestplate.png  (left = original, right = best single plate render)")
