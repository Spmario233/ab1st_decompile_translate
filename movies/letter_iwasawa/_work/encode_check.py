"""Encode the deliverable ogv and look for horizontal colour-corruption bands."""
import os, subprocess, sys, shutil
import numpy as np

WS = os.path.dirname(os.path.abspath(__file__))
DST = os.path.dirname(WS)
FF = r'E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe'
SRC = os.path.join(WS, 'out_full.yuv')
TMP = os.path.join(WS, '_test.ogv')
RAW = os.path.join(WS, '_test.yuv')
W, H = 1280, 720
FS = W * H * 3

extra = sys.argv[1:] if len(sys.argv) > 1 else []
subprocess.run([FF, '-v', 'error', '-y', '-f', 'rawvideo', '-pix_fmt', 'yuv444p', '-s', '1280x720',
                '-r', '30', '-i', SRC, '-c:v', 'libtheora', '-q:v', '10'] + extra +
               ['-pix_fmt', 'yuv444p', TMP], check=True)
subprocess.run([FF, '-v', 'error', '-y', '-i', TMP, '-fps_mode', 'passthrough',
                '-pix_fmt', 'yuv444p', '-f', 'rawvideo', RAW], check=True)

f = open(RAW, 'rb')
bad = []
i = 0
while True:
    b = f.read(FS)
    if len(b) != FS:
        break
    a = np.frombuffer(b, np.uint8)
    u = a[W * H:2 * W * H].reshape(H, W).astype(np.float32)
    v = a[2 * W * H:].reshape(H, W).astype(np.float32)
    ch = np.abs(u - 128) + np.abs(v - 128)
    row = ch.mean(axis=1)
    jump = np.abs(np.diff(row))
    j = int(jump.argmax())
    # a genuine corruption is a step of >25 chroma levels between adjacent rows
    if jump[j] > 25:
        bad.append((i, j, round(float(jump[j]), 1), round(float(row[j]), 1), round(float(row[j + 1]), 1)))
    i += 1
f.close()
os.remove(RAW)
print('decoded packets: %d' % i)
print('packets with a colour step: %d' % len(bad))
for x in bad[:25]:
    print('   packet %4d  row %3d  step %6.1f  (row means %.1f -> %.1f)' % x)
print('RESULT: %s' % ('CLEAN' if not bad else 'CORRUPT'))
if not bad:
    shutil.move(TMP, os.path.join(DST, 'ef_iw_letter00_notext.ogv'))
    print('installed deliverable ogv')
else:
    os.remove(TMP)
    print('kept the old file, not installed')
