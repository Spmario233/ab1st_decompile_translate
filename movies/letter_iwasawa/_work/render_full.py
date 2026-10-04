"""Render the subtitle-free version of letter_iwasawa.

Model per frame:
    bg0   = white + sum_k w_k * (mosaic_k warped to screen - white)      (illustration)
          = white + gamma * (sky mosaic crop - white)                     (sky)
          = white                                                         (white segments)
    F - white ~= R(x,y) * (bg0 - white)          R: smooth screen-space field
    out = where(subtitle_mask, white + R*(bg0 - white), F)
"""
import os, sys, time, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H, FSIZE, YUV, NFRAMES, yuv2rgb, rgb2yuv, load_png_rgb, ROOT
import platefit as pf
from mosaic_build import sim_from_params, PLATES

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0

SKY_LO, SKY_HI = 65, 835
ILL_LO, ILL_HI = 874, 3317
# true dissolve ranges measured with xfade_fit2.py (independent scale per plate)
XFADE = {
    'a': ('eviw_0801.png', 'eviw_0301.png', 1374, 1462),
    'b': ('eviw_0301.png', 'eviw_0401.png', 1943, 2026),
    'c': ('eviw_0401.png', 'eviw_0701.png', 2515, 2615),   # untouched this round
}
# windows that additionally get the "fit the model to the clean pixels inside the box"
# correction (see fix_box).  Only the two transitions the user flagged.
FIX_WINDOWS = ((XFADE['a'][2], XFADE['a'][3]), (XFADE['b'][2], XFADE['b'][3]))
FIX_SIGMA = 12.0        # smoothing of the additive box correction, px
FIX_SUB_THR = 12.0      # |F - anchor background| above this counts as subtitle (not fitted)
ANCHOR = {'eviw_0801.png': ('001167.png', 1049), 'eviw_0301.png': ('001842.png', 1724),
          'eviw_0401.png': ('002160.png', 2042), 'eviw_0701.png': ('002810.png', 2692)}
ORDER = ['eviw_0801.png', 'eviw_0301.png', 'eviw_0401.png', 'eviw_0701.png']
# The subtitle never leaves these boxes (measured with band_bbox.py / measure_band3.py).
# Everything outside keeps the original video bytes.  Inside, the box is re-rendered
# unconditionally (no "does this frame carry a subtitle" test), because the subtitle fades
# in and out and a threshold always leaves faint residue on the fade frames.
BAND_COLS = (92, 1208)
BAND_ROWS_ILL = (318, 404)      # measured subtitle rows 333..388
BAND_ROWS_SKY = (318, 404)      # measured 334..386
BAND_ROWS_WHITE = (272, 406)    # white: head 339..378, tail 291..328 and 344..382
FEATHER = 4                     # px ramp at the box border, to avoid a visible seam
# Dissolve a carries a much shorter subtitle line (measured cols 360..916, rows 335..382 by
# win_bbox.py).  Using the full-width box there repaints a lot of untouched artwork on the
# left, which reads as a glow.
WIN_A_BOX = (322, 398, 342, 938)
R_DS = 2
R_SIGMA = 8.0
MASK_THR = 20
MASK_DILATE = 7

_A = {}


def assets():
    if 'traj' not in _A:
        with open(os.path.join(WS, 'traj_smooth.pkl'), 'rb') as f:
            _A['traj'] = pickle.load(f)
        _A['mos'] = {p: np.load(os.path.join(WS, 'mosaic6_%s.npy' % p[5:9])).astype(np.float32)
                     for p in PLATES}
        _A['wt'] = {p: np.load(os.path.join(WS, 'mosweight_%s.npy' % p[5:9])).astype(np.float32)
                    for p in PLATES}
        _A['sky'] = load_png_rgb(os.path.join(ROOT, 'sky_mosaic_full.png')).astype(np.float32)
        _A['sp'] = np.load(os.path.join(WS, 'sky_params.npz'))
        _A['anchor'] = {p: load_png_rgb(os.path.join(ROOT, 'refrences', f)).astype(np.float32)
                        for p, (f, _n) in ANCHOR.items()}
    return _A['traj'], _A['mos'], _A['sky'], _A['sp']


