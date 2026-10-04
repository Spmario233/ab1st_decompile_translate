import numpy as np, os, sys
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
d = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), 'scan.npz'))
wf = d['whitefrac']; mY = d['meanY']; mU = d['meanU']; mV = d['meanV']
rowdark = d['rowdark']; rd = d['rowdark'].astype(np.float32)
N = len(wf)
print('N =', N, 'dur = %.3f s' % (N / 30))
print('pure-white frames (whitefrac>=0.999):', int((wf >= 0.999).sum()))
# run-length encoding of "is white"
isw = wf >= 0.999
runs = []
s = 0
for i in range(1, N + 1):
    if i == N or isw[i] != isw[s]:
        runs.append((s, i - 1, bool(isw[s])))
        s = i
print('\n--- white/non-white runs (len>=2) ---')
for a, b, w in runs:
    if b - a + 1 >= 2:
        print('%5d-%5d  %7.3f-%7.3f s  len=%5d  %s' % (a, b, a / 30, b / 30, b - a + 1, 'WHITE' if w else 'content'))
print('\n--- every 30 frames ---')
for n in range(0, N, 30):
    tot = rd[n].sum()
    # rows holding dark pixels
    rows = np.nonzero(rd[n] > 3)[0]
    rng = '%4d-%4d' % (rows.min(), rows.max()) if len(rows) else '   -    '
    print('n=%4d t=%7.3f  meanY=%6.2f U=%6.2f V=%6.2f whitefrac=%.3f dark=%7d rows=%s' %
          (n, n / 30, mY[n], mU[n], mV[n], wf[n], tot, rng))
