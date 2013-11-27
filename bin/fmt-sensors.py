#!/usr/bin/python3

import os
import subprocess
import argparse

class option(object):
	pass

opt = option()

parser = argparse.ArgumentParser()
parser.add_argument('-s', '--sep', type=int, default=1, help='Define columns space')
parser.add_argument('-w', '--width', type=int, default=0, help='Max line width')
parser.parse_args(namespace=opt)


p = subprocess.Popen("sensors", stdout=subprocess.PIPE, shell=True)

i = 0
n = 0
lines = []
maxcollen = [0, 0]


for l in p.stdout:
	#print('{}.{} --- {}'.format(n,i,l))
	if l == b'\n':
		i += 1
		n = 0
		continue

	l = l.decode('utf-8')
	l = l.rstrip('\n').replace('\t', ' ').partition(' (')[0].strip()

	maxcollen[i] = len(l) if maxcollen[i] < len(l) else maxcollen[i]
	if i == 0:
		lines.append([l])
	else:
		if len(lines) >= n:
			lines[n].append(l)
		else:
			lines.append([' ', l])
	n += 1

maxlen=0
if opt.width < maxcollen[0] + maxcollen[1]:
	maxlen = maxcollen[0] + opt.sep
else:
	maxlen = opt.width - maxcollen[1]

for i in lines:
	i.append('')
	f = '{0:{fill}} {1}'.format(i[0], i[1], fill=maxlen)
	print(f)

