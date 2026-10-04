import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280
YUV = np.fromfile(os.path.join(W, "fr", "f036.yuv"), dtype=np.uint8).reshape(3, H0, W0)


def conv(YUV, kind, rng):
    Y = YUV[0].astype(np.float64)
    U = YUV[1].astype(np.float64) - 128.0
    V = YUV[2].astype(np.float64) - 128.0
    y = Y if rng == "full" else (Y - 16.0) * 255.0 / 219.0
    u = U if rng == "full" else U * 255.0 / 224.0
    v = V if rng == "full" else V * 255.0 / 224.0
    kr, kb = (0.299, 0.114) if kind == "bt601" else (0.2126, 0.0722)
    kg = 1 - kr - kb
    r = y + 2 * (1 - kr) * v
    b = y + 2 * (1 - kb) * u
    g = y - (2 * (1 - kr) * kr / kg) * v - (2 * (1 - kb) * kb / kg) * u
    return np.clip(np.stack([r, g, b], -1), 0, 255)


ff = np.asarray(Image.open(os.path.join(W, "fr", "f036_ff.png")).convert("RGB"), dtype=np.float64)
print("my conversion vs ffmpeg PNG decode:")
for kind in ("bt601", "bt709"):
    for rng in ("full", "limited"):
        e = np.abs(conv(YUV, kind, rng) - ff)
        print(f"   {kind} {rng:8s} mean={e.mean():7.3f} max={e.max():7.1f}")

ref = np.asarray(Image.open(os.path.join(R, "evsp_1303.png")).convert("RGB"), dtype=np.float64)
F = conv(YUV, "bt601", "limited")

sl = (slice(10, 710), slice(400, 900))


def fit_alpha(F, ref, sl):
    d = ref[sl] - 255.0
    a = float(((F[sl] - 255.0) * d).sum()) / float((d * d).sum())
    res = 255.0 + a * d - F[sl]
    return a, float(np.sqrt((res ** 2).mean()))


def blur(img, sigma):
    from PIL import ImageFilter
    return np.asarray(Image.fromarray(img.astype(np.uint8)).filter(
        ImageFilter.GaussianBlur(sigma)), dtype=np.float64)


print("\nframe t=36 vs evsp_1303 under different hypotheses:")
a, r = fit_alpha(F, ref, sl)
print(f"  as-is                       a={a:.4f} rms={r:6.2f}")
for s in (0.5, 0.8, 1.2, 1.8):
    b = blur(ref, s)
    a, r = fit_alpha(F, b, sl)
    print(f"  ref blurred sigma={s:<4}     a={a:.4f} rms={r:6.2f}")
for dy in (-2, -1, 0, 1, 2):
    for dx in (-2, -1, 0, 1, 2):
        sh = np.roll(np.roll(ref, dy, axis=0), dx, axis=1)
        a, r = fit_alpha(F, sh, sl)
        if r < 9.0:
            print(f"  ref shifted dy={dy} dx={dx}   a={a:.4f} rms={r:6.2f}")
# how much does a shift/blur change things - report the best
best = min(((fit_alpha(F, np.roll(np.roll(ref, dy, 0), dx, 1), sl)[1], dy, dx)
            for dy in range(-3, 4) for dx in range(-3, 4)))
print(f"  best integer shift: rms={best[0]:.2f} at dy={best[1]} dx={best[2]}")

# scale test
from PIL import Image as I
for s in (0.995, 1.0, 1.005, 0.99, 1.01):
    im = I.fromarray(ref.astype(np.uint8)).resize((int(1280 * s), int(720 * s)), I.LANCZOS)
    if s >= 1:
        arr = np.asarray(im, dtype=np.float64)[:720, :1280]
    else:
        pad = np.full((720, 1280, 3), 255.0)
        pad[:im.height, :im.width] = np.asarray(im, dtype=np.float64)
        arr = pad
    if arr.shape[:2] != (720, 1280):
        continue
    a, r = fit_alpha(F, arr, sl)
    print(f"  ref scaled {s:<6}          a={a:.4f} rms={r:6.2f}")
