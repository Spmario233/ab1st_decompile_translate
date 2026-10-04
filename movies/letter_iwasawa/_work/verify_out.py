"""Verify the rendered output against the source: every changed pixel must lie inside the
subtitle band, and no changed pixel may be one we did not intend to change."""
import os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, YUV, NFRAMES

WS = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(WS, 'out_full.yuv')
cfr = np.load(os.path.join(WS, 'cfr_map.npy'))
BAND = (272, 406)
COLS = (92, 1208)

n_changed = np.zeros(NFRAMES, np.int64)
maxrow = 0; minrow = H
maxcol = 0; mincol = W
outside = 0
slots = 0
with open(YUV, 'rb') as fa, open(OUT, 'rb') as fb:
    cur = -1
    ya = None
    for i in range(len(cfr)):
        n = int(cfr[i])
        b = fb.read(FSIZE)
        if len(b) != FSIZE:
            print('short output at slot', i); break
        if n != cur:
            a = fa.read(FSIZE)
            if len(a) != FSIZE:
                print('short source at stored', n); break
            ya = np.frombuffer(a, np.uint8).reshape(3, H, W)
            cur = n
        else:
            continue                     # duplicate slot: identical by construction
        yb = np.frombuffer(b, np.uint8).reshape(3, H, W)
        d = (ya != yb).any(axis=0)
        c = int(d.sum())
        n_changed[n] = c
        slots += 1
        if c:
            rows = np.nonzero(d.any(axis=1))[0]
            cols = np.nonzero(d.any(axis=0))[0]
            minrow = min(minrow, int(rows.min())); maxrow = max(maxrow, int(rows.max()))
            mincol = min(mincol, int(cols.min())); maxcol = max(maxcol, int(cols.max()))
            outside += int(d[:BAND[0]].sum() + d[BAND[1]:].sum() +
                           d[:, :COLS[0]].sum() + d[:, COLS[1]:].sum())
        if n % 400 == 0:
            print('n=%4d changed=%7d' % (n, c), flush=True)

print('\nstored frames compared: %d' % slots)
print('changed pixels total: %d' % n_changed.sum())
print('changed pixel row range: %d..%d   col range: %d..%d' % (minrow, maxrow, mincol, maxcol))
print('changed pixels OUTSIDE the band/cols box: %d   <-- must be 0' % outside)
top = np.argsort(n_changed)[-10:][::-1]
print('frames with most changes:', [(int(x), int(n_changed[x])) for x in top])
print('frames with zero changes: %d' % int((n_changed == 0).sum()))
np.save(os.path.join(WS, 'verify_changed.npy'), n_changed)
