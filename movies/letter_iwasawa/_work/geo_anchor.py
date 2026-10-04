"""Anchor analysis: how do the 4 clean reference frames relate to the video frames?"""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, yuv2rgb, load_png_rgb, ROOT

def get_y(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE); buf = f.read(W * H)
    return np.frombuffer(buf, np.uint8).reshape(H, W).copy()

def get_rgb(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE); buf = f.read(FSIZE)
    a = np.frombuffer(buf, np.uint8)
    y = a[:W*H].reshape(H, W); u = a[W*H:W*H*2].reshape(H, W); v = a[W*H*2:].reshape(H, W)
    return yuv2rgb(y, u, v)

PAIRS = [(1049, '001167.png'), (1458, '001576.png'), (2042, '002160.png'), (2692, '002810.png')]
SUB = (300, 500)   # rows to mask out (subtitle band, generous)

sift = cv2.SIFT_create(nfeatures=4000)
bf = cv2.BFMatcher()

for n, rf in PAIRS:
    ref = load_png_rgb(os.path.join(ROOT, 'refrences', rf))
    refg = cv2.cvtColor(ref.astype(np.uint8), cv2.COLOR_RGB2GRAY)
    fr = get_rgb(n)
    frg = cv2.cvtColor(fr.astype(np.uint8), cv2.COLOR_RGB2GRAY)
    mask = np.full((H, W), 255, np.uint8); mask[SUB[0]:SUB[1], :] = 0
    k1, d1 = sift.detectAndCompute(refg, mask)
    k2, d2 = sift.detectAndCompute(frg, mask)
    ms = bf.knnMatch(d1, d2, k=2)
    good = [m for m, q in ms if m.distance < 0.75 * q.distance]
    src = np.float32([k1[m.queryIdx].pt for m in good]).reshape(-1, 1, 2)
    dst = np.float32([k2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)
    print('\n%s vs n=%d : kp %d/%d  good %d' % (rf, n, len(k1), len(k2), len(good)))
    for name, est in [('partial(sim)', cv2.estimateAffinePartial2D), ('affine', cv2.estimateAffine2D)]:
        if len(good) < 10:
            continue
        M, inl = est(src, dst, method=cv2.RANSAC, ransacReprojThreshold=3.0, maxIters=5000, confidence=0.999)
        if M is None:
            print('   ', name, 'failed'); continue
        # residual over inliers
        pr = cv2.transform(src, M).reshape(-1, 2)
        res = np.linalg.norm(pr - dst.reshape(-1, 2), axis=1)
        print('    %-12s inliers=%4d/%4d  medres=%.3f px  scale=%.5f rot=%.4f deg  tx=%.2f ty=%.2f' %
              (name, int(inl.sum()), len(good), np.median(res[inl.ravel() > 0]),
               np.hypot(M[0, 0], M[1, 0]), np.degrees(np.arctan2(M[1, 0], M[0, 0])), M[0, 2], M[1, 2]))
        print('       M =', np.array2string(M, precision=6, suppress_small=False).replace('\n', '\n           '))
