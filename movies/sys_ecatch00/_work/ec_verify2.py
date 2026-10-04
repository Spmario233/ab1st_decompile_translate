import os, subprocess
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
D = r"E:\Projects\ab1st_decompile\video\sys_ecatch00"
FF = r"E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
FFP = r"E:\Videos\ffmpeg\ffmpeg71\ffprobe.exe"
H0, W0 = 720, 1280
BY0, BY1, BX0, BX1 = 266, 411, 720, 1185


def yuv2rgb(a):
    Y, U, V = a[0], a[1] - 128.0, a[2] - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.clip(np.stack([Y + 2 * (1 - kr) * V,
                             Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                             Y + 2 * (1 - kb) * U], -1), 0, 255)


print("=== 1. lossless master is bit-exact ===")
for f, tag in (("sys_ecatch00_cn_lossless.mkv", "mkv"),):
    subprocess.run([FF, "-v", "error", "-i", os.path.join(D, f), "-f", "framemd5",
                    os.path.join(W, f"{tag}.md5")], check=True)
subprocess.run([FF, "-v", "error", "-f", "rawvideo", "-pix_fmt", "yuv444p", "-s", "1280x720",
                "-r", "30", "-i", os.path.join(W, "new_final.yuv"), "-f", "framemd5",
                os.path.join(W, "ref.md5")], check=True)
a = [l for l in open(os.path.join(W, "mkv.md5")) if not l.startswith("#")]
b = [l for l in open(os.path.join(W, "ref.md5")) if not l.startswith("#")]
print(f"  mkv frames={len(a)} ref frames={len(b)}  identical={a == b}")

print("\n=== 2. ogv probe ===")
out = subprocess.run([FFP, "-v", "error", "-show_entries",
                      "stream=codec_name,width,height,pix_fmt,r_frame_rate",
                      "-show_entries", "format=duration,size,nb_streams",
                      "-of", "default=noprint_wrappers=1", os.path.join(D, "sys_ecatch00_cn.ogv")],
                     capture_output=True, text=True).stdout
print("  " + out.replace("\n", "\n  ").strip())
orig = subprocess.run([FFP, "-v", "error", "-show_entries", "format=duration,size",
                       "-of", "csv=p=0", os.path.join(D, "sys_ecatch00.ogv")],
                      capture_output=True, text=True).stdout.strip()
print("  original ogv (duration,size) =", orig)

print("\n=== 3. frames outside the logo box are untouched ===")
src = np.memmap(os.path.join(W, "all.yuv"), np.uint8, mode="r", shape=(39, 3, H0, W0))
new = np.memmap(os.path.join(W, "new_final.yuv"), np.uint8, mode="r", shape=(135, 3, H0, W0))
pts = [float(x) for x in subprocess.run(
    [FFP, "-v", "error", "-select_streams", "v:0", "-show_entries", "packet=pts_time",
     "-of", "csv=p=0", os.path.join(D, "sys_ecatch00.ogv")],
    capture_output=True, text=True).stdout.split()]
m = np.ones((H0, W0), bool); m[BY0:BY1, BX0:BX1] = False
mx = 0
for n in range(min(130, len(new))):
    i = max(k for k in range(len(pts)) if round(pts[k] * 30) <= n + 1e-6)
    mx = max(mx, int(np.abs(new[n].astype(np.int16) - src[i].astype(np.int16))[:, m].max()))
print("  max |new - source| outside the logo box over 130 CFR frames:", mx)
