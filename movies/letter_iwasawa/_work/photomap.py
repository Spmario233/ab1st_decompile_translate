"""Estimate the 'memory filter' gain map A(x,y) such that frame = white + A*(plate - white)."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, yuv2rgb, load_png_rgb, ROOT
import platefit as pf

WHITE = 254.0
WS = os.path.dirname(os.path.abspath(__file__))
get_rgb = pf.frame_rgb

ANCH = {1049: 'eviw_0801.png', 1458: 'eviw_0301.png', 2042: 'eviw_0401.png', 2692: 'eviw_0701.png'}

maps = {}
for n, pl in ANCH.items():
    Mi, ninl_, ngo, mres = pf.fit(pl, n)
    print('  fit n=%d %s inl=%d good=%d medres=%.3f cover=%.3f' % (n, pl, ninl_, ngo, mres, pf.coverage(Mi)))
    plate = pf.plate(pl)
    P = cv2.warpAffine(plate, Mi, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
    F = get_rgb(n)
    num = F - WHITE
    den = P - WHITE
    ok = np.abs(den) > 60
    A = np.full((H, W, 3), np.nan, np.float32)
    A[ok] = (num[ok] / den[ok])
    maps[n] = A
    print('\n=== n=%d plate=%s  valid=%.3f' % (n, pl, ok.mean()))
    for c, nm in enumerate('RGB'):
        a = A[..., c][np.isfinite(A[..., c])]
        print('   %s median=%.4f  p10=%.4f p90=%.4f  iqr=%.4f' % (nm, np.median(a), *np.percentile(a, [10, 90]), np.percentile(a, 75) - np.percentile(a, 25)))
    # spatial structure: 12x18 grid of medians
    gm = np.zeros((12, 18, 3), np.float32)
    for by in range(12):
        for bx in range(18):
            blk = A[by*60:(by+1)*60, bx*71:(bx+1)*71]
            for c in range(3):
                v = blk[..., c][np.isfinite(blk[..., c])]
                gm[by, bx, c] = np.median(v) if v.size > 50 else np.nan
    print('   grid (R channel):')
    for by in range(0, 12, 2):
        print('     ' + ' '.join(('%.2f' % gm[by, bx, 0]) if np.isfinite(gm[by, bx, 0]) else ' -- ' for bx in range(0, 18, 2)))
    np.save(os.path.join(WS, 'gainmap_%d.npy' % n), A)

# compare maps at overlapping valid pixels
ks = sorted(maps)
for a in range(len(ks)):
    for b in range(a + 1, len(ks)):
        A1, A2 = maps[ks[a]], maps[ks[b]]
        m = np.isfinite(A1[..., 0]) & np.isfinite(A2[..., 0])
        if m.sum() < 1000:
            print('pair %d/%d too few (%d)' % (ks[a], ks[b], m.sum())); continue
        x, y = A1[..., 0][m], A2[..., 0][m]
        print('pair %d/%d  n=%d  corr=%.3f  ratio med=%.3f' % (ks[a], ks[b], m.sum(), np.corrcoef(x, y)[0, 1], np.median(y / np.maximum(x, 1e-6))))
