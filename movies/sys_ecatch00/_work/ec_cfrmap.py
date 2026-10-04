"""Derive ffmpeg's exact CFR frame mapping by matching the decoded CFR stream back to the
stored frames, then apply the identical mapping to the new frames."""
import os
import numpy as np

W = r"E:\Projects\ab1st_decompile\video\sys_ecatch00\_work"
H0, W0 = 720, 1280
N39, NCFR = 39, 130
orig39 = np.memmap(os.path.join(W, "all.yuv"), np.uint8, mode="r", shape=(N39, 3, H0, W0))
cfr = np.memmap(os.path.join(W, "orig_cfr.yuv"), np.uint8, mode="r", shape=(NCFR, 3, H0, W0))

# map each CFR frame to the closest stored frame (mean abs difference over a subsample)
sub = (slice(None, None, 4), slice(None, None, 4))
best = np.zeros(NCFR, int)
for n in range(NCFR):
    c = cfr[n][sub].astype(np.int16)
    errs = [int(np.abs(o[sub].astype(np.int16) - c).mean()) for o in orig39]
    best[n] = int(np.argmin(errs))
print("CFR -> stored frame map:")
print(" ", best.tolist())
print("max residual of that mapping:",
      max(int(np.abs(cfr[n].astype(np.int16) - orig39[best[n]].astype(np.int16)).max())
          for n in range(NCFR)))
np.save(os.path.join(W, "cfrmap.npy"), best)

new = np.memmap(os.path.join(W, "new_all.yuv"), np.uint8, mode="r", shape=(N39, 3, H0, W0))
with open(os.path.join(W, "new_cfr.yuv"), "wb") as fh:
    for n in range(NCFR):
        fh.write(np.ascontiguousarray(new[best[n]]).tobytes())
print("wrote new_cfr.yuv using the derived mapping")

# control: expand the ORIGINAL frames with the same map and compare to ffmpeg's CFR output
mx = 0
for n in range(NCFR):
    mx = max(mx, int(np.abs(orig39[best[n]].astype(np.int16) - cfr[n].astype(np.int16)).max()))
print("control max |mapped original - ffmpeg CFR| :", mx)

# and confirm the new CFR differs from the original CFR only inside the logo box
newcfr = np.memmap(os.path.join(W, "new_cfr.yuv"), np.uint8, mode="r", shape=(NCFR, 3, H0, W0))
m = np.ones((H0, W0), bool); m[266:411, 720:1185] = False
mx = 0
for n in range(NCFR):
    mx = max(mx, int(np.abs(newcfr[n].astype(np.int16) - cfr[n].astype(np.int16))[:, m].max()))
print("max |new CFR - original CFR| OUTSIDE the logo box:", mx)
