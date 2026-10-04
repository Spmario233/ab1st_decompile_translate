"""Full per-frame similarity fit of all four plates against every frame of the illustration segment."""
import os, sys, time
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
LO, HI = 860, 3360
PLATES = ['eviw_0801.png', 'eviw_0301.png', 'eviw_0401.png', 'eviw_0701.png']

sift = cv2.SIFT_create(nfeatures=2500)
bf = cv2.BFMatcher()
KP = {}
for p in PLATES:
    KP[p] = pf.plate_kp(p)
    print('plate', p, len(KP[p][0]), flush=True)

N = HI - LO + 1
M = np.zeros((N, 4, 2, 3), np.float32)
ninl = np.zeros((N, 4), np.int32)
ngood = np.zeros((N, 4), np.int32)
medres = np.zeros((N, 4), np.float32)

t0 = time.time()
with open(YUV, 'rb') as f:
    for i, n in enumerate(range(LO, HI + 1)):
        f.seek(n * FSIZE)
        y = np.frombuffer(f.read(W * H), np.uint8).reshape(H, W)
        k2, d2 = sift.detectAndCompute(y, None)
        for j, p in enumerate(PLATES):
            k1, d1 = KP[p]
            if d2 is None or len(k2) < 6:
                continue
            ms = bf.knnMatch(d1, d2, k=2)
            good = [m for m, q in ms if m.distance < 0.75 * q.distance]
            ngood[i, j] = len(good)
            if len(good) < 12:
                continue
            src = np.float32([k1[m.queryIdx].pt for m in good]).reshape(-1, 1, 2)
            dst = np.float32([k2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)
            A, inl = cv2.estimateAffinePartial2D(src, dst, method=cv2.RANSAC,
                                                 ransacReprojThreshold=2.0, maxIters=5000, confidence=0.999)
            if A is None:
                continue
            M[i, j] = A
            inl = inl.ravel() > 0
            ninl[i, j] = inl.sum()
            pr = cv2.transform(src, A).reshape(-1, 2)
            rr = np.linalg.norm(pr - dst.reshape(-1, 2), axis=1)
            medres[i, j] = np.median(rr[inl])
        if i % 250 == 0:
            print(i, n, '%.0fs' % (time.time() - t0), flush=True)

np.savez_compressed(os.path.join(WS, 'geo_full.npz'),
                    lo=LO, hi=HI, plates=np.array(PLATES), M=M, ninl=ninl, ngood=ngood, medres=medres)
print('done %.0fs' % (time.time() - t0))
