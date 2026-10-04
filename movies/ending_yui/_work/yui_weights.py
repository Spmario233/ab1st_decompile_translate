"""ending_yui stage 1: solve, for every frame of the illustration section, the
weights of the four supplied background plates (linear compositing model).

    frame = white + sum_k w_k * (plate_k - white)

solved in the source's native full-range BT.601 YUV over a text-free window.
"""
import os, time
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280
T = 1859
MM = np.memmap(os.path.join(W, "raw_0_62.yuv"), np.uint8, mode="r", shape=(T, 3, H0, W0))


def log(*a):
    print(*a, flush=True)


def rgb2yuv_full(rgb):
    r, g, b = rgb[..., 0], rgb[..., 1], rgb[..., 2]
    y = 0.299 * r + 0.587 * g + 0.114 * b
    u = 128.0 + (b - y) / 1.772
    v = 128.0 + (r - y) / 1.402
    return np.stack([y, u, v], 0)


keys = ["evsp_1301", "evsp_1302", "evsp_1303", "evsp_1304"]
plates = []
for k in keys:
    rgb = np.asarray(Image.open(os.path.join(R, k + ".png")).convert("RGB"), np.float64)
    plates.append(rgb2yuv_full(rgb))
plates = np.stack(plates)                      # (4,3,720,1280)

white = np.array([np.asarray(MM[T - 6, c]).mean() for c in range(3)])
log("video white level (Y,U,V) =", np.round(white, 3))

# text-free window: the credits sit in two fixed columns, x<455 and x>965
mask = np.zeros((H0, W0), bool)
mask[6:714, 460:965] = True
Nm = int(mask.sum())
log(f"fit window: {Nm} px")

Ai = (plates - white[:, None, None])[:, :, mask]        # (4, 3, Nm)
A = Ai.transpose(1, 2, 0).reshape(-1, 4)               # (3*Nm, 4)
N = A.T @ A
log("normal matrix eigenvalues:", np.round(np.linalg.eigvalsh(N), 1))
Ninv = np.linalg.pinv(N, rcond=1e-6)

wts = np.zeros((T, 4))
res = np.zeros(T)
t0 = time.time()
for t in range(T):
    fr = np.asarray(MM[t], np.float64)                  # (3,720,1280)
    y = (fr[:, mask] - white[:, None]).reshape(-1)      # (3*Nm,) channel-major, matches A
    wts[t] = Ninv @ (A.T @ y)
    res[t] = np.sqrt(np.mean((A @ wts[t] - y) ** 2))
np.save(os.path.join(W, "yui_weights_raw.npy"), wts)
np.save(os.path.join(W, "yui_fitres.npy"), res)
log(f"solved in {time.time()-t0:.0f}s   residual rms: mean={res.mean():.2f} max={res.max():.2f}")
log("weights (every 2 s)  1301 1302 1303 1304   rms")
for t in range(0, T, 60):
    log(f"  t={t/30:6.2f}  " + " ".join(f"{v:7.3f}" for v in wts[t]) + f"   {res[t]:5.2f}")
