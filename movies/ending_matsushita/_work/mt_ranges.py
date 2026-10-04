import numpy as np, os

W = r"E:\Projects\ab1st_decompile\video\ending_matsushita\_work"
H0, W0 = 720, 1280
N = 7890
MM = np.memmap(os.path.join(W, "raw.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))

# white level from a frame with no content at all (t = 10 s)
w = np.asarray(MM[300], np.float64).reshape(3, -1).mean(axis=1)
print("blank-frame level (Y,U,V) =", np.round(w, 3))
w2 = np.asarray(MM[225 * 30 + 10], np.float64).reshape(3, -1)
print("frame t=225.3  Y range", w2[0].min(), w2[0].max(), " U range", w2[1].min(), w2[1].max())

TXT = (slice(0, H0), slice(110, 700))
LOGO = (slice(230, 430), slice(520, 760))

print("\n n      t      textzone nonwhite px     logozone nonwhite px")
prev_txt = prev_logo = 0
for n in range(N):
    fr = np.asarray(MM[n])
    y = fr[0]
    nwt = int((y[TXT] < 246).sum())
    nwl = int((y[LOGO] < 246).sum())
    if (nwt > 0) != (prev_txt > 0) or (nwl > 0) != (prev_logo > 0):
        print(f"  boundary n={n:5d} t={n/30:8.3f}  text={nwt:7d}  logo={nwl:6d}   "
              f"(was text={prev_txt} logo={prev_logo})")
    prev_txt, prev_logo = nwt, nwl
print("\n done")
