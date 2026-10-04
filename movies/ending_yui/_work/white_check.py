import numpy as np, os
W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
H0, W0 = 720, 1280
T = 1859
MM = np.memmap(os.path.join(W, "raw_0_62.yuv"), np.uint8, mode="r", shape=(T, 3, H0, W0))
wt = np.load(os.path.join(W, "yui_weights_raw.npy"))

# corner patches that are pure white in every plate
patches = [(slice(20, 120), slice(20, 200)), (slice(20, 120), slice(1080, 1260)),
           (slice(620, 710), slice(20, 200))]
print("white level measured in corner patches:")
for t in (5, 30, 61, 61.5, 61.8, 61.97):
    n = min(int(round(t * 30)), T - 1)
    fr = np.asarray(MM[n], np.float64)
    vals = [fr[:, p[0], p[1]].mean(axis=(1, 2)) for p in patches]
    v = np.mean(vals, axis=0)
    print(f"  t={t:6.2f} n={n:4d}  Y={v[0]:7.3f} U={v[1]:7.3f} V={v[2]:7.3f}   sum(w)={wt[n].sum():.4f}")

print("\nlast frames with residual illustration:")
for n in range(T - 1, T - 40, -1):
    s = wt[n].sum()
    if n % 3 == 0 or s > 0.01:
        print(f"  n={n:4d} t={n/30:6.3f}  sum(w)={s:8.5f}  w={np.round(wt[n],4)}")
    if s < 0.002:
        break
