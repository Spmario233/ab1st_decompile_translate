"""Photometry: how does warp(raw_color plate) relate to the actual (filtered) video frame?"""
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

ANCH = [(1049, 'eviw_0801.png'), (1458, 'eviw_0301.png'), (2042, 'eviw_0401.png'), (2692, 'eviw_0701.png')]
WHITE = 254.0

def warp_plate(plate, M):
    return cv2.warpAffine(plate, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)

# transforms measured by SIFT (raw -> video frame)
MS = {}

def sift_M(plate, dstg):
    sift = cv2.SIFT_create(nfeatures=6000)
    k1, d1 = sift.detectAndCompute(cv2.cvtColor(plate.astype(np.uint8), cv2.COLOR_RGB2GRAY), None)
    k2, d2 = sift.detectAndCompute(dstg, None)
    bf = cv2.BFMatcher()
    ms = bf.knnMatch(d1, d2, k=2)
    good = [m for m, q in ms if m.distance < 0.75 * q.distance]
    src = np.float32([k1[m.queryIdx].pt for m in good]).reshape(-1, 1, 2)
    dst = np.float32([k2[m.trainIdx].pt for m in good]).reshape(-1, 1, 2)
    M, inl = cv2.estimateAffinePartial2D(src, dst, method=cv2.RANSAC, ransacReprojThreshold=3.0, maxIters=8000, confidence=0.999)
    return M, int(inl.sum())

for n, rf in ANCH:
    frame = get_rgb(n)
    plate = load_png_rgb(os.path.join(ROOT, 'refrences', 'raw_color', rf))
    M, ninl = sift_M(plate, cv2.cvtColor(frame.astype(np.uint8), cv2.COLOR_RGB2GRAY))
    # refine with ECC on luma
    Mg = M.copy()
    try:
        crit = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 300, 1e-7)
        cc, Mg = cv2.findTransformECC(cv2.cvtColor(frame.astype(np.uint8), cv2.COLOR_RGB2GRAY),
                                      cv2.cvtColor(plate.astype(np.uint8), cv2.COLOR_RGB2GRAY),
                                      Mg.astype(np.float32), cv2.MOTION_AFFINE, crit, None, 5)
    except cv2.error as e:
        print('ecc fail', e)
    P = warp_plate(plate, Mg)
    d = frame - P
    # only where plate is not near-white
    valid = (P.mean(axis=2) < 240) & (frame.mean(axis=2) < 252)
    # per-pixel gain toward white
    num = frame - WHITE
    den = P - WHITE
    with np.errstate(divide='ignore', invalid='ignore'):
        A = np.where(np.abs(den) > 40, num / den, np.nan)
    print('\n=== n=%d plate=%s  inliers=%d ===' % (n, rf, ninl))
    print('  M(refined) =', np.array2string(Mg, precision=5).replace('\n', '\n     '))
    print('  scale=%.5f rot=%+.4f deg' % (np.hypot(Mg[0,0],Mg[1,0]), np.degrees(np.arctan2(Mg[1,0],Mg[0,0]))))
    print('  frame vs warp(raw): mean|d|=%.2f  rms=%.2f  frac>5=%.3f  (valid %.3f)' %
          (np.abs(d).mean(), np.sqrt((d**2).mean()), (np.abs(d) > 5).mean(), valid.mean()))
    for c, nm in enumerate('RGB'):
        a = A[..., c][np.isfinite(A[..., c])]
        if a.size:
            print('    gain %s: n=%7d  p5=%.3f p25=%.3f med=%.3f p75=%.3f p95=%.3f' %
                  (nm, a.size, *np.percentile(a, [5, 25, 50, 75, 95])))
    np.save(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'M_anchor_%d.npy' % n), Mg)
