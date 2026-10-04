"""Look at the raw SIFT fits for the incoming plate during the two dissolves."""
import os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from mosaic_build import sim_params

WS = os.path.dirname(os.path.abspath(__file__))
d = np.load(os.path.join(WS, 'geo_full.npz'))
lo, hi = int(d['lo']), int(d['hi'])
plates = [str(x) for x in d['plates']]
M = d['M']; ninl = d['ninl']; medres = d['medres']
print('geo_full frames %d..%d, plates %s' % (lo, hi, [p[5:9] for p in plates]))
t = np.arange(lo, hi + 1)


def show(pname, a, b, step=5):
    j = plates.index(pname)
    print('\n--- %s  frames %d..%d ---' % (pname[5:9], a, b))
    print('    n   ninl   medres   scale    rot(deg)     tx       ty')
    for n in range(a, b + 1, step):
        i = n - lo
        p = sim_params(M[i, j]) if np.isfinite(M[i, j, 0, 0]) else [np.nan] * 4
        print('  %5d  %4d  %7.3f  %7.4f  %8.3f  %8.2f %8.2f' %
              (n, ninl[i, j], medres[i, j], p[0], np.degrees(p[1]), p[2], p[3]))


show('eviw_0401.png', 1930, 2000, 5)
show('eviw_0301.png', 1360, 1435, 5)
show('eviw_0801.png', 1400, 1470, 5)
show('eviw_0301.png', 1985, 2035, 5)
