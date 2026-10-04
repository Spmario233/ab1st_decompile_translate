"""sys_ecatch00: replace the Japanese logo with the supplied Chinese logo.

The clip is white + an animated logo.  Inside the logo box the frame ink is modelled as

    ink(t) = a(t) * BODY + b(t) * SHADOW  +  r(t)

where BODY is the logo artwork and SHADOW is the drop shadow that the source adds part-way
through the reveal (it is absent for the first frames).  a(t), b(t) are fitted per frame on
the ORIGINAL, then the same values are re-applied to the CHINESE artwork, so the reveal is
reproduced.  r(t) - the ECG streak / glow that also crosses the box - is carried over, but
suppressed wherever either logo has ink so no Japanese glyph can leak through.
"""
import os
import numpy as np
from PIL import Image, ImageFilter

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
PNG = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\logo_chinese_small.png"
H0, W0, N = 720, 1280, 39
MM = np.memmap(os.path.join(W, "all.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))
WHITE = np.array([254.0, 128.0, 128.0])


def yuv2rgb(a):
    Y, U, V = a[0], a[1] - 128.0, a[2] - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([Y + 2 * (1 - kr) * V,
                     Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                     Y + 2 * (1 - kb) * U], -1)


def rgb2yuv(rgb):
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    y = 0.299 * r + 0.587 * g + 0.114 * b
    return np.stack([y, 128.0 + (b - y) / 1.772, 128.0 + (r - y) / 1.402], -1)


s, dx, dy, x0, y0, nw, nh = np.load(os.path.join(W, "align.npy"))
x0, y0, nw, nh = int(x0), int(y0), int(nw), int(nh)
sdx, sdy, sig, kk = (float(v) for v in np.load(os.path.join(W, "shadow.npy")))
sdx, sdy = int(round(sdx)), int(round(sdy))
print(f"logo placement ({x0},{y0}) size {nw}x{nh}   shadow offset ({sdx},{sdy}) "
      f"blur {sig} k {kk:.3f}")

rgba = np.asarray(Image.open(PNG).convert("RGBA").resize((nw, nh), Image.LANCZOS), np.float64)
L = rgba[..., 3:4] / 255.0
sh = Image.fromarray((L[..., 0] * 255).astype(np.uint8)).transform(
    (nw, nh), Image.AFFINE, (1, 0, -sdx, 0, 1, -sdy), resample=Image.BILINEAR, fillcolor=0)
if sig > 0:
    sh = sh.filter(ImageFilter.GaussianBlur(sig))
S0 = (np.asarray(sh, np.float64) / 255.0)[..., None] * kk

# ---- bases at full-frame resolution ---------------------------------------
M = 26                                    # generous margin around the box
BX = (slice(y0 - M, y0 + nh + M), slice(x0 - M, x0 + nw + M))
bh, bw = BX[0].stop - BX[0].start, BX[1].stop - BX[1].start


def into_box(arr):
    out = np.zeros((bh, bw) + arr.shape[2:], np.float64)
    out[M:M + nh, M:M + nw] = arr
    return out


body_cn = into_box((255.0 - rgba[..., :3]) * L)
shadow_cn = into_box(np.repeat(255.0 * (1.0 - L) * S0, 3, axis=2))

ink_final = 255.0 - np.clip(yuv2rgb(np.asarray(MM[27], np.float64)), 0, 255)
ref = ink_final[BX]
shadow_jp = shadow_cn.copy()
body_jp = np.clip(ref - shadow_jp, 0, None)
mag_jp = body_jp.max(axis=2) + shadow_jp.max(axis=2)
mag_cn = body_cn.max(axis=2) + shadow_cn.max(axis=2)
KEEP = np.clip(1.0 - np.maximum(mag_jp, mag_cn) / 40.0, 0.0, 1.0)
print("keep mask: %.1f%% of box pixels retain the residual" % (KEEP.mean() * 100))

A = np.stack([body_jp.reshape(-1, 3), shadow_jp.reshape(-1, 3)], -1)   # (P,3,2)
print("fitting a(t), b(t) per frame ...")
coef = np.zeros((N, 2))
res = np.zeros(N)
for i in range(N):
    y = (255.0 - np.clip(yuv2rgb(np.asarray(MM[i], np.float64)), 0, 255))[BX].reshape(-1, 3)
    G = np.einsum("pc k,pc l->kl", A, A)
    rhs = np.einsum("pc k,pc->k", A, y)
    coef[i] = np.linalg.solve(G + np.eye(2) * 1e-6 * np.trace(G), rhs)
    res[i] = float(np.sqrt(((A @ coef[i] - y) ** 2).mean()))
np.save(os.path.join(W, "coef.npy"), coef)
print("frame   a(body)   b(shadow)    rms")
for i in range(N):
    print(f"  {i+1:2d}   {coef[i,0]:7.3f}  {coef[i,1]:9.3f}   {res[i]:7.2f}")

# ---- render ---------------------------------------------------------------
# Only the logo box is touched: everything outside is copied through as the
# original YUV bytes, so no RGB round-trip error can leak into the frame.
out = np.empty((N, 3, H0, W0), np.uint8)
by0, by1 = BX[0].start, BX[0].stop
bx0, bx1 = BX[1].start, BX[1].stop
for i in range(N):
    a, b = coef[i]
    y = (255.0 - np.clip(yuv2rgb(np.asarray(MM[i], np.float64)), 0, 255))[BX]
    r = (y - a * body_jp - b * shadow_jp) * KEEP[..., None]
    newink = np.clip(a * body_cn + b * shadow_cn + r, 0, 255)
    # the source's flat background is Y=254 (not 255), so render white at 254
    box_rgb = np.clip(254.0 - newink, 0, 255)
    frame = np.array(MM[i])
    frame[:, by0:by1, bx0:bx1] = np.clip(
        np.rint(rgb2yuv(box_rgb)), 0, 255).transpose(2, 0, 1).astype(np.uint8)
    out[i] = frame
out.tofile(os.path.join(W, "new_all.yuv"))
print("wrote new_all.yuv", out.shape, out.dtype)

for tag, i in [("n_02", 1), ("n_09", 8), ("n_11", 10), ("n_13", 12), ("n_18", 17),
               ("n_20", 19), ("n_22", 21), ("n_27", 26), ("n_30", 29)]:
    im = np.clip(yuv2rgb(out[i].astype(np.float64)), 0, 255).astype(np.uint8)
    Image.fromarray(im).save(os.path.join(W, "out_%s.png" % tag))
print("preview crops written")
