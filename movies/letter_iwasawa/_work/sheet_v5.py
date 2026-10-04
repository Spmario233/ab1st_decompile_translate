"""Final sheet: the two dissolve windows, original vs the delivered file."""
import os, sys, subprocess
import numpy as np
from PIL import Image, ImageDraw

WS = os.path.dirname(os.path.abspath(__file__))
DST = os.path.dirname(WS)
FF = r'E:\Videos\ffmpeg\ffmpeg71\ffmpeg.exe'
SRC = os.path.join(DST, 'ef_iw_letter00.ogv')
OGV = os.path.join(DST, 'ef_iw_letter00_notext.ogv')
cfr = np.load(os.path.join(WS, 'cfr_map.npy'))
NS = [int(x) for x in (sys.argv[1] if len(sys.argv) > 1 else '1383,1400,1430,1953,1975,2010').split(',')]

A = os.path.join(WS, '_f_a.png'); B = os.path.join(WS, '_f_b.png')
rows = []
for n in NS:
    slot = int(np.nonzero(cfr == n)[0][0])
    subprocess.run([FF, '-v', 'error', '-y', '-i', SRC, '-vf', "select='eq(n\\,%d)'" % n,
                    '-fps_mode', 'passthrough', '-frames:v', '1', '-pix_fmt', 'rgb24', A], check=True)
    subprocess.run([FF, '-v', 'error', '-y', '-ss', '%.6f' % (slot / 30.0), '-i', OGV,
                    '-frames:v', '1', '-pix_fmt', 'rgb24', B], check=True)
    rows.append((n, slot, Image.open(A).copy(), Image.open(B).copy()))

sw, sh = 430, 242
c = Image.new('RGB', (2 * sw + 8, (sh + 18) * len(rows)), (0, 0, 0))
d = ImageDraw.Draw(c)
for i, (n, slot, a, b) in enumerate(rows):
    y = i * (sh + 18) + 18
    c.paste(a.resize((sw, sh), Image.LANCZOS), (0, y))
    c.paste(b.resize((sw, sh), Image.LANCZOS), (sw + 8, y))
    d.text((3, y - 14), 'stored %d (t=%.2fs)   LEFT = original   RIGHT = delivered' % (n, slot / 30.0),
           fill=(255, 255, 0))
c.save(os.path.join(WS, 'diag_final_v5.png'))
for p in (A, B):
    if os.path.exists(p):
        os.remove(p)
print(c.size)