def anchor_den(pname, n):
    """Exact subtitle-free background of plate `pname` at frame n, from its clean anchor frame."""
    M = M_of(_A['traj'], pname, n)
    Ma = M_of(_A['traj'], pname, ANCHOR[pname][1])
    R = (np.vstack([M, [0, 0, 1]]) @ np.vstack([cv2.invertAffineTransform(Ma), [0, 0, 1]]))[:2]
    return cv2.warpAffine(_A['anchor'][pname], R, (W, H), flags=cv2.INTER_LINEAR,
                          borderMode=cv2.BORDER_CONSTANT, borderValue=(255, 255, 255)) - WHITE


def fix_box(F, bg, terms, ell, n):
    """Inside the box, paint only the subtitle pixels and keep the original everywhere else.

    The box is re-rendered unconditionally for the rest of the film, but during a dissolve
    the plate model carries a few rms of bias; against the untouched pixels around the box
    that bias reads as a faint rectangle.  For the two dissolve windows we therefore use the
    exact clean anchor frames to decide *where* the subtitle is, and leave every other pixel
    byte-identical.  Over-detection is harmless (bg is close to F there), under-detection is
    not, so the threshold is deliberately low."""
    g = np.zeros((H, W, 3), np.float32)
    for pname, w in terms:
        g += w * anchor_den(pname, n)
    sub = (np.abs(F - (WHITE + g)).max(axis=2) > FIX_SUB_THR).astype(np.uint8)
    sub = cv2.dilate(sub, np.ones((5, 5), np.uint8))
    sub = cv2.GaussianBlur(sub.astype(np.float32), (0, 0), 1.5, borderType=cv2.BORDER_REPLICATE)
    return bg, ell * np.clip(sub, 0.0, 1.0)


def M_of(traj, pname, n):
    tt, P = traj[pname]
    k = min(max(n, int(tt[0])), int(tt[-1])) - int(tt[0])
    return sim_from_params(P[k])


def sky_crop(sky, dy):
    MH = sky.shape[0]
    r = np.clip(dy + np.arange(H, dtype=np.float32), 0, MH - 1.001)
    r0 = np.floor(r).astype(np.int32)
    a = (r - r0)[:, None, None]
    return (1 - a) * sky[r0] + a * sky[r0 + 1]


def terms_for(n, xalpha):
    for key in ('a', 'b', 'c'):
        pa, pb, w0, w1 = XFADE[key]
        if w0 <= n <= w1:
            al = xalpha[key].get(n, 1.0)
            if al > 0.999:
                return [(pa, 1.0)]
            if al < 0.001:
                return [(pb, 1.0)]
            return [(pa, al), (pb, 1.0 - al)]
    if n <= XFADE['a'][3]:
        return [(ORDER[0], 1.0)]
    if n <= XFADE['b'][3]:
        return [(ORDER[1], 1.0)]
    if n <= XFADE['c'][3]:
        return [(ORDER[2], 1.0)]
    return [(ORDER[3], 1.0)]


def den_for(n, terms, traj, mos):
    acc = np.zeros((H, W, 3), np.float32)
    for pname, w in terms:
        M = M_of(traj, pname, n)
        acc += w * (cv2.warpAffine(mos[pname], M, (W, H), flags=cv2.INTER_LINEAR,
                                   borderMode=cv2.BORDER_REPLICATE) - WHITE)
    return acc


