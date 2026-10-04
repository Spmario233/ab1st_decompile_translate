import os, json
import numpy as np
from PIL import Image

FR = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work\frames"
N = 2190  # frames 1..2190  => t = (n-1)/30

# text-free horizontal bands (verified visually: credits occupy ~x 470..860)
BANDS = [(0, 400), (880, 1280)]


def profile(n):
    im = Image.open(os.path.join(FR, f"f{n:05d}.png")).convert("L")
    a = np.asarray(im, dtype=np.float32)
    return np.concatenate([a[:, b0:b1].mean(axis=1) for b0, b1 in BANDS])


profs = []
for n in range(1, N + 1):
    profs.append(profile(n))
profs = np.asarray(profs)          # (2190, 1440)
np.save(r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work\band_profiles.npy", profs)
print("profiles", profs.shape)


def ssd_shift(p, q, d):
    """p[y] vs q[y+d]; returns mean SSD over valid rows (profiles are band-concat)."""
    h = 720
    P = p.reshape(2, h)
    Q = q.reshape(2, h)
    if d >= 0:
        a = P[:, d:h]; b = Q[:, 0:h - d]
    else:
        a = P[:, 0:h + d]; b = Q[:, -d:h]
    if a.shape[1] < 300:
        return None
    return float(np.mean((a - b) ** 2))


def estimate(p, q, lo=-6, hi=6):
    vals = []
    for d in range(lo, hi + 1):
        v = ssd_shift(p, q, d)
        if v is not None:
            vals.append((d, v))
    ds = np.array([d for d, _ in vals], dtype=float)
    vs = np.array([v for _, v in vals])
    i = int(np.argmin(vs))
    if 0 < i < len(vs) - 1:
        y0, y1, y2 = vs[i - 1], vs[i], vs[i + 1]
        den = (y0 - 2 * y1 + y2)
        sub = 0.5 * (y0 - y2) / den if den != 0 else 0.0
        sub = float(np.clip(sub, -1, 1))
    else:
        sub = 0.0
    return ds[i] + sub, float(vs[i])


# incremental offsets
inc = np.zeros(N - 1)
qual = np.zeros(N - 1)
for n in range(N - 1):
    d, v = estimate(profs[n], profs[n + 1])
    inc[n] = d
    qual[n] = v
np.save(r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work\inc.npy", inc)
np.save(r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work\qual.npy", qual)

cum = np.concatenate([[0.0], np.cumsum(inc)])
np.save(r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work\cum.npy", cum)

print("t(s)   offset(px)  inc_mean(px/s)  worst_ssd(1s bin)")
for s in range(0, 73):
    i0 = s * 30
    i1 = min((s + 1) * 30, N)
    if i0 >= len(cum):
        break
    seg = inc[i0:i1 - 1] if i1 - 1 > i0 else inc[i0:i0 + 1]
    print(f"{s:>3}  {cum[i0]:9.2f}   {seg.mean() * 30:9.2f}   {qual[i0:i1-1].max() if i1-1>i0 else 0:10.1f}")
