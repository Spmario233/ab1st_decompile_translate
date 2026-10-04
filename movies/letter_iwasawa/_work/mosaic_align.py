"""Is the plate-3 mosaic content correctly placed?  Compare against the exact anchor warp."""
import os, sys, pickle
import numpy as np, cv2
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import render_full as rf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
traj, mos, sky, sp = rf.assets()
anchors = {'eviw_0801.png': ('001167.png', 1049), 'eviw_0301.png': ('001842.png', 1724),
           'eviw_0401.png': ('002160.png', 2042), 'eviw_0701.png': ('002810.png', 2692)}
AC = {p: pf.load_png_rgb(os.path.join(ROOT, 'refrences', f)).astype(np.float32) for p, (f, n) in anchors.items()}


def anchor_warp(pname, n):
    tt, P = traj[pname]
    M = sim_from_params_or(traj, pname, n)
    Ma = sim_from_params_or(traj, pname, anchors[pname][1])
    R = (np.vstack([M, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]
    return cv2.warpAffine(AC[pname], R, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT, borderValue=(255, 255, 255))


from mosaic_build import sim_from_params  # noqa


def sim_from_params_or(traj, pname, n):
    return rf.M_of(traj, pname, n)


tiles = []
for pname, ns in (('eviw_0401.png', [1960, 2000, 2020]), ('eviw_0801.png', [1380, 1400, 1440])):
    for n in ns:
        A = anchor_warp(pname, n)
        mo = cv2.warpAffine(mos[pname], rf.M_of(traj, pname, n), (W, H), flags=cv2.INTER_LINEAR,
                            borderMode=cv2.BORDER_REPLICATE)
        # alignment of mosaic warp vs anchor warp (translation + scale via ECC-free search)
        ga = cv2.cvtColor(A.astype(np.uint8), cv2.COLOR_RGB2GRAY).astype(np.float32)
        gm = cv2.cvtColor(mo.astype(np.uint8), cv2.COLOR_RGB2GRAY).astype(np.float32)
        band = np.zeros((H, W), np.float32); band[300:420, :] = 1
        ga = ga - cv2.GaussianBlur(ga, (0, 0), 20); gm = gm - cv2.GaussianBlur(gm, (0, 0), 20)
        best = None
        for dy in np.arange(-6, 6.5, 1.0):
            for dx in np.arange(-6, 6.5, 1.0):
                M = np.float32([[1, 0, dx], [0, 1, dy]])
                gs = cv2.warpAffine(gm, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
                d = np.abs(gs - ga) * band
                v = d.sum() / band.sum()
                if best is None or v < best[0]:
                    best = (v, dx, dy)
        print('%-6s n=%4d  best mosaic->anchor shift dx=%+.1f dy=%+.1f  (mean|hp diff| %.2f)' %
              (pname[5:9], n, best[1], best[2], best[0]))
        tiles.append((pname[5:9], n, A, mo))

sw, sh = 400, 225
canvas = Image.new('RGB', (2 * sw + 8, (sh + 16) * len(tiles)), (0, 0, 0))
d = ImageDraw.Draw(canvas)
for i, (nm, n, A, mo) in enumerate(tiles):
    y = i * (sh + 16) + 16
    canvas.paste(Image.fromarray(np.clip(A, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (0, y))
    canvas.paste(Image.fromarray(np.clip(mo, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (sw + 8, y))
    d.text((3, y - 13), '%s n=%d   LEFT = anchor warp (truth)   RIGHT = mosaic warp' % (nm, n), fill=(255, 255, 0))
canvas.save(os.path.join(WS, 'diag_mosaicalign.png'))
print(canvas.size)
