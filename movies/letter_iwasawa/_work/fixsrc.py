"""Repair render_full.py: strip the BOM added by PowerShell and undo the GBK mojibake."""
import os
import io

WS = os.path.dirname(os.path.abspath(__file__))
p = os.path.join(WS, 'render_full.py')
b = open(p, 'rb').read()
if b.startswith(b'\xef\xbb\xbf'):
    b = b[3:]
    print('stripped BOM')
s = b.decode('utf-8')
try:
    s2 = s.encode('gbk').decode('utf-8')
    print('mojibake repaired')
    s = s2
except (UnicodeEncodeError, UnicodeDecodeError) as e:
    print('cannot repair mojibake (probably already clean):', e)
open(p, 'w', encoding='utf-8', newline='').write(s)
import ast
ast.parse(s)
print('syntax OK, %d chars' % len(s))
