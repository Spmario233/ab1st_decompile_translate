import os
import numpy as np

W = r"E:\Projects\ab1st_decompile\video\ending_iwasawa\_work"
B = [(0, 400), (880, 1280)]


def load(t):
    a = np.fromfile(os.path.join(W, f"p{t}.yuv"), dtype=np.uint8).reshape(3, 720, 1280)
    return a.astype(np.float64)


print("frame   region          Ymin Ymax Ymean   Umean  Vmean")
for t in (72.5, 100, 250, 260):
    a = load(t)
    for name, sel in (("bands", np.concatenate([np.arange(0, 400), np.arange(880, 1280)])),):
        sub = a[:, :, sel]
        print(f"t={t:<6} {name:9s}  {sub[0].min():5.0f} {sub[0].max():5.0f} "
              f"{sub[0].mean():7.3f}  {sub[1].mean():7.3f} {sub[2].mean():7.3f}")
    print(f"        whole frame Y hist: "
          f"Y<=16:{(a[0]<=16).mean()*100:6.2f}%  Y>=200:{(a[0]>=200).mean()*100:5.2f}%  "
          f"unique Y values in bands: {len(np.unique(a[0][:, 0:400]))}")

print()
print("fade model check on frame t=68.9 (bands only, mosaic-free):")
a = load(68.9)
sel = np.concatenate([np.arange(0, 400), np.arange(880, 1280)])
sub = a[:, :, sel]
print("  Y mean %.3f  U mean %.3f  V mean %.3f" % (sub[0].mean(), sub[1].mean(), sub[2].mean()))