def estimate_R(F, den, iters=4):
    hh, ww = H // R_DS, W // R_DS
    sg = R_SIGMA / R_DS
    Fs = cv2.resize(F, (ww, hh), interpolation=cv2.INTER_AREA)
    ds = cv2.resize(den, (ww, hh), interpolation=cv2.INTER_AREA)
    out = np.zeros((H, W, 3), np.float32)
    for c in range(3):
        v = (np.abs(ds[..., c]) > 45).astype(np.float32)
        R = np.where(v > 0, (Fs[..., c] - WHITE) / np.where(v > 0, ds[..., c], 1.0), 0.0).astype(np.float32)
        keep = v.copy()
        Rs = None
        for _ in range(iters):
            num = cv2.GaussianBlur(R * keep, (0, 0), sg, borderType=cv2.BORDER_REPLICATE)
            dn = cv2.GaussianBlur(keep, (0, 0), sg, borderType=cv2.BORDER_REPLICATE)
            Rs = num / np.maximum(dn, 1e-6)
            resid = R - Rs
            keep = v * ((resid < 0.09) & (resid > -0.30)).astype(np.float32)
        out[..., c] = cv2.resize(Rs, (W, H), interpolation=cv2.INTER_CUBIC)
    return out


def compute_xalpha():
    traj, mos, sky, sp = assets()
    xa = {}
    for key in ('a', 'b', 'c'):
        pa, pb, w0, w1 = XFADE[key]
        al = {}
        for n in range(w0, w1 + 1):
            F = pf.frame_rgb(n)[::4, ::4]
            da = (cv2.warpAffine(mos[pa], M_of(traj, pa, n), (W, H), flags=cv2.INTER_LINEAR,
                                 borderMode=cv2.BORDER_REPLICATE) - WHITE)[::4, ::4]
            db = (cv2.warpAffine(mos[pb], M_of(traj, pb, n), (W, H), flags=cv2.INTER_LINEAR,
                                 borderMode=cv2.BORDER_REPLICATE) - WHITE)[::4, ::4]
            best = (1e18, 0.0)
            for a in np.arange(0, 1.001, 0.02):
                g = a * da + (1 - a) * db
                s = float(((F - WHITE) * g).sum() / max((g * g).sum(), 1e-9))
                r = float((((F - WHITE) - s * g) ** 2).mean())
                if r < best[0]:
                    best = (r, a)
            al[n] = best[1]
        xa[key] = al
        print('xfade %s:' % key, ' '.join('%d:%.2f' % (n, al[n]) for n in range(w0, w1 + 1, 5)), flush=True)
    return xa


def _alpha(r0, r1, c0, c1, f):
    """1 inside the box, smoothly ramped to 0 over `f` pixels at the edges."""
    a = np.zeros((H, W), np.float32)
    a[r0:r1, c0:c1] = 1.0
    ramp = (np.arange(f, dtype=np.float32) + 0.5) / f
    a[r0:r0 + f, c0:c1] *= ramp[:, None]
    a[r1 - f:r1, c0:c1] *= ramp[::-1][:, None]
    a[r0:r1, c0:c0 + f] *= ramp[None, :]
    a[r0:r1, c1 - f:c1] *= ramp[::-1][None, :]
    return a


