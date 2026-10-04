"""Preview the dissolve windows with the masked-box fix."""
import os, sys, pickle
import numpy as np
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
import render_full as rf
from Rfit import estimate_R

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj, mos, sky, sp = rf.assets()
xa = pickle.load(open(os.path.join(WS, 'xalpha.pkl'), 'rb'))
xb = pickle.load(open(os.path.join(WS, 'xalpha2.pkl'), 'rb'))
import numpy as np
for key in ('a','b'):
    src=xb[key]; ks=sorted(src); vals=[src[k] for k in ks]; win=rf.XFADE[key]
    xa[key]={n: (min(float(src[ks[0]]),1.0) if n<=ks[0] else (max(float(src[ks[-1]]),0.0) if n>=ks[-1] else float(np.clip(np.interp(n,ks,vals),0.0,1.0)))) for n in range(win[2],win[3]+1)}
box = rf._alpha(*rf.BAND_ROWS_ILL, rf.BAND_COLS[0], rf.BAND_COLS[1], rf.FEATHER)

NS = [int(x) for x in (sys.argv[1] if len(sys.argv) > 1 else
                       '1383,1400,1430,1450,1953,1975,2000,2020').split(',')]
tiles = []
for n in NS:
    terms = rf.terms_for(n, xa)
    den = rf.den_for(n, terms, traj, mos)
    F = pf.frame_rgb(n)
    bg = WHITE + estimate_R(F, den) * den
    al = box
    if len(terms) > 1:
        if rf.XFADE['a'][2] <= n <= rf.XFADE['a'][3]:
            al = rf._alpha(*rf.WIN_A_BOX, rf.FEATHER)
        bg, al = rf.fix_box(F, bg, terms, al, n)
    out = al[..., None] * bg + (1 - al[..., None]) * F
    g = np.zeros((H, W, 3), np.float32)
    for pname, w in terms:
        g += w * rf.anchor_den(pname, n)
    clean = np.abs(F - (WHITE + g)).max(axis=2) < 18
    band = np.zeros((H, W), bool); band[318:404, 92:1208] = True
    ch = clean & band & (al > 0.5)
    print('n=%4d terms=%s  leftover on clean px: %d (mean %.2f)  painted px=%d %%' %
          (n, [(t[0][5:9], round(t[1], 2)) for t in terms], int(ch.sum()),
           np.abs(out - F).max(axis=2)[ch].mean() if ch.any() else 0.0,
           int((al > 0.5).sum())))
    tiles.append((n, F, out))

sw, sh = 400, 225
c = Image.new('RGB', (2 * sw + 8, (sh + 16) * len(tiles)), (0, 0, 0))
d = ImageDraw.Draw(c)
for i, (n, a, b) in enumerate(tiles):
    y = i * (sh + 16) + 16
    c.paste(Image.fromarray(np.clip(a, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (0, y))
    c.paste(Image.fromarray(np.clip(b, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (sw + 8, y))
    d.text((3, y - 13), 'stored %d   LEFT = original   RIGHT = new (masked box)' % n, fill=(255, 255, 0))
c.save(os.path.join(WS, 'diag_v5_preview.png'))
print(c.size)



