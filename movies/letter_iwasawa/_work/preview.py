"""Visual preview of the band replacement for a few frames."""
import os, sys
import numpy as np, cv2
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import render_full as rf
from Rfit import estimate_R

WHITE = 254.0
WS = os.path.dirname(os.path.abspath(__file__))
xa = rf.compute_xalpha()
traj, mos, sky, sp = rf.assets()
dy = sp['dy']; gam = sp['gamma']; slo = int(sp['lo'])
BAND = rf.BAND_ROWS
Y0, Y1 = BAND
X0, X1 = 40, 1180

FRAMES = [int(x) for x in (sys.argv[1].split(',') if len(sys.argv) > 1 else
                           '100,200,500,800,880,950,1050,1200,1450,1700,2050,2300,2700,3000,3250,3400'.split(','))]
rows = []
for n in FRAMES:
    F = pf.frame_rgb(n)
    if rf.ILL_LO <= n <= rf.ILL_HI:
        den = rf.den_for(n, rf.terms_for(n, xa), traj, mos)
        R = estimate_R(F, den)
        bg = WHITE + R * den
    elif rf.SKY_LO <= n <= rf.SKY_HI:
        i = n - slo
        bg = WHITE + gam[i] * (rf.sky_crop(sky, dy[i]) - WHITE)
    else:
        bg = np.full((H, W, 3), WHITE, np.float32)
    diff = np.abs(bg - F).max(axis=2)
    m = (diff > rf.MASK_THR)
    m[:, :X0] = False; m[:, X1:] = False; m[:Y0] = False; m[Y1:] = False
    md = cv2.dilate(m.astype(np.uint8), np.ones((rf.MASK_DILATE,) * 2, np.uint8)).astype(bool)
    out = np.where(md[..., None], bg, F)
    rows.append((n, F[Y0:Y1, X0:X1], bg[Y0:Y1, X0:X1], out[Y0:Y1, X0:X1], md[Y0:Y1, X0:X1]))

sw = (X1 - X0) // 2
sh = (Y1 - Y0) // 2
canvas = Image.new('RGB', (sw * 2 + 8, (sh + 14) * len(rows)), (20, 20, 20))
dr = ImageDraw.Draw(canvas)
for i, (n, a, b, c, m) in enumerate(rows):
    y = i * (sh + 14) + 14
    canvas.paste(Image.fromarray(a.astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (0, y))
    canvas.paste(Image.fromarray(c.astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (sw + 8, y))
    dr.text((3, y - 12), 'n=%d  left=original   right=replaced' % n, fill=(255, 255, 0))
canvas.save(os.path.join(WS, 'diag_preview.png'))
print('saved diag_preview.png', canvas.size)
