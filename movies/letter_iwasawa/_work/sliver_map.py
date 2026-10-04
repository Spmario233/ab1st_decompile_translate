"""Map the 'backed only by blended frames' sliver onto the screen during the crossfades."""
import os, sys, pickle
import numpy as np, cv2
from PIL import Image, ImageDraw
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
import render_full as rf

WS = os.path.dirname(os.path.abspath(__file__))
traj, mos, sky, sp = rf.assets()
WHITE = 254.0
WMIN = 2.0

tiles = []
for n, pa, pb, al in [(1383, 'eviw_0801.png', 'eviw_0301.png', 0.88),
                      (1440, 'eviw_0801.png', 'eviw_0301.png', 0.23),
                      (1953, 'eviw_0301.png', 'eviw_0401.png', 0.84),
                      (2000, 'eviw_0301.png', 'eviw_0401.png', 0.26)]:
    F = pf.frame_rgb(n)
    overlay = np.zeros((H, W), np.uint8)
    for pname, wt in ((pa, al), (pb, 1 - al)):
        wc = np.load(os.path.join(WS, 'wclean_%s.npy' % pname[5:9]))
        M = rf.M_of(traj, pname, n)
        wcs = cv2.warpAffine(wc, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT)
        foot = cv2.warpAffine(np.ones((H, W), np.float32), M, (W, H),
                              flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_CONSTANT)
        bad = (foot > 0.5) & (wcs < WMIN)
        overlay = np.maximum(overlay, (bad * 255).astype(np.uint8))
    vis = F.copy()
    vis[overlay > 0] = 0.35 * vis[overlay > 0] + 0.65 * np.array([255, 0, 0], np.float32)
    tiles.append((n, pa, pb, al, vis))

sw, sh = 460, 259
canvas = Image.new('RGB', (sw, (sh + 16) * len(tiles)), (0, 0, 0))
d = ImageDraw.Draw(canvas)
for i, (n, pa, pb, al, vis) in enumerate(tiles):
    y = i * (sh + 16) + 16
    canvas.paste(Image.fromarray(np.clip(vis, 0, 255).astype(np.uint8)).resize((sw, sh), Image.LANCZOS), (0, y))
    d.text((3, y - 13), 'stored %d  %s a=%.2f  (red = mosaic only from blended frames)' % (n, pa[5:9], al), fill=(255, 255, 0))
canvas.save(os.path.join(WS, 'diag_sliver.png'))
print(canvas.size)
