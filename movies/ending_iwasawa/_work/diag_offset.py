import os, numpy as np
W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
import importlib.util
spec = importlib.util.spec_from_file_location("s1", os.path.join(W, "stage1_recon.py"))
s1 = importlib.util.module_from_spec(spec)
import sys
sys.modules["s1"] = s1
spec.loader.exec_module(s1)   # __name__ != __main__, so nothing runs

cum = np.load(os.path.join(W, "cum_s1.npy"))
M, U_lo, U_hi, cnt = s1.median_mosaic(cum, "diag")
Pb = s1.mosaic_bp(M, U_lo).reshape(2, -1).astype(np.float32)
Hm = Pb.shape[1]
ys = np.arange(720, dtype=np.float32)
BP = s1.BP


def ssd(n, s):
    p = BP[n].reshape(2, 720)
    pos = (cum[n] + s) + ys - U_lo
    i0 = np.floor(pos).astype(np.int32)
    f = pos - i0
    ok = (i0 >= 0) & (i0 + 1 < Hm)
    if ok.sum() < 400:
        return np.nan
    i0c = np.clip(i0, 0, Hm - 2)
    v = Pb[:, i0c] * (1 - f) + Pb[:, i0c + 1] * f
    d = p[:, ok] - v[:, ok]
    return float(np.mean(d * d))


print(" n     t     cum_used    best_s   ssd@0     ssd@best")
for n in range(0, 2058, 100):
    ss = np.arange(-14, 14.001, 0.1)
    vals = np.array([ssd(n, s) for s in ss])
    i = int(np.nanargmin(vals))
    print(f"{n:5d} {n/30:6.2f} {cum[n]:10.2f}   {ss[i]:7.2f}  {ssd(n,0):9.2f} {vals[i]:9.2f}")

# sharpness check: vertical gradient energy of the mosaic vs a raw frame
fr = np.asarray(s1.MM[0, 0], dtype=np.float32)
g_fr = np.abs(np.diff(fr, axis=0)).mean()
g_M = np.abs(np.diff(M[:, 0, :], axis=0)).mean()
print(f"\nvertical |dY| mean: frame0={g_fr:.3f}  mosaic={g_M:.3f}")
