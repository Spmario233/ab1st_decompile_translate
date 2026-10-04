import numpy as np, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
import platefit as pf
WS = os.path.dirname(os.path.abspath(__file__))
d = np.load(os.path.join(WS, 'scan.npz'))
mY = d['meanY']; wf = d['whitefrac']
print('-- illustration fade-in --')
for n in range(874, 906):
    print('n=%4d t=%7.3f meanY=%7.3f whitefrac=%.4f' % (n, n/30, mY[n], wf[n]))
print('-- illustration fade-out --')
for n in range(3294, 3320):
    print('n=%4d t=%7.3f meanY=%7.3f whitefrac=%.4f' % (n, n/30, mY[n], wf[n]))
print('-- tail white / subtitle --')
for n in range(3350, 3362):
    print('n=%4d t=%7.3f meanY=%7.3f whitefrac=%.4f' % (n, n/30, mY[n], wf[n]))
