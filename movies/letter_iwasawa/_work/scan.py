"""Pass 1: cheap per-frame statistics over the whole decode.

Writes  _work/scan.npz :
   meanY, meanU, meanV      (N,)       frame means
   whitefrac                (N,)       fraction of pixels with Y>=250
   rowmeanY                 (N,720)    per-row mean luma
   rowdark                  (N,720)    per-row count of Y<200  (text detector)
   coldark                  (N,1280)   per-column count of Y<200
   rowdev                   (N,720)    per-row max|Y - rowmedian|  (structure detector)
"""
import os, sys, time
import numpy as np
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, NFRAMES

N = NFRAMES
meanY = np.zeros(N, np.float32); meanU = np.zeros(N, np.float32); meanV = np.zeros(N, np.float32)
whitefrac = np.zeros(N, np.float32)
rowmeanY = np.zeros((N, H), np.float32)
rowdark = np.zeros((N, H), np.int16)
coldark = np.zeros((N, W), np.int16)

t0 = time.time()
with open(YUV, 'rb') as f:
    for n in range(N):
        buf = f.read(FSIZE)
        if len(buf) != FSIZE:
            print('short read at', n); break
        a = np.frombuffer(buf, np.uint8)
        y = a[:W * H].reshape(H, W)
        u = a[W * H:W * H * 2].reshape(H, W)
        v = a[W * H * 2:].reshape(H, W)
        meanY[n] = y.mean(); meanU[n] = u.mean(); meanV[n] = v.mean()
        whitefrac[n] = (y >= 250).mean()
        rowmeanY[n] = y.mean(axis=1)
        d = (y < 200)
        rowdark[n] = d.sum(axis=1)
        coldark[n] = d.sum(axis=0)
        if n % 400 == 0:
            print(n, '%.1fs' % (time.time() - t0), flush=True)

np.savez_compressed(os.path.join(os.path.dirname(YUV), 'scan.npz'),
                    meanY=meanY, meanU=meanU, meanV=meanV, whitefrac=whitefrac,
                    rowmeanY=rowmeanY, rowdark=rowdark, coldark=coldark)
print('done %.1fs' % (time.time() - t0))
