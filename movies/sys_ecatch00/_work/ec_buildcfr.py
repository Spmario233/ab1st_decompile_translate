"""Expand the 39 re-encoded stored frames onto the original's CFR timeline.

Each stored frame is held until the next one starts, exactly reproducing the source's packet
schedule, so the Theora encoder regenerates the same duplicate-frame structure.
"""
import os, subprocess
import numpy as np

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
FF = r"E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe"
PROBE = r"E:\Videos\ffmpeg\ffmpeg71\ffprobe.exe"
SRC = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\sys_ecatch00.ogv"
H0, W0 = 720, 1280
FS = H0 * W0 * 3

out = subprocess.run([PROBE, "-v", "error", "-select_streams", "v:0",
                      "-show_entries", "packet=pts_time", "-of", "csv=p=0", SRC],
                     capture_output=True, text=True, check=True)
pts = [float(x) for x in out.stdout.split()]
print("stored frames:", len(pts), " last pts:", pts[-1])

n_cfr = 130
buf = np.empty((3, H0, W0), np.uint8)
new = np.memmap(os.path.join(W, "new_all.yuv"), np.uint8, mode="r", shape=(len(pts), 3, H0, W0))
dst = open(os.path.join(W, "new_cfr.yuv"), "wb")
used = np.zeros(len(pts), int)
for n in range(n_cfr):
    t = n / 30.0
    # Theora/Ogg records a granulepos = frame index, so each stored frame occupies the slots
    # from its own granulepos up to the next one.  That reproduces the source's packet
    # schedule exactly (verified afterwards by comparing packet pts_time with the original).
    idx = max(i for i in range(len(pts)) if round(pts[i] * 30) <= n + 1e-6)
    used[idx] += 1
    dst.write(np.ascontiguousarray(new[idx]).tobytes())
dst.close()
print("wrote new_cfr.yuv with", n_cfr, "frames")
print("stored frames used:", int((used > 0).sum()), "of", len(pts))
# sanity: compare against the CFR expansion of the original
orig = np.memmap(os.path.join(W, "orig_cfr.yuv"), np.uint8, mode="r", shape=(n_cfr, 3, H0, W0))
nn = np.memmap(os.path.join(W, "new_cfr.yuv"), np.uint8, mode="r", shape=(n_cfr, 3, H0, W0))
d = np.abs(orig.astype(np.int16) - nn.astype(np.int16))
ys = slice(266, 411); xs = slice(720, 1185)
m = np.ones((H0, W0), bool); m[ys, xs] = False
print("max |orig-new| outside the logo box over all 130 frames:", int(d[:, :, m].max()))
