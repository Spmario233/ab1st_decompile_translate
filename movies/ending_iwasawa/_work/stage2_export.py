import os, subprocess
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
FF = r"E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
OUT = r"E:\Projects\ab1st_decompile\video\ending_iwasawa"

M = np.load(os.path.join(W, "mosaic_final.npy"))          # (3,H,W0) stored YUV
U_lo, H = np.load(os.path.join(W, "ulo_final.npy"))
H = int(H)
u_hi = U_lo + H - 1
print("mosaic", M.shape, "u_lo", U_lo, "u_hi", u_hi)

u8 = np.clip(np.rint(M), 0, 255).astype(np.uint8)
raw = os.path.join(W, "mosaic_preview.yuv")
u8.tofile(raw)

png = os.path.join(OUT, "sky_background_reconstructed.png")
subprocess.run([FF, "-v", "error", "-y", "-f", "rawvideo", "-pix_fmt", "yuv444p",
                "-s", f"1280x{H}", "-color_range", "tv", "-colorspace", "bt470bg",
                "-i", raw, "-frames:v", "1", png], check=True)
print("wrote", png)

im = Image.open(png)
print("png size", im.size)
half = im.resize((640, H // 2), Image.LANCZOS)
half.save(os.path.join(W, "mosaic_preview_half.png"))

# validate against the original decode of frame 0 (master rows u=0..719 == frame 0 rows)
orig = np.asarray(Image.open(os.path.join(W, "samples", "t000.png")).convert("RGB"), dtype=np.float64)
mine = np.asarray(im.convert("RGB"), dtype=np.float64)[-720:]
print("mosaic u=0..719 vs original frame 0 : mean|err|=%.3f max=%.1f"
      % (np.abs(mine - orig).mean(), np.abs(mine - orig).max()))
