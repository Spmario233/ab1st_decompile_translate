"""Visualise the subtitle presence as a space-time diagram (rows vs frames)."""
import os, sys
import numpy as np
from PIL import Image
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

d = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'submask_ill.npz'))
rows = d['rows'].astype(np.float32)   # (N,720)
lo, hi = int(d['lo']), int(d['hi'])
print(rows.shape, lo, hi)
# column-block max so the image is writable
B = 6
NB = rows.shape[0] // B
blk = rows[:NB * B].reshape(NB, B, 720).max(axis=1)     # (NB,720)
img = np.clip(blk.T * 12, 0, 255).astype(np.uint8)      # 720 x NB
Image.fromarray(img).resize((NB * 2, 720), Image.NEAREST).save(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), 'diag_subspanetime.png'))

# row occupancy: fraction of frames with >=3 text pixels
occ = (rows >= 3).mean(axis=0)
for r0 in range(280, 520, 4):
    seg = occ[r0:r0 + 4].max()
    print('%4d %.3f %s' % (r0, seg, '#' * int(seg * 100)))
