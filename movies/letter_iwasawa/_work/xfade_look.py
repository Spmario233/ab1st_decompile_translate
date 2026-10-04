"""Look at the two transition frames the user flagged: pure-plate model vs blend model."""
import os, sys, pickle
import numpy as np, cv2
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
import render_full as rf
from Rfit import estimate_R

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj, mos, sky, sp = rf.assets()
c0, c1 = rf.BAND_COLS
ALPHA = rf._alpha(*rf.BAND_ROWS_ILL, c0, c1, rf.FEATHER)


def dfield(n, pname):
    return cv2.warpAffine(mos[pname], rf.M_of(traj, pname, n), (W, H),
                          flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE


CASES = [(1383, 'eviw_0801.png', 'eviw_0301.png', 0.88),
         (1953, 'eviw_0301.png', 'eviw_0401.png', 0.84)]
tiles = []
for n, pa, pb, al in CASES:
    F = pf.frame_rgb(n)
    dA = dfield(n, pa); dB = dfield(n, pb)
    den_pure = dA
    den_blend = al * dA + (1 - al) * dB
    bgA = WHITE + estimate_R(F, den_pure) * den_pure
    bgB = WHITE + estimate_R(F, den_blend) * den_blend
    oA = ALPHA[..., None] * bgA + (1 - ALPHA[..., None]) * F
    oB = ALPHA[..., None] * bgB + (1 - ALPHA[..., None]) * F
    eA = np.abs(oA - F).max(axis=2); eB = np.abs(oB - F).max(axis=2)
    box = ALPHA > 0.5
    print('n=%4d  pure-plate: box rms=%.2f p95=%.0f | blend(a=%.2f): box rms=%.2f p95=%.0f' %
          (n, np.sqrt((eA[box] ** 2).mean()), np.percentile(eA[box], 95),
           al, np.sqrt((eB[box] ** 2).mean()), np.percentile(eB[box], 95)))
    tiles.append((n, F, oA, oB))

sw, sh = 400, 225
canvas = Image.new('RGB', (3 * sw + 12, (sh + 18) * len(tiles)), (0, 0, 0))
d = ImageDraw.Draw(canvas)
for i, (n, F, a, b) in enumerate(tiles):
    y = i * (sh + 18) + 18
    for j, (lab, img) in enumerate((('original', F), ('pure plate', a), ('blend', b))):
        canvas.paste(Image.fromarray(np.clip(img, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS),
                     (j * (sw + 6), y))
        d.text((j * (sw + 6) + 3, y - 14), 'stored %d  %s' % (n, lab), fill=(255, 255, 0))
canvas.save(os.path.join(WS, 'diag_xfade_fix.png'))
print(canvas.size)
