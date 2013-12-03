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
parser.add_argument('-i', '--invert', action='store_true', help='Invert First and Second columns')
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
	#print('i:{} -- n:{} -- len:{}'.format(i,n,len(lines)))
	if i == 0:
		lines.append([l])
	else:
		if len(lines) > n:
			lines[n].append(l)
		else:
			lines.append([' ', l])
	n += 1

i = 0 # first column to be printed
j = 1 # second column to be printed
if opt.invert:
	i = 1
	j = 0

maxlen=0
if opt.width < maxcollen[i] + maxcollen[j]:
	maxlen = maxcollen[i] + opt.sep
else:
	maxlen = opt.width - maxcollen[j]

for l in lines:
	l.append('')
	f = '{0:{fill}}{1}'.format(l[i], l[j], fill=maxlen)
	print(f)

