"""Build full-resolution gain maps and synthesise backgrounds."""
import os, sys
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, ROOT
import platefit as pf

WS = os.path.dirname(os.path.abspath(__file__))
DS = 4
HH, WW = H // DS, W // DS
WHITE = 254.0

PLATES = ['eviw_0801.png', 'eviw_0301.png', 'eviw_0401.png', 'eviw_0701.png']
SHORT = {p: p[5:9] for p in PLATES}

_gain_cache = {}


def _fill_nan(A):
    """Iterative neighbour-mean fill of NaN holes (per channel)."""
    A = A.copy()
    for _ in range(60):
        m = ~np.isfinite(A)
        if not m.any():
            break
        V = np.where(m, 0.0, A)
        C = (~m).astype(np.float32)
        k = np.ones((3, 3), np.float32)
        s = cv2.filter2D(V, -1, k, borderType=cv2.BORDER_REPLICATE)
        c = cv2.filter2D(C, -1, k, borderType=cv2.BORDER_REPLICATE)
        with np.errstate(invalid='ignore', divide='ignore'):
            fill = np.where(c > 0, s / np.maximum(c, 1e-6), 0.0)
        A = np.where(m, fill, A)
    return A


def load_gain(pname, sigma=2.0, ds=DS):
    key = (pname, sigma, ds)
    if key in _gain_cache:
        return _gain_cache[key]
    if ds == DS:
        A = np.load(os.path.join(WS, 'gainA_%s.npy' % SHORT[pname]))
    else:
        A = np.load(os.path.join(WS, 'gainA%d_%s.npy' % (ds, SHORT[pname])))
    A = np.stack([_fill_nan(A[..., c]) for c in range(3)], axis=2)
    if sigma > 0:
        A = cv2.GaussianBlur(A, (0, 0), sigma, borderType=cv2.BORDER_REPLICATE)
    if ds != DS:
        A = cv2.resize(A, (W, H), interpolation=cv2.INTER_CUBIC)
    _gain_cache[key] = A
    return A


def gain_full(pname, **kw):
    """Full-resolution 720x1280x3 gain map."""
    A = load_gain(pname, **kw)
    if A.shape[0] != H:
        A = cv2.resize(A, (W, H), interpolation=cv2.INTER_CUBIC)
    return A


def den_of(pname, M):
    plate = pf.plate(pname)
    P = cv2.warpAffine(plate, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
    return P - WHITE


def background(terms, gains=None):
    """terms: list of (pname, M, weight). Returns float32 RGB background."""
    acc = np.zeros((H, W, 3), np.float32)
    for pname, M, w in terms:
        acc += (w if w is not None else 1.0) * den_of(pname, M)
    if gains is None:
        gains = {p: gain_full(p) for p, _, _ in terms}
    g = np.zeros((H, W, 3), np.float32)
    tot = 0.0
    for pname, M, w in terms:
        ww = 1.0 if w is None else w
        g += ww * gains[pname]
        tot += ww
    if tot > 0:
        g /= tot
    return WHITE + g * acc
