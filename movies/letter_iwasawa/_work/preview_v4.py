"""Preview the new unconditional box rendering on the frames the user reported."""
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
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
traj, mos, sky, sp = rf.assets()
dy = sp['dy']; gam = sp['gamma']; slo = int(sp['lo'])
c0, c1 = rf.BAND_COLS
ALPHA = {'ill': rf._alpha(*rf.BAND_ROWS_ILL, c0, c1, rf.FEATHER),
         'sky': rf._alpha(*rf.BAND_ROWS_SKY, c0, c1, rf.FEATHER),
         'white': rf._alpha(*rf.BAND_ROWS_WHITE, c0, c1, rf.FEATHER)}

FRAMES = [int(x) for x in (sys.argv[1].split(',') if len(sys.argv) > 1 else
                           '66,873,1300,1353,1443,2463,3273,300,1200,1970').split(',')]
tiles = []
for n in FRAMES:
    F = pf.frame_rgb(n)
    if rf.ILL_LO <= n <= rf.ILL_HI:
        den = rf.den_for(n, rf.terms_for(n, xa), traj, mos)
        bg = WHITE + estimate_R(F, den) * den
        al = ALPHA['ill']
    elif rf.SKY_LO <= n <= rf.SKY_HI:
        i = n - slo
        bg = WHITE + gam[i] * (rf.sky_crop(sky, dy[i]) - WHITE)
        al = ALPHA['sky']
    else:
        bg = np.full((H, W, 3), WHITE, np.float32)
        al = ALPHA['white']
    out = al[..., None] * bg + (1 - al[..., None]) * F
    tiles.append((n, F, out))

sw, sh = 420, 236
canvas = Image.new('RGB', (2 * sw + 8, (sh + 18) * len(tiles)), (0, 0, 0))
d = ImageDraw.Draw(canvas)
for i, (n, a, b) in enumerate(tiles):
    y = i * (sh + 18) + 18
    canvas.paste(Image.fromarray(np.clip(a, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (0, y))
    canvas.paste(Image.fromarray(np.clip(b, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (sw + 8, y))
    d.text((3, y - 14), 'stored %d   LEFT = original   RIGHT = new render' % n, fill=(255, 255, 0))
canvas.save(os.path.join(WS, 'diag_v4_preview.png'))
print(canvas.size)
