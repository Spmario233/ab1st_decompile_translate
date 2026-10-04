"""Check the installed deliverable ogv: colour bands, duration, PSNR against the render."""
import os, subprocess
import numpy as np

WS = os.path.dirname(os.path.abspath(__file__))
DST = os.path.dirname(WS)
FF = r'E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe'
FP = r'E:\Videos\ffmpeg\ffmpeg71\ffprobe.exe'
OGV = os.path.join(DST, 'ef_iw_letter00_notext.ogv')
RAW = os.path.join(WS, '_chk.yuv')
W, H = 1280, 720
FS = W * H * 3

print('--- properties ---')
subprocess.run([FP, '-v', 'error', '-show_entries', 'format=duration,size',
                '-show_entries', 'stream=width,height,pix_fmt,nb_read_frames',
                '-count_frames', '-select_streams', 'v:0', '-of', 'default=nw=1', OGV])
print('bytes = %d' % os.path.getsize(OGV))

subprocess.run([FF, '-v', 'error', '-y', '-i', OGV, '-fps_mode', 'cfr', '-r', '30',
                '-pix_fmt', 'yuv444p', '-f', 'rawvideo', RAW], check=True)
a = open(os.path.join(WS, 'out_full.yuv'), 'rb')
b = open(RAW, 'rb')
mses, bad = [], []
i = 0
while True:
    x = a.read(FS); y = b.read(FS)
    if len(x) != FS or len(y) != FS:
        break
    A = np.frombuffer(x, np.uint8); B = np.frombuffer(y, np.uint8)
    mses.append(float(((A.astype(np.int16) - B.astype(np.int16)) ** 2).mean()))
    u = B[W * H:2 * W * H].reshape(H, W).astype(np.float32)
    v = B[2 * W * H:].reshape(H, W).astype(np.float32)
    row = (np.abs(u - 128) + np.abs(v - 128)).mean(axis=1)
    j = int(np.abs(np.diff(row)).argmax())
    if abs(row[j + 1] - row[j]) > 25:
        bad.append((i, j))
    i += 1
a.close(); b.close(); os.remove(RAW)
m = np.array(mses)
ps = 10 * np.log10(255 * 255 / np.maximum(m, 1e-12))
print('frames %d  MSE %.3f  PSNR avg %.2f dB median %.2f min %.2f' %
      (len(m), m.mean(), 10 * np.log10(255 * 255 / m.mean()), np.median(ps), ps.min()))
print('frames with a colour step: %d %s' % (len(bad), bad[:10]))
