"""Similarity-transform fitting between a raw_color plate and a video frame."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import YUV, W, H, FSIZE, yuv2rgb, load_png_rgb, ROOT

_sift = cv2.SIFT_create(nfeatures=4000)
_bf = cv2.BFMatcher()
_cache = {}


def plate(name):
    if name not in _cache:
        _cache[name] = load_png_rgb(os.path.join(ROOT, 'refrences', 'raw_color', name))
    return _cache[name]


def plate_kp(name):
    key = 'kp:' + name
    if key not in _cache:
        _cache[key] = _sift.detectAndCompute(cv2.cvtColor(plate(name).astype(np.uint8), cv2.COLOR_RGB2GRAY), None)
    return _cache[key]


def frame_gray(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE); buf = f.read(W * H)
    return np.frombuffer(buf, np.uint8).reshape(H, W).copy()


def frame_rgb(n):
    with open(YUV, 'rb') as f:
        f.seek(n * FSIZE); buf = f.read(FSIZE)
    a = np.frombuffer(buf, np.uint8)
    y = a[:W*H].reshape(H, W); u = a[W*H:W*H*2].reshape(H, W); v = a[W*H*2:].reshape(H, W)
    return yuv2rgb(y, u, v)


def fit(name, n, mask_dst=None, nfeat=2500):
    """Return (M 2x3 float32 similarity mapping plate->frame, ninl, ngood, medres_px)."""
    k1, d1 = plate_kp(name)
    s2 = cv2.SIFT_create(nfeatures=nfeat)
    g = frame_gray(n)
    k2, d2 = s2.detectAndCompute(g, mask_dst)
    if d2 is None or len(k2) < 6:
        return None, 0, 0, 0.0
    ms = _bf.knnMatch(d1, d2, k=2)
    good = [m for m, q in ms if m.distance < 0.75 * q.distance]
    if len(good) < 12:
        return None, 0, len(good), 0.0
    src = np.float32([k1[m.queryIdx].pt for m in good]).reshape(-1, 1, 2)
    dst = np.float32([k2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)
    A, inl = cv2.estimateAffinePartial2D(src, dst, method=cv2.RANSAC,
                                         ransacReprojThreshold=2.0, maxIters=5000, confidence=0.999)
    if A is None:
        return None, 0, len(good), 0.0
    inl = inl.ravel() > 0
    pr = cv2.transform(src, A).reshape(-1, 2)
    rr = np.linalg.norm(pr - dst.reshape(-1, 2), axis=1)
    return A.astype(np.float32), int(inl.sum()), len(good), float(np.median(rr[inl]))


def coverage(M, w=W, h=H):
    c = np.float32([[0, 0], [w, 0], [w, h], [0, h]]).reshape(-1, 1, 2)
    wc = cv2.transform(c, M).reshape(-1, 2)
    m = np.zeros((h, w), np.uint8)
    cv2.fillConvexPoly(m, wc.astype(np.int32), 255)
    return (m > 0).mean()
