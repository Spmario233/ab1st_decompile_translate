"""Mosaic v5: robust per-plate-pixel temporal median (histogram at half resolution),
then a full-resolution refinement pass.  Handles the fact that the subtitle contributes
both dark glyph cores and bright halos over dark artwork."""
import os, sys, time, pickle
import numpy as np, cv2
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from iwlib import W, H
import platefit as pf
from mosaic_build import sim_from_params, PLATES

WS = os.path.dirname(os.path.abspath(__file__))
WHITE = 254.0
NB = 64
DS = 2
HH, WW = H // DS, W // DS


def build_median(pname, traj, ref, verbose=True):
    tt, P = traj[pname]
    n0, n1 = int(tt[0]), int(tt[-1])
    hist = np.zeros((HH, WW, 3, NB), np.uint16)
    t0 = time.time()
    nf = 0
    for k, n in enumerate(range(n0, n1 + 1)):
        M = sim_from_params(P[k]); Minv = cv2.invertAffineTransform(M)
        F = pf.frame_rgb(n).astype(np.float32)
        den = cv2.warpAffine(ref, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE
        v = np.abs(den).max(axis=2) > 25
        if v.sum() < 1000:
            continue
        a = F - WHITE
        s = float((a * den)[v].sum() / max((den * den)[v].sum(), 1e-9))
        s = min(max(s, 0.2), 3.0)
        wp = cv2.warpAffine(F, Minv, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
        val = WHITE + (wp - WHITE) / s
        vd = cv2.resize(val, (WW, HH), interpolation=cv2.INTER_AREA)
        idx = np.clip((vd * (NB / 256.0)).astype(np.int16), 0, NB - 1)
        for b in range(0, NB, 4):
            hist[..., b:b + 4] += (idx[..., None] == np.arange(b, b + 4, dtype=np.int16)).astype(np.uint16)
        nf += 1
        if verbose and k % 200 == 0:
            print('    %s k=%d %.0fs' % (pname[5:9], k, time.time() - t0), flush=True)
    cnt = hist.sum(axis=3).astype(np.float32)
    c = np.cumsum(hist.astype(np.float32), axis=3)
    half = cnt * 0.5
    med = (c < half[..., None]).sum(axis=3)          # first bin index reaching the median
    med = np.clip(med, 0, NB - 1)
    return med.astype(np.float32) * (256.0 / NB) + (128.0 / NB), cnt


def build_full(pname, traj, med_hr, passes=3, thr=(14.0, 10.0, 8.0), verbose=True):
    tt, P = traj[pname]
    n0, n1 = int(tt[0]), int(tt[-1])
    ref = cv2.resize(med_hr.astype(np.float32), (W, H), interpolation=cv2.INTER_CUBIC)
    for it in range(passes):
        num = np.zeros((H, W, 3), np.float64)
        cnt = np.zeros((H, W), np.float64)
        t0 = time.time()
        for k, n in enumerate(range(n0, n1 + 1)):
            M = sim_from_params(P[k]); Minv = cv2.invertAffineTransform(M)
            F = pf.frame_rgb(n).astype(np.float32)
            den = cv2.warpAffine(ref, M, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE) - WHITE
            v = np.abs(den).max(axis=2) > 25
            if v.sum() < 1000:
                continue
            a = F - WHITE
            s = float((a * den)[v].sum() / max((den * den)[v].sum(), 1e-9))
            s = min(max(s, 0.2), 3.0)
            wp = cv2.warpAffine(F, Minv, (W, H), flags=cv2.INTER_LINEAR, borderMode=cv2.BORDER_REPLICATE)
            val = WHITE + (wp - WHITE) / s
            d = val - ref
            w = ((d.max(axis=2) < thr[it]) & (d.min(axis=2) > -thr[it])).astype(np.float32)
            num += val * w[..., None]
            cnt += w
        c = np.maximum(cnt, 1e-9)
        new = num / c[..., None]
        new[cnt < 2] = ref[cnt < 2]
        if verbose:
            print('   full pass %d thr=%.0f: %.0fs usable=%.3f' % (it, thr[it], time.time() - t0, (cnt >= 2).mean()), flush=True)
        ref = new
    return ref


if __name__ == '__main__':
    with open(os.path.join(WS, 'traj_smooth.pkl'), 'rb') as f:
        traj = pickle.load(f)
    for pname in PLATES:
        print('mosaic5 %s' % pname[5:9], flush=True)
        prev = np.load(os.path.join(WS, 'mosaic3_%s.npy' % pname[5:9])).astype(np.float32)
        med, cnt = build_median(pname, traj, prev)
        np.save(os.path.join(WS, 'mosaic5med_%s.npy' % pname[5:9]), med.astype(np.float32))
        full = build_full(pname, traj, med)
        np.save(os.path.join(WS, 'mosaic5_%s.npy' % pname[5:9]), full.astype(np.float32))
        from PIL import Image
        Image.fromarray(np.clip(full, 0, 255).astype(np.uint8)).save(
            os.path.join(WS, 'diag_mosaic5_%s.png' % pname[5:9]))
