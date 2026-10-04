"""How do the raw_color plates relate to the video frames (geometry + photometry)?"""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, yuv2rgb, load_png_rgb, ROOT

def get_rgb(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE); buf = f.read(FSIZE)
    a = np.frombuffer(buf, np.uint8)
    y = a[:W*H].reshape(H, W); u = a[W*H:W*H*2].reshape(H, W); v = a[W*H*2:].reshape(H, W)
    return yuv2rgb(y, u, v)

def gray(a):
    return cv2.cvtColor(a.astype(np.uint8), cv2.COLOR_RGB2GRAY)

sift = cv2.SIFT_create(nfeatures=6000)
bf = cv2.BFMatcher()
SUB = (300, 500)

def match(srcg, dstg, mask_src=None, mask_dst=None):
    k1, d1 = sift.detectAndCompute(srcg, mask_src)
    k2, d2 = sift.detectAndCompute(dstg, mask_dst)
    if d1 is None or d2 is None or len(k1) < 5 or len(k2) < 5:
        return None, 0
    ms = bf.knnMatch(d1, d2, k=2)
    good = [m for m, q in ms if m.distance < 0.75 * q.distance]
    if len(good) < 10:
        return None, len(good)
    src = np.float32([k1[m.queryIdx].pt for m in good]).reshape(-1, 1, 2)
    dst = np.float32([k2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)
    M, inl = cv2.estimateAffinePartial2D(src, dst, method=cv2.RANSAC, ransacReprojThreshold=3.0, maxIters=8000, confidence=0.999)
    return (M, inl, src, dst, good), len(good)

ANCH = {1049: '001167.png', 1458: '001576.png', 2042: '002160.png', 2692: '002810.png'}
RAWS = sorted(os.listdir(os.path.join(ROOT, 'refrences', 'raw_color')))

mask_dst = np.full((H, W), 255, np.uint8); mask_dst[SUB[0]:SUB[1], :] = 0

for n, rf in ANCH.items():
    dstg = gray(get_rgb(n))
    print('\n=== video n=%d  (%s) ===' % (n, rf))
    for raw in RAWS:
        src = load_png_rgb(os.path.join(ROOT, 'refrences', 'raw_color', raw))
        r, ng = match(gray(src), dstg, None, mask_dst)
        if r is None:
            print('  %-16s no match (good=%d)' % (raw, ng)); continue
        M, inl, s, d, good = r
        sc = float(np.hypot(M[0, 0], M[1, 0])); rot = float(np.degrees(np.arctan2(M[1, 0], M[0, 0])))
        # how much of the video frame is covered by the warped raw image?
        corners = np.float32([[0, 0], [W, 0], [W, H], [0, H]]).reshape(-1, 1, 2)
        wc = cv2.transform(corners, M).reshape(-1, 2)
        cov = np.zeros((H, W), np.uint8); cv2.fillConvexPoly(cov, wc.astype(np.int32), 255)
        print('  %-16s good=%4d inl=%4d scale=%.4f rot=%+.3f deg  t=(%.1f,%.1f)  covers %.1f%%' %
              (raw, ng, int(inl.sum()), sc, rot, M[0, 2], M[1, 2], (cov > 0).mean() * 100))
