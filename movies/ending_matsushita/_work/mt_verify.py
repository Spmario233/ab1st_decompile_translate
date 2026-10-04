import os
import numpy as np
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_matsushita\_work"
H0, W0 = 720, 1280
N = 7890
new = np.memmap(os.path.join(W, "mt_out.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))
old = np.memmap(os.path.join(W, "raw.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))


def yuv2rgb(a):
    Y = a[0].astype(np.float64); U = a[1].astype(np.float64) - 128.0; V = a[2].astype(np.float64) - 128.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.stack([Y + 2 * (1 - kr) * V,
                     Y - (2 * (1 - kr) * kr / kg) * V - (2 * (1 - kb) * kb / kg) * U,
                     Y + 2 * (1 - kb) * U], -1)


print(" n      t      Ymin Ymax  nonwhite(old) nonwhite(new)  changed_px")
for n in [0, 300, 600, 700, 714, 1000, 2000, 4000, 6000, 6620, 6634, 6700, 7000, 7400,
          7420, 7431, 7500, 7800, 7829, 7830, 7833, 7850, 7889]:
    a = np.asarray(old[n]); b = np.asarray(new[n])
    ow = int((a[0] < 252).sum()); nw = int((b[0] < 252).sum())
    ch = int((a[0] != b[0]).sum())
    print(f"{n:5d} {n/30:7.2f}  {b[0].min():5.0f} {b[0].max():5.0f}  {ow:11d} {nw:12d}  {ch:10d}")

for tag, n in [("m_chk_t025", 750), ("m_chk_t060", 1800), ("m_chk_t120", 3600),
               ("m_chk_t200", 6000), ("m_chk_t220", 6600), ("m_chk_t240", 7200),
               ("m_chk_t250", 7500), ("m_chk_t262", 7860)]:
    Image.fromarray(np.clip(yuv2rgb(np.asarray(new[n])), 0, 255).astype(np.uint8)).save(
        os.path.join(W, tag + ".png"))
print("crops written")
