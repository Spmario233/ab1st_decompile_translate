"""ending_yui stage 2: render the de-subtitled frame sequence.

  t in [0, 61.97) : white + sum_k w_k(t) * (plate_k - white)   (supplied plates)
  t in [61.97, 148): pure white  -> credits text and the closing logo removed
"""
import os, time
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280
N_OUT = 4440                       # 148.0 s at 30 fps
T_IN = 1859

keys = ["evsp_1301", "evsp_1302", "evsp_1303", "evsp_1304"]


def rgb2yuv_full(rgb):
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    y = 0.299 * r + 0.587 * g + 0.114 * b
    return np.stack([y, 128.0 + (b - y) / 1.772, 128.0 + (r - y) / 1.402], 0)


plates = np.stack([rgb2yuv_full(np.asarray(
    Image.open(os.path.join(R, k + ".png")).convert("RGB"), np.float64)) for k in keys])
white = np.array([254.0, 128.0, 128.0])[:, None, None]
B = plates - white                                     # (4,3,720,1280)

wt = np.load(os.path.join(W, "yui_weights_raw.npy"))
# light temporal smoothing: the weights are physically smooth over time
kern = np.array([1.0, 2.0, 3.0, 2.0, 1.0]) / 9.0
ws = np.empty_like(wt)
for j in range(4):
    ws[:, j] = np.convolve(np.pad(wt[:, j], 2, mode="edge"), kern, mode="valid")
ws = np.clip(ws, 0.0, 1.0)
np.save(os.path.join(W, "yui_weights_smooth.npy"), ws)
s = ws.sum(axis=1)
last = int(np.max(np.nonzero(s > 0.002)[0])) if (s > 0.002).any() else -1
print("weight sum: min=%.4f max=%.4f   last frame with sum>0.002: n=%d (t=%.2f s)"
      % (s.min(), s.max(), last, last / 30.0))

out = os.path.join(W, "yui_out.yuv")
t0 = time.time()
buf = np.empty((3, H0, W0), np.uint8)
white_u8 = np.array([254, 128, 128], np.uint8)[:, None, None] * np.ones((1, H0, W0), np.uint8)
with open(out, "wb") as fh:
    for n in range(N_OUT):
        if n < T_IN:
            w = ws[n]
            acc = np.empty((3, H0, W0), np.float64)
            acc[:] = white
            for j in range(4):
                if w[j] != 0.0:
                    acc += w[j] * B[j]
            fr = np.clip(np.rint(acc), 0, 255).astype(np.uint8)
        else:
            fr = white_u8
        fh.write(np.ascontiguousarray(fr).tobytes())
        if n % 600 == 0:
            print(f"  frame {n}/{N_OUT} ({time.time()-t0:.0f}s)", flush=True)
print(f"wrote {out} ({time.time()-t0:.0f}s)")
