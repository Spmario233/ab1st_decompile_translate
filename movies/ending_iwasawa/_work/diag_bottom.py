import os, numpy as np
W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
RAW = os.path.join(W, "raw_0_73.yuv")
MM = np.memmap(RAW, dtype=np.uint8, mode="r", shape=(2190, 3, 720, 1280))

M = np.load(os.path.join(W, "mosaic_final.npy"))
ext = np.load(os.path.join(W, "ext_rows.npy")) if os.path.exists(os.path.join(W, "ext_rows.npy")) else None
U_lo, H = (int(v) for v in np.load(os.path.join(W, "ulo_final.npy")))
cum = np.load(os.path.join(W, "cum_final.npy"))
fade = np.load(os.path.join(W, "fade.npy"))

print("mosaic bottom rows (u = U_lo + i):  i, u, Ymean, Ymax")
for i in list(range(0, 30)) + [50, 80, 120, 200, 400]:
    u = U_lo + i
    print(f"  i={i:4d} u={u:6d}  Ymean={M[0,i].mean():7.2f}  Ymax={M[0,i].max():4.0f}")

print("\ndirect observation of the same master rows in raw frames:")
for n in [2050, 2055, 2057, 2060, 2065, 2070, 2080, 2090, 2100]:
    c = cum[n] if n < len(cum) else None
    if c is None:
        continue
    fr = np.asarray(MM[n], dtype=np.float32)
    y0 = 0
    u0 = c + y0
    print(f"  n={n} t={n/30:6.2f} fade={fade[n]:.4f} cum={c:9.2f} "
          f"Y[y=0]={fr[0,y0].mean():7.2f} -> /fade = {fr[0,y0].mean()/fade[n]:7.2f}   "
          f"Ymax_row0={fr[0,y0].max():4.0f}")

print("\nextension rows (u ascending from U_ext):")
U_ext, Hx = (int(v) for v in np.load(os.path.join(W, "u_ext.npy")))
print("U_ext", U_ext, "Hx", Hx)
