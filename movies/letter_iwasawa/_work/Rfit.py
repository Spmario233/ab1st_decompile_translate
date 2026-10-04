"""Multi-scale normalised-box estimate of the smooth screen gain field R."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf

WHITE = 254.0
RADII = (8, 24, 72, 200)
CONF = (0.30, 0.30)


def normbox(A, M, r):
    k = (2 * r + 1, 2 * r + 1)
    num = cv2.boxFilter(A * M, -1, k, normalize=False, borderType=cv2.BORDER_REPLICATE)
    den = cv2.boxFilter(M, -1, k, normalize=False, borderType=cv2.BORDER_REPLICATE)
    return num / np.maximum(den, 1e-9), den / float((2 * r + 1) ** 2)


def estimate_R(F, den, thr=30.0):
    out = np.zeros((H, W, 3), np.float32)
    gmean = float(np.nanmedian(F))
    for c in range(3):
        v = (np.abs(den[..., c]) > thr).astype(np.float32)
        R = np.where(v > 0, (F[..., c] - WHITE) / np.where(v > 0, den[..., c], 1.0), 0.0).astype(np.float32)
        keep = v.copy()
        for _ in range(3):
            Rs, cnf = normbox(R, keep, RADII[0])
            resid = R - Rs
            keep = v * ((resid < 0.08) & (resid > -0.12)).astype(np.float32)
        Rf = None
        for r in RADII:
            Rr, cr = normbox(R, keep, r)
            if Rf is None:
                Rf = np.where(cr > 0.30, Rr, np.nan)
            else:
                Rf = np.where(np.isfinite(Rf), Rf, np.where(cr > 0.05, Rr, np.nan))
        # anything still unfilled: fall back to the mean gain implied by the frame mean
        if not np.isfinite(Rf).all():
            gm = 1.0
            if np.abs(den[..., c]).max() > 0:
                m = np.abs(den[..., c]) > thr
                if m.any():
                    gm = float(np.median((F[..., c] - WHITE)[m] / den[..., c][m]))
            Rf = np.where(np.isfinite(Rf), Rf, gm)
        out[..., c] = Rf
    return out


if __name__ == '__main__':
    import render_full as rf
    from iwlib import ROOT
    xa = rf.compute_xalpha()
    traj, mos, sky, sp = rf.assets()
    for n, pname, refname in [(1049, 'eviw_0801.png', '001167.png'), (1458, 'eviw_0301.png', '001576.png'),
                              (2042, 'eviw_0401.png', '002160.png'), (2692, 'eviw_0701.png', '002810.png')]:
        den = rf.den_for(n, rf.terms_for(n, xa), traj, mos)
        F = pf.frame_rgb(n)
        R = estimate_R(F, den)
        bg = WHITE + R * den
        ref = pf.load_png_rgb(os.path.join(ROOT, 'refrences', refname))
        e = np.abs(bg - ref).max(axis=2)
        print('n=%4d %s  all rms=%.2f p95=%.0f  | R p5=%.3f med=%.3f p95=%.3f' %
              (n, pname[5:9], np.sqrt(((bg - ref) ** 2).mean()), np.percentile(e, 95),
               *np.percentile(R[..., 0], [5, 50, 95])))
