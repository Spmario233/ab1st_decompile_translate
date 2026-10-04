"""Is the memory-filter gain screen-space static, plate-space static, or time varying?

Within one plate's display period the camera moves a lot, which lets us separate
a screen-fixed gain from a plate-fixed gain.
"""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import platefit as pf

WHITE = 254.0
WS = os.path.dirname(os.path.abspath(__file__))
BAND = (300, 500)   # rows to exclude (subtitle band)

PLATE = 'eviw_0801.png'
NS = [920, 1000, 1100, 1200, 1300, 1400]

def gain_screen(n, plate, M):
    F = pf.frame_rgb(n)
    P = cv2.warpAffine(plate, M, (1280, 720), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
    den = P - WHITE
    num = F - WHITE
    A = np.full((720, 1280, 3), np.nan, np.float32)
    ok = np.abs(den) > 70
    ok[BAND[0]:BAND[1], :] = False
    A[ok] = num[ok] / den[ok]
    return A, P, F

pl = pf.plate(PLATE)
res = {}
for n in NS:
    M, ni, ng, mr = pf.fit(PLATE, n)
    A, P, F = gain_screen(n, pl, M)
    res[n] = (A, M)
    sc = np.hypot(M[0, 0], M[1, 0]); rot = np.degrees(np.arctan2(M[1, 0], M[0, 0]))
    good = np.isfinite(A[..., 0])
    print('n=%4d inl=%4d scale=%.4f rot=%+.3f  t=(%.1f,%.1f)  valid=%.3f  medA=%.3f' %
          (n, ni, sc, rot, M[0, 2], M[1, 2], good.mean(), np.nanmedian(A[..., 0])))

def cmp(a, b, warp_b_to_a=None):
    A1 = res[a][0][..., 0]; A2 = res[b][0][..., 0]
    if warp_b_to_a is not None:
        A2w = cv2.warpAffine(np.nan_to_num(A2), warp_b_to_a, (1280, 720), flags=cv2.INTER_LINEAR)
        m = np.isfinite(A1) & (cv2.warpAffine(np.isfinite(A2).astype(np.uint8), warp_b_to_a, (1280, 720)) > 0)
        A2 = A2w
    else:
        m = np.isfinite(A1) & np.isfinite(A2)
    x = A1[m]; y = A2[m]
    print('   screen-space %4d vs %4d: n=%7d corr=%.3f  med(y/x)=%.3f  med|y-x|=%.3f' %
          (a, b, m.sum(), np.corrcoef(x, y)[0, 1], np.median(y / np.maximum(x, 1e-3)), np.median(np.abs(y - x))))

print('\n-- screen-space comparison (subtract subtitle band) --')
for i in range(len(NS)):
    for j in range(i + 1, len(NS)):
        cmp(NS[i], NS[j])

# plate-space comparison: express A in plate coordinates
print('\n-- plate-space comparison --')
def gain_plate(n):
    A, M = res[n]
    Minv = cv2.invertAffineTransform(M)
    Ap = cv2.warpAffine(np.nan_to_num(A[..., 0], nan=-1), Minv, (1280, 720), flags=cv2.INTER_NEAREST)
    return Ap
for i in range(len(NS)):
    for j in range(i + 1, len(NS)):
        Ap1 = gain_plate(NS[i]); Ap2 = gain_plate(NS[j])
        m = (Ap1 > -0.5) & (Ap2 > -0.5)
        x = Ap1[m]; y = Ap2[m]
        print('   plate-space %4d vs %4d: n=%7d corr=%.3f  med|y-x|=%.3f' %
              (NS[i], NS[j], m.sum(), np.corrcoef(x, y)[0, 1], np.median(np.abs(y - x))))
