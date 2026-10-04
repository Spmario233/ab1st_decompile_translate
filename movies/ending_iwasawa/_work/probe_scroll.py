import subprocess, sys, os
import numpy as np
from PIL import Image

FF = r"E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
SRC = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\ef_sr_iw00.ogv"
TMP = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work\probe"
os.makedirs(TMP, exist_ok=True)

times = [0, 1, 2, 3, 4, 5, 7, 10, 13, 16, 20, 23, 40, 68]

def grab(t):
    p = os.path.join(TMP, f"p{t:03d}.png")
    if not os.path.exists(p):
        subprocess.run([FF, "-v", "error", "-y", "-ss", str(t), "-i", SRC,
                        "-frames:v", "1", p], check=True)
    return np.asarray(Image.open(p).convert("L"), dtype=np.float32)

frames = {t: grab(t) for t in times}


def best_shift(a, b, maxdy=700):
    """Find dy minimizing MSE between a[y] and b[y+dy] (both 720 tall)."""
    best = None
    for dy in range(-maxdy, maxdy + 1, 1):
        if dy >= 0:
            a0, a1 = dy, 720
            b0, b1 = 0, 720 - dy
        else:
            a0, a1 = 0, 720 + dy
            b0, b1 = -dy, 720
        if a1 - a0 < 200:
            continue
        d = a[a0:a1:4, ::4] - b[b0:b1:4, ::4]
        m = float(np.mean(d * d))
        if best is None or m < best[1]:
            best = (dy, m)
    return best


print("pair  dy  mse   (positive dy => content moved DOWN)")
for i in range(len(times) - 1):
    t0, t1 = times[i], times[i + 1]
    dy, mse = best_shift(frames[t0], frames[t1])
    print(f"{t0:>3}->{t1:<3} dy={dy:>5}  mse={mse:8.2f}")

# also check identical-frame sanity
dy, mse = best_shift(frames[0], frames[0])
print("self 0->0", dy, mse)