def main(mode='render', start=0, end=NFRAMES, xa=None):
    traj, mos, sky, sp = assets()
    dy = sp['dy']; gam = sp['gamma']; slo = int(sp['lo'])
    if xa is None:
        xa = compute_xalpha()
    cfr = np.load(os.path.join(WS, 'cfr_map.npy'))
    counts = np.bincount(cfr, minlength=NFRAMES)
    c0, c1 = BAND_COLS
    ALPHA = {'ill': _alpha(BAND_ROWS_ILL[0], BAND_ROWS_ILL[1], c0, c1, FEATHER),
             'sky': _alpha(BAND_ROWS_SKY[0], BAND_ROWS_SKY[1], c0, c1, FEATHER),
             'white': _alpha(BAND_ROWS_WHITE[0], BAND_ROWS_WHITE[1], c0, c1, FEATHER),
             'xa': _alpha(*WIN_A_BOX, FEATHER)}
    stats = np.zeros(NFRAMES, np.float32)
    t0 = time.time()
    fout = open(os.path.join(WS, 'out_full.yuv'), 'wb') if mode == 'render' else None
    with open(YUV, 'rb') as f:
        for n in range(start, end):
            buf = f.read(FSIZE)
            a = np.frombuffer(buf, np.uint8)
            y = a[:W * H].reshape(H, W); u = a[W * H:W * H * 2].reshape(H, W); v = a[W * H * 2:].reshape(H, W)
            F = yuv2rgb(y, u, v)
            if ILL_LO <= n <= ILL_HI:
                terms = terms_for(n, xa)
                den = den_for(n, terms, traj, mos)
                from Rfit import estimate_R
                R = estimate_R(F, den)
                bg = WHITE + R * den
                al = ALPHA['ill']
                if len(terms) > 1 and any(a <= n <= b for a, b in FIX_WINDOWS):
                    if XFADE['a'][2] <= n <= XFADE['a'][3]:
                        al = ALPHA['xa']
                    bg, al = fix_box(F, bg, terms, al, n)
            elif SKY_LO <= n <= SKY_HI:
                i = n - slo
                den = gam[i] * (sky_crop(sky, dy[i]) - WHITE)
                bg = WHITE + den
                al = ALPHA['sky']
            else:
                bg = np.full((H, W, 3), WHITE, np.float32)
                al = ALPHA['white']
            # unconditional: the whole subtitle box is re-rendered, whether or not this
            # frame carries a subtitle
            stats[n] = float(np.abs(bg - F).max(axis=2)[al > 0.5].mean())
            if mode == 'render':
                bgY, bgU, bgV = rgb2yuv(bg)
                oy = np.clip(np.rint((1 - al) * y + al * bgY), 0, 255).astype(np.uint8)
                ou = np.clip(np.rint((1 - al) * u + al * bgU), 0, 255).astype(np.uint8)
                ov = np.clip(np.rint((1 - al) * v + al * bgV), 0, 255).astype(np.uint8)
                blob = oy.tobytes() + ou.tobytes() + ov.tobytes()
                for _ in range(int(counts[n])):
                    fout.write(blob)
            if n % 200 == 0:
                print('n=%4d %.0fs' % (n, time.time() - t0), flush=True)
    if fout:
        fout.close()
    np.save(os.path.join(WS, 'band_model_err.npy'), stats)
    print('mean |bg-F| inside the box: %.2f  p50 %.2f  p95 %.2f  max %.2f' %
          (stats.mean(), np.percentile(stats, 50), np.percentile(stats, 95), stats.max()))
    return xa


if __name__ == '__main__':
    mode = sys.argv[1] if len(sys.argv) > 1 else 'render'
    s = int(sys.argv[2]) if len(sys.argv) > 2 else 0
    e = int(sys.argv[3]) if len(sys.argv) > 3 else NFRAMES
    xp = os.path.join(WS, 'xalpha.pkl')
    x2 = os.path.join(WS, 'xalpha2.pkl')
    if os.path.exists(xp):
        with open(xp, 'rb') as f:
            xa = pickle.load(f)
        if os.path.exists(x2):
            with open(x2, 'rb') as f:
                xb = pickle.load(f)
            # transitions a and b use the refit (independent scale per plate + true range);
            # c keeps the old weights so nothing outside those two transitions changes.
            # The refit is sampled every 2 frames, so interpolate it -- otherwise odd frames
            # fall back to a pure plate and flicker.
            for key in ('a', 'b'):
                src = xb[key]
                ks = sorted(src)
                vals = [src[k] for k in ks]
                win = XFADE[key]
                a0 = float(src[ks[0]])
                a1 = float(src[ks[-1]])
                xa[key] = {}
                for n in range(win[2], win[3] + 1):
                    if n <= ks[0]:
                        xa[key][n] = min(a0, 1.0)
                    elif n >= ks[-1]:
                        xa[key][n] = max(a1, 0.0)
                    else:
                        xa[key][n] = float(np.clip(np.interp(n, ks, vals), 0.0, 1.0))
        print('loaded xalpha' + (' + xalpha2 for a/b' if os.path.exists(x2) else ''))
    else:
        xa = compute_xalpha()
        with open(xp, 'wb') as f:
            pickle.dump(xa, f)
    main(mode, s, e, xa)

