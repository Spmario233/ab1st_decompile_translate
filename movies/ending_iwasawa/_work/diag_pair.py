import os, numpy as np
W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
RAW = os.path.join(W, "raw_0_73.yuv")
NF, H0, W0 = 2190, 720, 1280
MM = np.memmap(RAW, dtype=np.uint8, mode="r", shape=(NF, 3, H0, W0))
BANDS = [(0, 400), (880, 1280)]


def prof(n):
    y = np.asarray(MM[n, 0], dtype=np.float32)
    return np.concatenate([y[:, a:b].mean(axis=1) for a, b in BANDS]).reshape(2, H0)


def ssd_pair(nA, nB, s):
    """p_B[y]  vs  p_A[y + s]   (linear interpolation)."""
    pA = prof(nA)
    pB = prof(nB)
    pos = s + np.arange(H0, dtype=np.float64)
    i0 = np.floor(pos).astype(int)
    f = pos - i0
    ok = (i0 >= 0) & (i0 + 1 < H0)
    if ok.sum() < 200:
        return np.nan
    i0c = np.clip(i0, 0, H0 - 2)
    v = pA[:, i0c] * (1 - f) + pA[:, i0c + 1] * f
    d = pB[:, ok] - v[:, ok]
    return float(np.mean(d * d))


cum = np.load(os.path.join(W, "cum_s1.npy"))
print("pair        cum_guess   best_s(fine)   ssd_min   ssd@cum_guess")
for nB in [30, 100, 300, 600, 1000, 1400, 1800, 2057]:
    guess = cum[nB]                 # s should equal -cum[nB]  (p_B[y] == p_A[y - cum])
    lo, hi = guess - 40, guess + 40
    ss = np.arange(lo, hi + 1e-9, 0.05)
    vals = np.array([ssd_pair(0, nB, s) for s in ss])
    i = int(np.nanargmin(vals))
    print(f"0->{nB:<5d} { -guess:10.2f}   {-ss[i]:10.2f}   {vals[i]:8.3f}   {ssd_pair(0,nB,guess):8.3f}")
