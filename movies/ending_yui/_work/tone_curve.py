import numpy as np, os
from PIL import Image

W = r"E:\Projects\ab1st_decompile\video\ending_yui\_work"
R = r"E:\Projects\ab1st_decompile\video\ending_yui\refrences"
H0, W0 = 720, 1280


def yuv2rgb(a):
    Y = a[0].astype(np.float64); U = a[1].astype(np.float64) - 128.0; V = a[2].astype(np.float64) - 128.0
    y = (Y - 16.0) * 255.0 / 219.0
    u, v = U * 255.0 / 224.0, V * 255.0 / 224.0
    kr, kb = 0.299, 0.114; kg = 1 - kr - kb
    return np.clip(np.stack([y + 2 * (1 - kr) * v,
                             y - (2 * (1 - kr) * kr / kg) * v - (2 * (1 - kb) * kb / kg) * u,
                             y + 2 * (1 - kb) * u], -1), 0, 255)


def load(t):
    return yuv2rgb(np.fromfile(os.path.join(W, "fr", f"f{t:03d}.yuv"), np.uint8).reshape(3, H0, W0))


ref = np.asarray(Image.open(os.path.join(R, "evsp_1303.png")).convert("RGB"), np.float64)
sel = np.zeros((H0, W0), bool); sel[10:710, 400:900] = True

for t in (36, 48):
    F = load(t)
    g = ref[sel].ravel(); f = F[sel].ravel()
    print(f"--- t={t}s : frame value vs reference value, binned over the reference ---")
    edges = [0, 60, 100, 140, 170, 190, 205, 220, 235, 245, 251, 256]
    for lo, hi in zip(edges[:-1], edges[1:]):
        m = (g >= lo) & (g < hi)
        if m.sum() < 50:
            continue
        print(f"   ref {lo:3d}-{hi:3d} : n={m.sum():7d}  frame mean={f[m].mean():7.2f} "
              f"std={f[m].std():6.2f}   (n*|diff|={np.abs(f[m]-g[m]).mean():6.2f})")
    # best-fit monotone-ish curve: piecewise linear on the bins
    xs = np.linspace(0, 255, 256)
    idx = np.clip(np.round(g).astype(int), 0, 255)
    curve = np.full(256, np.nan)
    for i in range(256):
        m = idx == i
        if m.sum() >= 20:
            curve[i] = f[m].mean()
    ok = ~np.isnan(curve)
    print(f"   fitted tone curve covers {ok.sum()}/256 levels; residual after applying it:")
    lut = np.interp(np.arange(256), np.arange(256)[ok], curve[ok])
    pred = lut[idx]
    print(f"      rms={np.sqrt(((pred-f)**2).mean()):6.2f}   (linear affine fit gave ~7)")
