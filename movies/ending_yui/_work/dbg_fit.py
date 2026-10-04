import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280
keys = ["evsp_1301", "evsp_1302", "evsp_1303", "evsp_1304"]
rgb = {k: np.asarray(Image.open(os.path.join(R, k + ".png")).convert("RGB"), np.float64) for k in keys}


def rgb2yuv(r):
    y = 0.299 * r[..., 0] + 0.587 * r[..., 1] + 0.114 * r[..., 2]
    u = 128.0 + (r[..., 2] - y) / 1.772
    v = 128.0 + (r[..., 0] - y) / 1.402
    return np.stack([y, u, v], 0)


def yuv2rgb(a):
    Ym = a[0].astype(np.float64); U = a[1].astype(np.float64) - 128.0; V = a[2].astype(np.float64) - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([Ym + 2 * (1 - kr) * V,
                     Ym - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                     Ym + 2 * (1 - kb) * U], -1)


mask = np.zeros((H0, W0), bool)
mask[6:714, 460:965] = True

a36 = np.fromfile(os.path.join(W, "fr", "f036.yuv"), np.uint8).reshape(3, H0, W0)
white = np.array([253.816, 128.028, 128.055])

# ---- RGB domain -------------------------------------------------------------
Frgb = yuv2rgb(a36)
A_rgb = np.stack([(rgb[k] - 255.0)[mask] for k in keys], -1).reshape(-1, 4)
b_rgb = (Frgb - 255.0)[mask].reshape(-1)
x, *_ = np.linalg.lstsq(A_rgb, b_rgb, rcond=None)
print("RGB domain 4-basis weights:", np.round(x, 4),
      " rms =", round(float(np.sqrt(((A_rgb @ x - b_rgb) ** 2).mean())), 3))

# ---- YUV domain -------------------------------------------------------------
A_yuv = np.stack([(rgb2yuv(rgb[k]) - white[:, None, None])[:, mask] for k in keys], 0)  # (4,3,Nm)
A_yuv = A_yuv.transpose(1, 2, 0).reshape(-1, 4)
b_yuv = (a36.astype(np.float64)[:, mask] - white[:, None]).T.reshape(-1)
x2, *_ = np.linalg.lstsq(A_yuv, b_yuv, rcond=None)
print("YUV domain 4-basis weights:", np.round(x2, 4),
      " rms =", round(float(np.sqrt(((A_yuv @ x2 - b_yuv) ** 2).mean())), 3))

# component-wise check of the two conversions
k = keys[2]
pl_yuv = rgb2yuv(rgb[k])
Fyuv = a36.astype(np.float64)
print("\nplate vs frame, channel means over the mask (t=36):")
for c, nm in enumerate("YUV"):
    print(f"  {nm}: plate mean={pl_yuv[c][mask].mean():8.2f}  frame mean={Fyuv[c][mask].mean():8.2f} "
          f" white={white[c]:8.2f}")
print("\nplate Y stats: min=%.1f max=%.1f" % (pl_yuv[0].min(), pl_yuv[0].max()))
print("frame Y stats: min=%.1f max=%.1f" % (Fyuv[0].min(), Fyuv[0].max()))
# per-channel single-plate alpha
for c, nm in enumerate("YUV"):
    d = (pl_yuv[c] - white[c])[mask]; yy = (Fyuv[c] - white[c])[mask]
    al = float((d * yy).sum()) / float((d * d).sum())
    print(f"  single-plate alpha on {nm}: {al:6.3f}  resid rms={np.sqrt(((al*d-yy)**2).mean()):7.2f}")
