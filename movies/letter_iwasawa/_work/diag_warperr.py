"""Visualise the residual between a warped clean anchor frame and a distant frame."""
import os, sys
import numpy as np, cv2
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo = int(d['lo']); plates = [str(x) for x in d['plates']]; M4 = d['M']
BAND = (280, 520)


def rel(Mn, Ma):
    return (np.vstack([Mn, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]


tiles = []
for anchor, refname, pname, targets in [
        (2042, '002160.png', 'eviw_0401.png', [2100, 2250, 2400, 2500]),
        (1049, '001167.png', 'eviw_0801.png', [960, 1150, 1300, 1390])]:
    j = plates.index(pname)
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname)).astype(np.float32)
    Ma = M4[anchor - lo, j]
    for n in targets:
        Mn = M4[n - lo, j]
        R = rel(Mn, Ma)
        bg = cv2.warpAffine(ref, R, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        F = pf.frame_rgb(n)
        m = np.ones((H, W), bool); m[BAND[0]:BAND[1], :] = False
        a = (bg - WHITE)[m].ravel(); b = (F - WHITE)[m].ravel()
        s = float((a * b).sum() / (a * a).sum())
        bg2 = WHITE + s * (bg - WHITE)
        e = np.abs(bg2 - F).max(axis=2)
        eo = e[m]
        # gradient magnitude of the frame
        g = np.abs(cv2.Laplacian(cv2.cvtColor(F.astype(np.uint8), cv2.COLOR_RGB2GRAY), cv2.CV_32F))[m]
        cc = np.corrcoef(g, eo)[0, 1]
        print('anchor %d -> n=%4d %s: scale=%.4f  outband rms=%.2f p90=%.0f  corr(|lap|,err)=%.3f' %
              (anchor, n, pname[5:9], s, np.sqrt((eo ** 2).mean()), np.percentile(eo, 90), cc))
        tiles.append((n, e))

canvas = Image.new('L', (W, len(tiles) * (H // 3 + 4)), 0)
for i, (n, e) in enumerate(tiles):
    im = Image.fromarray(np.clip(e * 5, 0, 255).astype(np.uint8)).resize((W, H // 3), Image.LANCZOS)
    canvas.paste(im, (0, i * (H // 3 + 4)))
canvas.save(os.path.join(WS, 'diag_warp_err.png'))
print('saved')
