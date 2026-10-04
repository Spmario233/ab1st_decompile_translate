import os, sys
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, yuv2rgb
WS = os.path.dirname(os.path.abspath(__file__))

def frame(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE); b = f.read(FSIZE)
    a = np.frombuffer(b, np.uint8)
    return (a[:W*H].reshape(H, W), a[W*H:W*H*2].reshape(H, W), a[W*H*2:].reshape(H, W))

y, u, v = frame(0)
print('frame0 unique Y', np.unique(y)[:8], 'unique U', np.unique(u)[:8], 'unique V', np.unique(v)[:8])
print('frame0 all-white?', (y == 254).all(), (u == 128).all(), (v == 128).all())
for n in (5, 40, 62, 64, 66, 70, 3400, 3441):
    y, u, v = frame(n)
    print('n=%4d  Ymin=%3d Ymax=%3d meanY=%7.3f  frac(Y!=254)=%.5f  fracU!=128=%.5f' %
          (n, y.min(), y.max(), y.mean(), (y != 254).mean(), (u != 128).mean()))

print('\n-- boundary scan start --')
for n in range(55, 120):
    y, u, v = frame(n)
    wh = (y >= 254).mean()
    print('n=%3d t=%.3f meanY=%7.3f fracY254=%.4f' % (n, n/30, y.mean(), wh))
