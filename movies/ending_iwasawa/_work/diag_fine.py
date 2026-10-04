import os, numpy as np
W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
BP = np.load(os.path.join(W, "bp_y.npy"))     # (2190,1440) float32 row-mean band profiles
H0 = 720
P2 = BP.reshape(len(BP), 2, H0)
ys = np.arange(H0, dtype=np.float64)


def ssd(nA, nB, s):
    """pB[y] vs pA[y+s]"""
    pos = s + ys
    i0 = np.floor(pos).astype(int)
    f = pos - i0
    ok = (i0 >= 0) & (i0 + 1 < H0)
    if ok.sum() < 300:
        return np.nan
    i0c = np.clip(i0, 0, H0 - 2)
    v = P2[nA][:, i0c] * (1 - f) + P2[nA][:, i0c + 1] * f
    d = P2[nB][:, ok] - v[:, ok]
    return float(np.mean(d * d))


def measure(nA, nB, pred, span, step=0.02):
    ss = np.arange(pred - span, pred + span + 1e-9, step)
    vals = np.array([ssd(nA, nB, s) for s in ss])
    i = int(np.nanargmin(vals))
    if 0 < i < len(vals) - 1:
        y0, y1, y2 = vals[i - 1], vals[i], vals[i + 1]
        den = y0 - 2 * y1 + y2
        sub = 0.5 * (y0 - y2) / den if den != 0 else 0.0
        sub = float(np.clip(sub, -1, 1))
    else:
        sub = 0.0
    return ss[i] + sub * step, float(vals[i])


# --- ground truth anchors from the wide-range search -------------------------
gt = np.load(os.path.join(W, "cum_s1.npy"))
ref = {30: -23.55, 100: -81.44, 300: -244.16, 600: -488.53}

# --- fine chained estimate (K=1) ---------------------------------------------
cum = np.zeros(601)
for n in range(600):
    s, v = measure(n, n + 1, -0.815, 0.9)     # search around the expected -0.815
    cum[n + 1] = cum[n] + s
print("fine K=1 chain vs ground-truth anchors:")
for k in sorted(ref):
    print(f"  n={k:4d}  chain={cum[k]:9.2f}   truth={ref[k]:9.2f}   diff={cum[k]-ref[k]:7.2f}")

# --- fine estimate directly with K=30, chained -------------------------------
cum30 = np.zeros(601)
for n in range(0, 600, 30):
    pred = -24.4
    s, v = measure(n, n + 30, pred, 3.0)
    for j in range(1, 31):
        cum30[n + j] = np.nan
    cum30[n + 30] = cum30[n] + s
print("\nfine K=30 chain (anchors only):")
for k in sorted(ref):
    if not np.isnan(cum30[k]):
        print(f"  n={k:4d}  chain={cum30[k]:9.2f}   truth={ref[k]:9.2f}   diff={cum30[k]-ref[k]:7.2f}")
