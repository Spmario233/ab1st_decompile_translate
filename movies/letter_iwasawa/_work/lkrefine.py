"""Cheap Lucas-Kanade refinement of the per-frame similarity transform."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H

WHITE = 254.0


def luma(a):
    return (0.299 * a[..., 0] + 0.587 * a[..., 1] + 0.114 * a[..., 2]).astype(np.float32)


def refine_sim(F, bg, rows=(250, 560), iters=4, tau=12.0, ds_factor=1):
    """Return a 2x3 similarity T (screen->screen) such that bg(T^-1(.)) matches F."""
    y0, y1 = rows
    sc = 1.0 / ds_factor
    Fg = luma(F[y0:y1])[::ds_factor, ::ds_factor]
    g = luma(bg[y0:y1])[::ds_factor, ::ds_factor]
    hh, ww = Fg.shape
    X = (np.arange(ww, dtype=np.float32) * ds_factor + 0) - W / 2.0
    Y = (np.arange(hh, dtype=np.float32) * ds_factor + y0) - H / 2.0
    Xg = X[None, :]; Yg = Y[:, None]
    p = np.zeros(4, np.float64)   # tx, ty, ds, dth
    T = np.eye(3, dtype=np.float64)
    for _ in range(iters):
        gx = cv2.Sobel(g, cv2.CV_32F, 1, 0, ksize=3)
        gy = cv2.Sobel(g, cv2.CV_32F, 0, 1, ksize=3)
        r = Fg - g
        J = np.stack([gx, gy, gx * Xg + gy * Yg, -gx * Yg + gy * Xg], axis=0).reshape(4, -1)
        rr = r.reshape(-1)
        w = (1.0 / (1.0 + (rr / tau) ** 2)).astype(np.float64)
        A = (J * w) @ J.T
        b = (J * w) @ rr.astype(np.float64)
        try:
            dp = -np.linalg.solve(A + np.eye(4) * 1e-6, b)
        except np.linalg.LinAlgError:
            break
        dp = np.clip(dp, [-4, -4, -0.02, -0.02], [4, 4, 0.02, 0.02])
        p += dp
        # apply dp to bg for the next iteration by remapping
        c, s = np.cos(dp[3]), np.sin(dp[3])
        a11 = 1 + dp[2]; 
        M = np.array([[a11 * c, -a11 * s, dp[0]], [a11 * s, a11 * c, dp[1]]], np.float32)
        # warp about the centre
        C = np.array([[1, 0, W / 2], [0, 1, H / 2], [0, 0, 1]], np.float64)
        Ci = np.array([[1, 0, -W / 2], [0, 1, -H / 2], [0, 0, 1]], np.float64)
        Tk = C @ np.vstack([M, [0, 0, 1]]) @ Ci
        T = Tk @ T
        g = cv2.warpAffine(g, M, (ww, hh), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        if np.abs(dp).max() < 1e-4:
            break
    return T[:2].astype(np.float32), p


def compose(T, M):
    return (np.vstack([T, [0, 0, 1]]) @ np.vstack([M, [0, 0, 1]]))[:2].astype(np.float32)
