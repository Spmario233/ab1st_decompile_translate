"""Sweep: match every 5th frame of the illustration segment against all four raw plates.

Saves _work/geo_sweep.npz with, for each sampled frame and each plate:
  M (2x3), ninl, ngood, medres, cover
"""
import os, sys, time
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, yuv2rgb, load_png_rgb, ROOT

STEP = 5
LO, HI = 860, 3360
PLATES = ['eviw_0801.png', 'eviw_0301.png', 'eviw_0401.png', 'eviw_0701.png']

sift = cv2.SIFT_create(nfeatures=2500)
bf = cv2.BFMatcher()
kp = {}
des = {}
for p in PLATES:
    im = load_png_rgb(os.path.join(ROOT, 'refrences', 'raw_color', p))
    k, d = sift.detectAndCompute(cv2.cvtColor(im.astype(np.uint8), cv2.COLOR_RGB2GRAY), None)
    kp[p], des[p] = k, d
    print('plate', p, len(k), flush=True)

frames = list(range(LO, HI + 1, STEP))
NF = len(frames)
M = np.zeros((NF, len(PLATES), 2, 3), np.float32)
ninl = np.zeros((NF, len(PLATES)), np.int32)
ngood = np.zeros((NF, len(PLATES)), np.int32)
medres = np.zeros((NF, len(PLATES)), np.float32)

t0 = time.time()
with open(YUV, 'rb') as f:
    for i, n in enumerate(frames):
        f.seek(n * FSIZE); buf = f.read(W * H)
        y = np.frombuffer(buf, np.uint8).reshape(H, W)
        k2, d2 = sift.detectAndCompute(y, None)
        for j, p in enumerate(PLATES):
            if d2 is None or len(k2) < 5:
                continue
            ms = bf.knnMatch(des[p], d2, k=2)
            good = [m for m, q in ms if m.distance < 0.75 * q.distance]
            ngood[i, j] = len(good)
            if len(good) < 12:
                continue
            src = np.float32([kp[p][m.queryIdx].pt for m in good]).reshape(-1, 1, 2)
            dst = np.float32([k2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)
            A, inl = cv2.estimateAffinePartial2D(src, dst, method=cv2.RANSAC,
                                                 ransacReprojThreshold=2.5, maxIters=5000, confidence=0.999)
            if A is None:
                continue
            M[i, j] = A
            inl = inl.ravel() > 0
            ninl[i, j] = inl.sum()
            pr = cv2.transform(src, A).reshape(-1, 2)
            rr = np.linalg.norm(pr - dst.reshape(-1, 2), axis=1)
            medres[i, j] = np.median(rr[inl])
        if i % 50 == 0:
            print(i, n, '%.0fs' % (time.time() - t0), flush=True)

np.savez_compressed(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'geo_sweep.npz'),
                    frames=np.array(frames), plates=np.array(PLATES), M=M, ninl=ninl, ngood=ngood, medres=medres)
print('done %.0fs' % (time.time() - t0))
