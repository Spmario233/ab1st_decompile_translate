"""Add back the source's own frame-to-frame variation inside the logo box.

The held section of the source is a static logo that the original encoder still re-codes every
few frames, so consecutive stored frames differ.  A perfectly clean render removes that
variation, and libtheora then discards the trailing frames, shortening the stream.  The
variation is pure codec texture (the artwork is identical in every held frame), so it carries
no glyph information; it is added back only where the NEW logo has ink, which also keeps the
old katakana position clean.
"""
import os
import numpy as np

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
H0, W0, N = 720, 1280, 39
BY0, BY1, BX0, BX1 = 266, 411, 720, 1185


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


MM = np.memmap(os.path.join(W, "all.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))
inc = 255.0 - np.clip(yuv2rgb(np.asarray(MM[27], np.float64)), 0, 255)
mag = inc[BY0:BY1, BX0:BX1].max(axis=2)
WGT = (mag > 8).astype(np.float64)              # where the ORIGINAL logo has ink

held = [np.clip(yuv2rgb(np.asarray(MM[i], np.float64)), 0, 255)[BY0:BY1, BX0:BX1]
        for i in range(26, N)]
med = np.median(np.stack(held), axis=0)
dev = [255.0 - h - (255.0 - med) for h in held]  # ink deviation, pure codec texture
print("dev magnitude per held frame:",
      [round(float(np.abs(d).mean()), 2) for d in dev])

new = np.memmap(os.path.join(W, "new_all.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))
out = np.empty_like(new)
for i in range(N):
    fr = np.array(new[i])
    if i >= 26:
        rgb = np.clip(yuv2rgb(fr.astype(np.float64)), 0, 255)
        box = rgb[BY0:BY1, BX0:BX1] + dev[i - 26] * WGT[..., None]
        rgb[BY0:BY1, BX0:BX1] = box
        fr[:, BY0:BY1, BX0:BX1] = np.clip(np.rint(rgb2yuv(np.clip(rgb, 0, 255))), 0, 255
                                          ).transpose(2, 0, 1).astype(np.uint8)
    out[i] = fr
out.tofile(os.path.join(W, "new_all2.yuv"))
# outside-box invariance check
m = np.ones((H0, W0), bool); m[BY0:BY1, BX0:BX1] = False
mx = max(int(np.abs(out[i].astype(np.int16) - new[i].astype(np.int16))[:, m].max())
         for i in range(N))
print("max change outside the box:", mx)
print("consecutive diff in the held range:",
      [int(np.abs(out[i].astype(np.int16) - out[i - 1].astype(np.int16)).max())
       for i in range(27, N)])
