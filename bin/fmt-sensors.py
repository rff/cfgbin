#!/usr/bin/python3

import os
import subprocess
import argparse

def setoptconsts(opts):
    opts.VERSION = '0.0.0'
    return opts

def parseargs():
    parser = argparse.ArgumentParser()
    parser.add_argument('-s', '--sep', type=int, default=1, help='Define columns space')
    parser.add_argument('-w', '--width', type=int, default=0, help='Max line width')
    parser.add_argument('-i', '--invert', action='store_true', help='Invert First and Second columns')
    parser.add_argument('-1', '--onecolumn', action='store_true', help='Print in one column')
    parser.add_argument('-d', '--debug', action='store_true', help='Print debug information')
    return parser.parse_args()

def readsensors():
    out = subprocess.check_output("sensors")
    return out.decode('utf-8').splitlines()

def parsesensors(opts):
    i = 0
    n = 0
    lines = []
    maxcollen = [0, 0, 0, 0]

    for l in readsensors():
        if opts.debug:
            print('{}.{} --- {}'.format(n,i,l))
        if l == '':
            i += 1
            n = 0
            continue

        l = l.rstrip('\n').replace('\t', ' ').partition(' (')[0].strip()

        maxcollen[i] = len(l) if maxcollen[i] < len(l) else maxcollen[i]

        if opts.debug:
            print('i:{} -- n:{} -- len:{}'.format(i,n,len(lines)))

        if i == 0:
            lines.append([l])
        else:
            if len(lines) > n:
                lines[n].append(l)
            else:
                lines.append([' ', l])
        n += 1
    return lines, maxcollen

def printsensors(opts, lines, maxcollen):
    i = 0 # first column to be printed
    j = 1 # second column to be printed
    if opts.invert:
        i = 1
        j = 0

    maxlen=0
    if opts.width < maxcollen[i] + maxcollen[j]:
        maxlen = maxcollen[i] + opts.sep
    else:
        maxlen = opts.width - maxcollen[j]

    if opts.onecolumn:
        for l in lines:
            l.append('')
            f = '{}'.format(l[i])
            f = f.strip()
            if len(f) > 0: print(f)
        print()
        for l in lines:
            l.append('')
            f = '{}'.format(l[j])
            f = f.strip()
            if len(f) > 0: print(f)
    else:
        for l in lines:
            l.append('')
            f = '{0:{fill}}{1}'.format(l[i], l[j], fill=maxlen)
            print(f)

def main():
    opts = parseargs()
    opts = setoptconsts(opts)

    lines, maxcollen = parsesensors(opts)
    printsensors(opts, lines, maxcollen)
    return


if __name__ == '__main__': main()
