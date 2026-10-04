import os, subprocess
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
PNG = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\logo_chinese_small.png"
FF = r"E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
H0, W0 = 720, 1280

# ---- colour range of the source -------------------------------------------
for t, tag in ((0.1, "blank"), (2.0, "held logo")):
    p = subprocess.run([FF, "-v", "error", "-ss", str(t), "-i",
                        r"E:\Projects\ab1st_decompile\video\sys_ecatch00\sys_ecatch00.ogv",
                        "-frames:v", "1", "-pix_fmt", "yuv444p", "-f", "rawvideo", "-"],
                       capture_output=True, check=True)
    a = np.frombuffer(p.stdout[:3 * H0 * W0], np.uint8).reshape(3, H0, W0)
    print(f"{tag:10s} t={t}:  Y range {a[0].min()}..{a[0].max()}  "
          f"U range {a[1].min()}..{a[1].max()}  V range {a[2].min()}..{a[2].max()}  "
          f"Ymean {a[0].mean():.2f}")

video = np.asarray(Image.open(os.path.join(W, "all_027.png")).convert("RGB"), np.float64)
inkv = 255.0 - video

rgba = Image.open(PNG).convert("RGBA")
print("\nchinese PNG:", rgba.size)

# ---- search scale + offset ------------------------------------------------
BX0, BX1, BY0, BY1 = 720, 1200, 280, 400
ref = inkv[BY0:BY1, BX0:BX1]
M = ref.max(axis=2) > 20
print("ink pixels in the reference box:", int(M.sum()))

best = None
for s in np.arange(0.585, 0.665, 0.0025):
    nw, nh = max(1, int(round(rgba.width * s))), max(1, int(round(rgba.height * s)))
    im = rgba.resize((nw, nh), Image.LANCZOS)
    arr = np.asarray(im, np.float64)
    al = arr[..., 3:4] / 255.0
    cn = (255.0 - arr[..., :3]) * al            # ink of the new logo on white
    for dy in range(0, 40):
        for dx in range(0, 120):
            canvas = np.zeros_like(ref)
            y0, x0 = 20 + dy, 10 + dx
            h = min(nh, canvas.shape[0] - y0); w = min(nw, canvas.shape[1] - x0)
            if h <= 0 or w <= 0:
                continue
            canvas[y0:y0 + h, x0:x0 + w] = cn[:h, :w]
            d = np.abs(canvas.max(axis=2) - ref.max(axis=2))
            score = float(np.percentile(d[M], 60))
            if best is None or score < best[0]:
                best = (score, s, dx, dy, nw, nh)
print(f"best: score={best[0]:.3f} scale={best[1]:.4f} dx={best[2]} dy={best[3]} "
      f"-> size {best[4]}x{best[5]}")
np.save(os.path.join(W, "align.npy"), np.array(best[1:], float))
