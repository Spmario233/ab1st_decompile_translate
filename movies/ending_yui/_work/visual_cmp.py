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


def to_yuv(rgb):
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    y = 0.299 * r + 0.587 * g + 0.114 * b
    u = (b - y) / 1.772
    v = (r - y) / 1.402
    Y = y * 219.0 / 255.0 + 16.0
    U = 128.0 + u * 224.0 / 255.0
    V = 128.0 + v * 224.0 / 255.0
    return np.stack([Y, U, V])


P1 = np.asarray(Image.open(os.path.join(R, "evsp_1301.png")).convert("RGB"), np.float64)
P3 = np.asarray(Image.open(os.path.join(R, "evsp_1303.png")).convert("RGB"), np.float64)
C = P1 - 255.0
S = P3 - P1

sel = np.zeros((H0, W0), bool)
sel[10:710, 400:900] = True
sel[:, 80:360] = False
sel[:, 930:1230] = False
basis = np.stack([C[sel].reshape(-1), S[sel].reshape(-1)], 1)

for t in (12, 20, 30, 44, 55):
    F = to_rgb(np.fromfile(os.path.join(W, "fr", f"f{t:03d}.yuv"), np.uint8).reshape(3, H0, W0))
    b = (F[sel] - 255.0).reshape(-1)
    gh, *_ = np.linalg.lstsq(basis, b, rcond=None)
    pred = 255.0 + gh[0] * C + gh[1] * S
    rms = float(np.sqrt(((pred[sel] - F[sel]) ** 2).mean()))
    print(f"t={t:>3}  g={gh[0]:6.3f} h={gh[1]:6.3f}  rms(centre)={rms:6.2f}")
    strip = np.concatenate([np.clip(F, 0, 255).astype(np.uint8)[200:560],
                            np.full((360, 10, 3), 255, np.uint8),
                            np.clip(pred, 0, 255).astype(np.uint8)[200:560]], axis=1)
    Image.fromarray(strip).save(os.path.join(W, f"cmp_t{t:03d}.png"))
    np.save(os.path.join(W, f"gh_{t:03d}.npy"), gh)
print("wrote cmp_t*.png  (left = original frame, right = reference-based render)")
