"""Sky segment: register every frame against the reconstructed mosaic and measure the fade."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, load_png_rgb, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
mosaic = load_png_rgb(os.path.join(ROOT, 'sky_mosaic_full.png'))
print('mosaic', mosaic.shape)
MG = cv2.cvtColor(mosaic.astype(np.uint8), cv2.COLOR_RGB2GRAY).astype(np.float32)
MH = MG.shape[0]

LO, HI = 60, 850
T0 = 520          # template top row in frame coords (below the subtitle band)

offs = np.full(HI - LO, np.nan)
scores = np.full(HI - LO, np.nan)

for i, n in enumerate(range(LO, HI)):
    g = pf.frame_gray(n).astype(np.float32)
    tpl = g[T0:H, :]
    th = H - T0
    best = (1e18, -1)
    # coarse: step 2
    for dy in range(0, MH - H + 1, 1):
        d = MG[dy + T0:dy + H, :] - tpl
        s = float((d * d).mean())
        if s < best[0]:
            best = (s, dy)
    dy0 = best[1]
    # sub-pixel parabola on SSD
    def ssd(dy):
        if dy < 0 or dy > MH - H:
            return 1e18
        d = MG[dy + T0:dy + H, :] - tpl
        return float((d * d).mean())
    s0, sm, sp = ssd(dy0), ssd(dy0 - 1), ssd(dy0 + 1)
    den = (sm - 2 * s0 + sp)
    sub = 0.5 * (sm - sp) / den if abs(den) > 1e-9 else 0.0
    sub = max(-1.0, min(1.0, sub))
    offs[i] = dy0 + sub
    scores[i] = s0
    if i % 60 == 0:
        print('n=%4d dy=%8.3f ssd=%.2f' % (n, offs[i], s0), flush=True)

np.save(os.path.join(WS, 'sky_off.npy'), offs)
np.save(os.path.join(WS, 'sky_lo.npy'), np.array([LO, HI]))
print('dy range %.3f .. %.3f' % (np.nanmin(offs), np.nanmax(offs)))
for i in range(0, len(offs), 10):
    print('  n=%4d dy=%.3f ssd=%.2f' % (LO + i, offs[i], scores[i]))
