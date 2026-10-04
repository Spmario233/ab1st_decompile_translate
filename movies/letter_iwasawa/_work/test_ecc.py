"""Does ECC refinement of the per-frame transform reduce the reconstruction error?"""
import os, sys, time
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf
import render_full as rf
from Rfit import estimate_R

WHITE = 254.0
xa = rf.compute_xalpha()
traj, mos, sky, sp = rf.assets()
BAND = rf.BAND_ROWS

for n, pname, refname in [(2042, 'eviw_0401.png', '002160.png'), (1458, 'eviw_0301.png', '001576.png'),
                          (1049, 'eviw_0801.png', '001167.png'), (2692, 'eviw_0701.png', '002810.png')]:
    den = rf.den_for(n, rf.terms_for(n, xa), traj, mos)
    F = pf.frame_rgb(n)
    R = estimate_R(F, den)
    bg = WHITE + R * den
    ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname))
    e0 = np.abs(bg - ref).max(axis=2)
    print('n=%4d base rms=%.2f' % (n, np.sqrt(((bg - ref) ** 2).mean())))
    Mi = rf.M_of(traj, pname, n)
    mask = np.full((H, W), 255, np.uint8); mask[BAND[0]:BAND[1], :] = 0
    t0 = time.time()
    crit = (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 200, 1e-7)
    try:
        cc, Wm = cv2.findTransformECC(cv2.cvtColor(bg.astype(np.uint8), cv2.COLOR_RGB2GRAY),
                                      cv2.cvtColor(F.astype(np.uint8), cv2.COLOR_RGB2GRAY),
                                      Mi.astype(np.float32), cv2.MOTION_AFFINE, crit, mask, 5)
    except cv2.error as ex:
        print('   ECC failed', ex); continue
    cc2, Wm2 = cv2.findTransformECC(cv2.cvtColor(bg.astype(np.uint8), cv2.COLOR_RGB2GRAY),
                                    cv2.cvtColor(F.astype(np.uint8), cv2.COLOR_RGB2GRAY),
                                    Mi.astype(np.float32), cv2.MOTION_AFFINE,
                                    (cv2.TERM_CRITERIA_EPS | cv2.TERM_CRITERIA_COUNT, 100, 1e-9), mask, 7)
    Mnew = (np.vstack([Wm, [0, 0, 1]]) @ np.vstack([Mi, [0, 0, 1]]))[:2].astype(np.float32)
    print('   ecc cc=%.5f dt=%.2fs  shift dx=%.3f dy=%.3f dscale=%.5f drot=%.4f deg' %
          (cc, time.time() - t0, Wm2[0, 2], Wm2[1, 2],
           np.hypot(Wm2[0, 0], Wm2[1, 0]) - 1, np.degrees(np.arctan2(Wm2[1, 0], Wm2[0, 0])) * 0 + 0))
    # rebuild with the refined transform
    d2 = rf.den_for(n, [(pname, 1.0)], traj, mos)  # placeholder, replaced below
    Mref = Mnew
    tt, P = traj[pname]
    from mosaic_build import sim_from_params
    den2 = cv2.warpAffine(mos[pname], Mref, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE
    R2 = estimate_R(F, den2)
    bg2 = WHITE + R2 * den2
    e1 = np.abs(bg2 - ref).max(axis=2)
    print('   refined rms=%.2f  (band rms %.2f -> %.2f)' %
          (np.sqrt(((bg2 - ref) ** 2).mean()),
           np.sqrt((e0[BAND[0]:BAND[1]] ** 2).mean()), np.sqrt((e1[BAND[0]:BAND[1]] ** 2).mean())))
