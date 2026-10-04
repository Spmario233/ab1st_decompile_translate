"""ending_matsushita: cover the credits text and the closing logo with the
frame's solid white background.  Everything else is passed through untouched.

  n in [TEXT0, TEXT1) : clear non-white pixels inside the left credits column
  n in [LOGO0, LOGO1) : clear non-white pixels over the whole frame (logo on white)
"""
import os, time
import numpy as np

W = r"E:\Projects\ab1st_decompile\video\ending_matsushita\_work"
H0, W0 = 720, 1280
N = 7890
MM = np.memmap(os.path.join(W, "raw.yuv"), np.uint8, mode="r", shape=(N, 3, H0, W0))

TEXT0, TEXT1 = 690, 6635
LOGO0, LOGO1 = 7431, 7830
TX0, TX1 = 140, 790     # credits column; the sunflower inset starts at x>=802
WHITE = np.array([254, 128, 128], np.uint8)
THRESH = 252

out = os.path.join(W, "mt_out.yuv")
t0 = time.time()
with open(out, "wb") as fh:
    for n in range(N):
        fr = np.array(MM[n])                       # writable copy (3,720,1280)
        if TEXT0 <= n < TEXT1:
            sub = fr[:, :, TX0:TX1]
            m = sub[0] < THRESH
            sub[0][m] = WHITE[0]
            sub[1][m] = WHITE[1]
            sub[2][m] = WHITE[2]
        elif LOGO0 <= n < LOGO1:
            m = fr[0] < THRESH
            fr[0][m] = WHITE[0]
            fr[1][m] = WHITE[1]
            fr[2][m] = WHITE[2]
        fh.write(np.ascontiguousarray(fr).tobytes())
        if n % 1000 == 0:
            print(f"  frame {n}/{N} ({time.time()-t0:.0f}s)", flush=True)
print(f"wrote {out} ({time.time()-t0:.0f}s)")
