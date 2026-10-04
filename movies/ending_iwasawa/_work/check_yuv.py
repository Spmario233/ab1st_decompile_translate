import numpy as np

RAW = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work\raw_0_73.yuv"
FS = 1280 * 720
P = 1280 * 720
mm = np.memmap(RAW, dtype=np.uint8, mode="r", shape=(2190, 3, 720, 1280))
# mm[n] = [Y, U, V]

for t in [0, 5, 20, 40, 68, 70, 71.4, 71.8, 72.5]:
    n = int(round(t * 30))
    n = min(n, 2189)
    fr = np.asarray(mm[n])
    print(f"t={t:5.1f} n={n:4d}  Y:[{fr[0].min():3d},{fr[0].max():3d}] mean={fr[0].mean():6.2f}   "
          f"U:[{fr[1].min():3d},{fr[1].max():3d}] mean={fr[1].mean():6.2f}   "
          f"V:[{fr[2].min():3d},{fr[2].max():3d}] mean={fr[2].mean():6.2f}")

print()
print("corner/edge Y of last black frames:")
for n in [2160, 2170, 2180, 2189]:
    fr = np.asarray(mm[n])
    print(n, "Y max", fr[0].max(), "Y mean", fr[0].mean(), "U mean", fr[1].mean(), "V mean", fr[2].mean())
