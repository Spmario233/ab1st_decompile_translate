"""Build the CFR (30 fps) expansion of the source: which stored frame is shown in each slot."""
import os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

WS = os.path.dirname(os.path.abspath(__file__))
pts = np.loadtxt(os.path.join(WS, 'pts.txt'))
slot = np.rint(pts * 30).astype(np.int64)
assert len(np.unique(slot)) == len(slot), 'slot collision'
N = int(slot.max()) + 1
n = np.zeros(N, np.int32)
cur = 0
si = 0
for i in range(N):
    if si < len(slot) and slot[si] == i:
        cur = si
        si += 1
    n[i] = cur
np.save(os.path.join(WS, 'cfr_map.npy'), n)
print('slots', N, 'stored', len(pts), 'duplicate slots', N - len(pts))
for s in (0, 64, 65, 835, 836, 873, 874, 3317, 3318, 3441):
    i = np.nonzero(n == s)[0]
    if len(i):
        print('  stored %4d -> slots %d..%d  t=%.3f..%.3f' % (s, i.min(), i.max(), i.min() / 30, i.max() / 30))
