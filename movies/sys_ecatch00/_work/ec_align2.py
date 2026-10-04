import os, subprocess
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
PNG = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\logo_chinese_small.png"
FF = r"E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
SRC = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\sys_ecatch00.ogv"
H0, W0 = 720, 1280

RAW = os.path.join(W, "all.yuv")
if not os.path.exists(RAW):
    subprocess.run([FF, "-v", "error", "-y", "-i", SRC, "-fps_mode", "passthrough",
                    "-pix_fmt", "yuv444p", "-f", "rawvideo", RAW], check=True)
n = os.path.getsize(RAW) // (H0 * W0 * 3)
print("stored frames (sequential decode):", n)
MM = np.memmap(RAW, np.uint8, mode="r", shape=(n, 3, H0, W0))

nonwhite = [(i, int((MM[i, 0] < 250).sum())) for i in range(n)]
print("first frames non-white px:", nonwhite[:4])
first = MM[0].astype(np.float64).reshape(3, -1)
print("frame 0 (Y,U,V) mean =", np.round(first.mean(axis=1), 3),
      " Y min/max =", first[0].min(), first[0].max())

# video logo ink, from the held frame (index 26 = 27th stored frame)
held = np.asarray(MM[26], np.float64)
rgb = None
print("held frame Y range", held[0].min(), held[0].max())


def yuv2rgb_full(a):
    Y, U, V = a[0], a[1] - 128.0, a[2] - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([Y + 2 * (1 - kr) * V,
                     Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                     Y + 2 * (1 - kb) * U], -1)


video = yuv2rgb_full(held)
inkv = np.clip(255.0 - video, 0, None)
sil_v = inkv.max(axis=2) > 40
ys, xs = np.nonzero(sil_v)
print(f"held-logo silhouette bbox: x {xs.min()}..{xs.max()} y {ys.min()}..{ys.max()} "
      f"= {xs.max()-xs.min()+1} x {ys.max()-ys.min()+1}")

rgba = Image.open(PNG).convert("RGBA")

best = None
for s in np.arange(0.575, 0.675, 0.005):
    nw, nh = int(round(rgba.width * s)), int(round(rgba.height * s))
    arr = np.asarray(rgba.resize((nw, nh), Image.LANCZOS), np.float64)
    al = arr[..., 3:4] / 255.0
    cn = (255.0 - arr[..., :3]) * al
    sil_c = cn.max(axis=2) > 40
    if not sil_c.any():
        continue
    cys, cxs = np.nonzero(sil_c)
    for dy in range(-12, 13, 2):
        for dx in range(-12, 13, 2):
            y0 = ys.min() - cys.min() + dy
            x0 = xs.min() - cxs.min() + dx
            canvas = np.zeros((H0, W0), bool)
            yy0, xx0 = max(0, y0), max(0, x0)
            yy1, xx1 = min(H0, y0 + nh), min(W0, x0 + nw)
            if yy1 <= yy0 or xx1 <= xx0:
                continue
            canvas[yy0:yy1, xx0:xx1] = sil_c[yy0 - y0:yy1 - y0, xx0 - x0:xx1 - x0]
            inter = (canvas & sil_v).sum()
            union = (canvas | sil_v).sum()
            iou = inter / union
            if best is None or iou > best[0]:
                best = (iou, s, dx, dy, x0, y0, nw, nh)
print(f"\nbest silhouette IoU={best[0]:.4f}  scale={best[1]:.4f}  dx={best[2]} dy={best[3]}"
      f"  -> place at ({best[4]},{best[5]}) size {best[6]}x{best[7]}")
np.save(os.path.join(W, "align.npy"), np.array(best[1:], float))
print("video logo bbox   :", xs.min(), xs.max(), ys.min(), ys.max())
print("placing cn logo at: x %d..%d  y %d..%d" % (best[4], best[4] + best[6] - 1,
                                                  best[5], best[5] + best[7] - 1))
