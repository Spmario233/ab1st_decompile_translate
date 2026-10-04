"""sys_ecatch00: replace the Japanese logo with the supplied Chinese logo.

Model, inside the logo box:

    ink(t) = m_x(t) * ( a(t)*blur(BODY,s(t)) + b(t)*blur(SHADOW,s(t)) )  +  r(t)

  a(t), b(t)  global per-frame amounts of the logo body and of the drop shadow the source
              adds part-way through the reveal
  s(t)        per-frame blur (the logo materialises out of a blur)
  m_x(t)      per-column reveal gain (the source wipes the logo in from the left)
  r(t)        whatever else crosses the box (the ECG streak / glow)

All of it is fitted on the ORIGINAL frames and then re-applied to the CHINESE artwork, so the
reveal is reproduced.  r(t) is suppressed wherever either logo has ink, so no Japanese glyph
can leak through.  Pixels outside the box are copied through byte-for-byte.
"""
import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
PNG = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\logo_chinese_small.png"
H0, W0, N = 720, 1280, 39
MM = np.memmap(os.path.join(W, "all.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))
SIGMAS = [0.0, 0.7, 1.2, 1.8, 2.5, 3.4, 4.6, 6.0]
SX = 6.0


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


def _gk(sig):
    r = max(1, int(round(3 * sig)))
    x = np.arange(-r, r + 1, dtype=np.float64)
    k = np.exp(-0.5 * (x / sig) ** 2)
    return k / k.sum()


def _conv1d(a, k, axis):
    r = (len(k) - 1) // 2
    if axis == 0:
        return np.apply_along_axis(
            lambda m: np.convolve(m, k, "valid"), 0,
            np.pad(a, ((r, r), (0, 0)), mode="edge"))
    return np.apply_along_axis(
        lambda m: np.convolve(m, k, "valid"), 1,
        np.pad(a, ((0, 0), (r, r)), mode="edge"))


def blur3(img, sig):
    if sig <= 0:
        return img
    k = _gk(sig)
    return np.stack([_conv1d(_conv1d(img[..., c], k, 1), k, 0)
                     for c in range(img.shape[2])], axis=2)


# ---------------------------------------------------------------- geometry
s, dx, dy, x0, y0, nw, nh = np.load(os.path.join(W, "align.npy"))
x0, y0, nw, nh = int(x0), int(y0), int(nw), int(nh)
sdx, sdy, sig, kk = (float(v) for v in np.load(os.path.join(W, "shadow.npy")))
sdx, sdy = int(round(sdx)), int(round(sdy))
print(f"logo at ({x0},{y0}) {nw}x{nh};  shadow offset ({sdx},{sdy}) blur {sig} k {kk:.3f}")

rgba = np.asarray(Image.open(PNG).convert("RGBA").resize((nw, nh), Image.LANCZOS), np.float64)
L = rgba[..., 3:4] / 255.0
sh = Image.fromarray((L[..., 0] * 255).astype(np.uint8)).transform(
    (nw, nh), Image.AFFINE, (1, 0, -sdx, 0, 1, -sdy), resample=Image.BILINEAR, fillcolor=0)
S0 = (np.asarray(sh, np.float64) / 255.0)[..., None] * kk

M = 26
BY0, BY1, BX0, BX1 = y0 - M, y0 + nh + M, x0 - M, x0 + nw + M
bh, bw = BY1 - BY0, BX1 - BX0
print("box", (BY0, BY1, BX0, BX1), "->", bh, "x", bw)


def into_box(arr):
    out = np.zeros((bh, bw) + arr.shape[2:], np.float64)
    out[M:M + nh, M:M + nw] = arr
    return out


body_cn = into_box((255.0 - rgba[..., :3]) * L)
shadow_cn = into_box(np.repeat(255.0 * (1.0 - L) * S0, 3, axis=2))

ink_final = 255.0 - np.clip(yuv2rgb(np.asarray(MM[27], np.float64)), 0, 255)
ref = ink_final[BY0:BY1, BX0:BX1]
shadow_jp = shadow_cn.copy()
body_jp = np.clip(ref - shadow_jp, 0, None)
mag = np.maximum(body_jp.max(axis=2) + shadow_jp.max(axis=2),
                 body_cn.max(axis=2) + shadow_cn.max(axis=2))
KEEP = np.clip(1.0 - mag / 40.0, 0.0, 1.0)
print("keep mask: %.1f%% of box pixels carry the residual" % (KEEP.mean() * 100))

body_s = [blur3(body_jp, g) for g in SIGMAS]
shad_s = [blur3(shadow_jp, g) for g in SIGMAS]
bodyc_s = [blur3(body_cn, g) for g in SIGMAS]
shadc_s = [blur3(shadow_cn, g) for g in SIGMAS]
sm = np.exp(-0.5 * (np.arange(-21, 22) / SX) ** 2)
sm /= sm.sum()


def keep_box(arr):
    return arr.reshape(bh, -1)


coef = np.zeros((N, 2))
mask = np.zeros((N, bw))
best_sig = np.zeros(N, int)
res = np.zeros(N)
for i in range(N):
    y = (255.0 - np.clip(yuv2rgb(np.asarray(MM[i], np.float64)), 0, 255))[BY0:BY1, BX0:BX1]
    Y = keep_box(y)
    best = None
    for k in range(len(SIGMAS)):
        B = keep_box(body_s[k]); S = keep_box(shad_s[k])
        BB = float((B * B).sum()); SS = float((S * S).sum()); BS = float((B * S).sum())
        BY = float((B * Y).sum()); SY = float((S * Y).sum())
        det = BB * SS - BS * BS
        if det <= 0:
            continue
        a = (BY * SS - SY * BS) / det
        b = (SY * BB - BY * BS) / det
        tot = a * B + b * S
        Yr = Y.reshape(bh, bw, 3); tr = tot.reshape(bh, bw, 3)
        den = (tr * tr).sum(axis=(0, 2))
        m = np.where(den > 1e-6, (Yr * tr).sum(axis=(0, 2)) / np.maximum(den, 1e-9), 1.0)
        m = np.convolve(np.pad(m, 21, mode="edge"), sm, mode="valid")
        m = np.clip(m, 0.0, 1.15)
        pred = np.repeat(m, 3)[None, :] * tot
        e = float(np.sqrt(((pred - Y) ** 2).mean()))
        if best is None or e < best[0]:
            best = (e, k, a, b, m)
    e, k, a, b, m = best
    coef[i] = (a, b); mask[i] = m; best_sig[i] = k; res[i] = e
    print(f"  frame {i+1:2d}  sigma={SIGMAS[k]:4.1f}  a={a:6.3f} b={b:6.3f}  "
          f"mask {m.min():.2f}..{m.max():.2f}  rms={e:6.2f}")
np.save(os.path.join(W, "coef3.npy"), coef)
np.save(os.path.join(W, "mask.npy"), mask)
np.save(os.path.join(W, "sig.npy"), best_sig)

# ------------------------------------------------------------------ render
out = np.empty((N, 3, H0, W0), np.uint8)
for i in range(N):
    k = best_sig[i]
    a, b = coef[i]
    m = mask[i][None, :, None]
    y = (255.0 - np.clip(yuv2rgb(np.asarray(MM[i], np.float64)), 0, 255))[BY0:BY1, BX0:BX1]
    tot_jp = a * body_s[k] + b * shad_s[k]
    r = (y - m * tot_jp) * KEEP[..., None]
    tot_cn = a * bodyc_s[k] + b * shadc_s[k]
    newink = np.clip(m * tot_cn + r, 0, 255)
    box_rgb = np.clip(254.0 - newink, 0, 255)      # source background white is Y=254
    frame = np.array(MM[i])
    frame[:, BY0:BY1, BX0:BX1] = np.clip(np.rint(rgb2yuv(box_rgb)), 0, 255
                                         ).transpose(2, 0, 1).astype(np.uint8)
    out[i] = frame
out.tofile(os.path.join(W, "new_all.yuv"))
print("wrote new_all.yuv", out.shape)
