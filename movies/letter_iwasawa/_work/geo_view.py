import numpy as np, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
WS = os.path.dirname(os.path.abspath(__file__))
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo, hi = int(d['lo']), int(d['hi'])
plates = [str(x) for x in d['plates']]
M, ninl, ng, mr = d['M'], d['ninl'], d['ngood'], d['medres']
N = M.shape[0]
print('frames %d..%d  plates %s' % (lo, hi, plates))
print('%5s | %s' % ('n', ' '.join('%-22s' % p[5:9] for p in plates)))
for i in range(0, N, 10):
    parts = []
    for j in range(4):
        A = M[i, j]
        if ninl[i, j] < 20:
            parts.append('%4d ----            ' % ninl[i, j])
            continue
        sc = float(np.hypot(A[0, 0], A[1, 0])); rot = float(np.degrees(np.arctan2(A[1, 0], A[0, 0])))
        parts.append('%4d %5.3f %+6.2f %6.1f%6.1f' % (ninl[i, j], sc, rot, A[0, 2], A[1, 2]))
    print('%5d | %s' % (lo + i, ' | '.join(parts)))
