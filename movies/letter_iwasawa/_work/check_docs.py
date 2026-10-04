import os
WS = os.path.dirname(os.path.abspath(__file__))
for p in (os.path.join(os.path.dirname(WS), 'README.md'), os.path.join(WS, 'README.md')):
    b = open(p, 'rb').read()
    try:
        t = b.decode('utf-8')
        print('%-60s UTF-8 OK  %d chars  %d bytes' % (os.path.relpath(p), len(t), len(b)))
    except UnicodeDecodeError as e:
        print('%-60s BROKEN %s' % (os.path.relpath(p), e))
