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


refs = {os.path.splitext(f)[0]: np.asarray(Image.open(os.path.join(R, f)).convert("RGB"), dtype=np.float64)
        for f in sorted(os.listdir(R))}

sl = (slice(10, 710), slice(400, 900))
for t, plate in ((12, "evsp_1301"), (36, "evsp_1303")):
    F = load(t)
    P = refs[plate]
    d = P - 255.0
    a = float(((F[sl] - 255.0) * d[sl]).sum()) / float((d[sl] ** 2).sum())
    pred = 255.0 + a * d
    res = np.abs(F - pred)
    print(f"t={t} plate={plate} a={a:.4f}  rms(region)={np.sqrt((res[sl]**2).mean()):.2f} "
          f" mean={res[sl].mean():.2f} p99={np.percentile(res[sl],99):.1f}")

    # crops side by side: frame / prediction / residual x6
    cy, cx = (200, 400) if t == 12 else (420, 520)
    f = F[cy:cy + 240, cx:cx + 400].astype(np.uint8)
    p = np.clip(pred[cy:cy + 240, cx:cx + 400], 0, 255).astype(np.uint8)
    r = np.clip(res[cy:cy + 240, cx:cx + 400] * 6, 0, 255).astype(np.uint8)
    strip = np.concatenate([f, np.full((240, 8, 3), 255, np.uint8), p,
                            np.full((240, 8, 3), 255, np.uint8), r], axis=1)
    Image.fromarray(strip).save(os.path.join(W, f"resid_t{t}.png"))

# noise floor reference: how different are two nearby frames in a static area?
A = load(35); B = load(36)
print("adjacent frames t=35 vs t=36 : mean|d|=%.2f rms=%.2f  (upper-left sky area)"
      % (np.abs(A-B)[10:300, 400:900].mean(), np.sqrt(((A-B)[10:300, 400:900]**2).mean())))
print("wrote resid_t12.png / resid_t36.png")
