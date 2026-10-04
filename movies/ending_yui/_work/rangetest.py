import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280


def conv(a, kind, rng, white=None):
    Y = a[0].astype(np.float64); U = a[1].astype(np.float64) - 128.0; V = a[2].astype(np.float64) - 128.0
    if rng == "full":
        y, u, v = Y, U, V
    else:
        y, u, v = (Y - 16.0) * 255.0 / 219.0, U * 255.0 / 224.0, V * 255.0 / 224.0
    kr, kb = (0.299, 0.114) if kind == "bt601" else (0.2126, 0.0722)
    kg = 1 - kr - kb
    return np.stack([y + 2 * (1 - kr) * v,
                     y - (2 * (1 - kr) * kr / kg) * v - (2 * (1 - kb) * kb / kg) * u,
                     y + 2 * (1 - kb) * u], -1)


P = {k: np.asarray(Image.open(os.path.join(R, k + ".png")).convert("RGB"), np.float64)
     for k in ("evsp_1301", "evsp_1302", "evsp_1303", "evsp_1304")}
mask = np.ones((H0, W0), bool)
mask[:, 60:440] = False
mask[:, 980:1250] = False
mask[:25, :] = False
mask[-25:, :] = False

for t in (12, 18, 22, 30, 36, 44, 48, 52):
    p = os.path.join(W, "fr", f"f{t:03d}.yuv")
    if not os.path.exists(p):
        continue
    a = np.fromfile(p, np.uint8).reshape(3, H0, W0)
    line = f"t={t:>3} : "
    for kind, rng in (("bt601", "limited"), ("bt601", "full"), ("bt709", "full")):
        F = np.clip(conv(a, kind, rng), 0, 255)
        best = None
        for k, ref in P.items():
            d = (ref - 255.0)[mask]
            al = float(((F - 255.0)[mask] * d).sum()) / float((d * d).sum())
            r = float(np.sqrt((((255.0 + al * d) - F[mask]) ** 2).mean()))
            if best is None or r < best[0]:
                best = (r, k, al)
        line += f" | {kind}-{rng:7s} {best[1][-4:]} a={best[2]:5.3f} rms={best[0]:6.2f}"
    print(line)
