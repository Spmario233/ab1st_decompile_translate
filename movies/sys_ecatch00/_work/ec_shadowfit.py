import os
import numpy as np
from PIL import Image, ImageFilter

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
PNG = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\logo_chinese_small.png"
H0, W0 = 720, 1280
MM = np.memmap(os.path.join(W, "all.yuv"), np.uint8, mode="r", shape=(39, 3, H0, W0))


def yuv2rgb(a):
    Y, U, V = a[0], a[1] - 128.0, a[2] - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([Y + 2 * (1 - kr) * V,
                     Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                     Y + 2 * (1 - kb) * U], -1)


vid = np.clip(yuv2rgb(np.asarray(MM[27], np.float64)), 0, 255)
ink_v = 255.0 - vid

s, dx, dy, x0, y0, nw, nh = np.load(os.path.join(W, "align.npy"))
x0, y0, nw, nh = int(x0), int(y0), int(nw), int(nh)

rgba = np.asarray(Image.open(PNG).convert("RGBA").resize((nw, nh), Image.LANCZOS), np.float64)
L = rgba[..., 3] / 255.0
logo_ink = (255.0 - rgba[..., :3]) * L[..., None]        # (nh,nw,3)

BOX = (slice(y0 - 25, y0 + nh + 25), slice(x0 - 25, x0 + nw + 25))
ref = ink_v[BOX]
oneL = np.ones(BOX[0].stop - BOX[0].start), np.ones(BOX[1].stop - BOX[1].start)


def place(img, oy, ox):
    """put an (nh,nw) or (nh,nw,3) array into the box frame at (oy,ox)"""
    sh = img.shape
    out = np.zeros((BOX[0].stop - BOX[0].start, BOX[1].stop - BOX[1].start) + sh[2:], np.float64)
    y1 = min(out.shape[0], oy + sh[0]); x1 = min(out.shape[1], ox + sh[1])
    if y1 <= oy or x1 <= ox:
        return out
    out[oy:y1, ox:x1] = img[:y1 - oy, :x1 - ox]
    return out


lbox = place(logo_ink, 25, 25)
Lbox = place(L, 25, 25)
resid_base = ref - lbox
best = None
for sdx in range(2, 14):
    for sdy in range(2, 14):
        for sig in (0.0, 0.6, 1.0, 1.4, 1.8, 2.4):
            sh = Image.fromarray((L * 255).astype(np.uint8))
            sh = sh.transform(sh.size, Image.AFFINE, (1, 0, -sdx, 0, 1, -sdy),
                              resample=Image.BILINEAR, fillcolor=0)
            if sig > 0:
                sh = sh.filter(ImageFilter.GaussianBlur(sig))
            S0 = place(np.asarray(sh, np.float64) / 255.0, 25, 25)
            base = 255.0 * (1.0 - Lbox) * S0
            num = float((resid_base * base[..., None]).sum())
            den = float((base ** 2).sum()) * 3.0
            k = num / den if den else 0.0
            k = float(np.clip(k, 0.0, 1.2))
            err = float(np.sqrt(((resid_base - k * base[..., None]) ** 2).mean()))
            if best is None or err < best[0]:
                best = (err, sdx, sdy, sig, k)
print(f"best shadow fit: rms={best[0]:.3f}  offset=({best[1]},{best[2]})  blur={best[3]}  k={best[4]:.3f}")
np.save(os.path.join(W, "shadow.npy"), np.array(best[1:], float))

# residual without any shadow, for comparison
print("rms with no shadow at all:", round(float(np.sqrt((resid_base ** 2).mean())), 3))
