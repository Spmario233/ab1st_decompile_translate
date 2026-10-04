"""Build the final before/after sheet straight from the delivered files."""
import os, subprocess
import numpy as np
from PIL import Image, ImageDraw

WS = os.path.dirname(os.path.abspath(__file__))
DST = os.path.dirname(WS)
FF = r'E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe'
SRC = os.path.join(DST, 'ef_iw_letter00.ogv')
MKV = os.path.join(DST, 'ef_iw_letter00_notext_lossless.mkv')

cfr = np.load(os.path.join(WS, 'cfr_map.npy'))
PAIRS = [(1353, 't=49s (shot 1)'), (1443, 't=52s (shot 2)'),
         (2463, 't=86s (shot 3)'), (3273, 't=113s (shot 4)')]

A = os.path.join(WS, '_tmp_a.png')
B = os.path.join(WS, '_tmp_b.png')
rows = []
for n, lab in PAIRS:
    slot = int(np.nonzero(cfr == n)[0][0])
    t = slot / 30.0
    subprocess.run([FF, '-v', 'error', '-y', '-i', SRC, '-vf', "select='eq(n\\,%d)'" % n,
                    '-fps_mode', 'passthrough', '-frames:v', '1', '-pix_fmt', 'rgb24', A], check=True)
    subprocess.run([FF, '-v', 'error', '-y', '-ss', '%.6f' % t, '-i', MKV, '-frames:v', '1',
                    '-pix_fmt', 'rgb24', B], check=True)
    rows.append((Image.open(A).copy(), Image.open(B).copy(), 'stored %d  %s' % (n, lab)))

sw, sh = 420, 236
canvas = Image.new('RGB', (2 * sw + 8, (sh + 18) * len(rows)), (0, 0, 0))
d = ImageDraw.Draw(canvas)
for i, (a, b, lab) in enumerate(rows):
    y = i * (sh + 18) + 18
    canvas.paste(a.resize((sw, sh), Image.LANCZOS), (0, y))
    canvas.paste(b.resize((sw, sh), Image.LANCZOS), (sw + 8, y))
    d.text((3, y - 14), '%s    LEFT = original    RIGHT = delivered' % lab, fill=(255, 255, 0))
canvas.save(os.path.join(WS, 'diag_final_v3.png'))
for p in (A, B):
    if os.path.exists(p):
        os.remove(p)
print(canvas.size)
