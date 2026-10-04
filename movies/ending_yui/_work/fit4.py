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
    return np.clip(np.stack([y + 2 * (1 - kr) * v,
                             y - (2 * (1 - kr) * kr / kg) * v - (2 * (1 - kb) * kb / kg) * u,
                             y + 2 * (1 - kb) * u], -1), 0, 255)


def load(t):
    return yuv2rgb(np.fromfile(os.path.join(W, "fr", f"f{t:03d}.yuv"), np.uint8).reshape(3, H0, W0))


plates = [os.path.splitext(f)[0] for f in sorted(os.listdir(R))]
refs = {k: np.asarray(Image.open(os.path.join(R, k + ".png")).convert("RGB"), np.float64) for k in plates}

mask = np.ones((H0, W0), bool)
mask[:, 80:360] = False     # left subtitle column
mask[:, 930:1230] = False   # right subtitle column
mask[:40, :] = False
mask[-40:, :] = False
sel = mask

def flat(img):
    return img.reshape(-1, 3)[sel.ravel()].reshape(-1)


A4 = np.stack([flat(refs[k] - 255.0) for k in plates], 1)      # (N,4)
A2 = np.stack([flat(refs[plates[0]] - 255.0),
               flat(refs[plates[2]] - refs[plates[0]])], 1)

print(f"{'t':>4} | " + " ".join(f"{k[-4:]:>16}" for k in plates) + " |  2-layer          4-layer")
for t in [10, 12, 15, 18, 20, 22, 25, 28, 30, 33, 36, 40, 44, 48, 52, 56, 59, 61]:
    F = load(t)
    b = flat(F - 255.0)
    row = []
    for k in plates:
        d = flat(refs[k] - 255.0)
        a = float((b * d).sum()) / float((d * d).sum())
        row.append(f"a={a:5.3f} r={np.sqrt((((a * d) - b) ** 2).mean()):5.2f}")
    x2, *_ = np.linalg.lstsq(A2, b, rcond=None)
    r2 = np.sqrt((((A2 @ x2) - b) ** 2).mean())
    x4, *_ = np.linalg.lstsq(A4, b, rcond=None)
    r4 = np.sqrt((((A4 @ x4) - b) ** 2).mean())
    print(f"{t:>4} | " + "  ".join(row) + f" | u={x2[0]:5.3f} v={x2[1]:5.3f} r={r2:5.2f}"
          f" | w={np.round(x4,3)} r={r4:5.2f}")
