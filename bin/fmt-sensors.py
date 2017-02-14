#!/usr/bin/python3

import os
import subprocess
import argparse
import collections

OPTS = None

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
    parser.add_argument('-O', '--old-format', action='store_true', help='Use the old format code/version')
    return parser.parse_args()

def readsensors():
    out = subprocess.check_output("sensors")
    return out.decode('utf-8').splitlines()

class SensorsGroup():
    def __init__(self, name='', adapter='', sensors={}):
        self.name = name
        self.adapter = adapter
        self.sensors = sensors

    def __str__(self):
        return '\n'.join(self.printarray())

    def readraw(self, lines):
        """ Read from a list of lines comming from 'sensors' program output.
            It only reads one group of sensors, from one adapter.
        """
        return

    def printarray(self):
        a  = [self.name]
        a += ['Adapter: {}'.format(self.adapter)]
        a += ['{}: {}'.format(k,v) for k,v in self.sensors.items()]
        return a

    def printformated(self, col1=0, col2=0, space=0, sep=':', line='-'):
        a  = [self.name]
        if line:
            a += [line * len(self.name)]
        a += ['Adapter: {}'.format(self.adapter)]
        a += ['{0:<{c1}}{s:<{w}}{1:>{c2}}'.format(k, v, c1=col1, c2=col2, w=space+1, s=sep) for k,v in self.sensors.items()]
        return a

def newsensorsgroup(grouplines):
    name = grouplines[0].strip()

    # split a line in the first ':' and take the right side, should be the
    # Adapter name. We could also make a more generic aproach in that all lines
    # can be any one of the 3 types we are reading and check the the prefix
    # 'Adapter:' for this type.
    adapter = grouplines[1].partition(':')[2].strip()

    #sensors = {}
    sensors = collections.OrderedDict()
    for l in grouplines[2:]:
        sname , _, l = l.partition(':')
        svalue, _, l = l.partition('(')
        sname, svalue = sname.strip(), svalue.strip()
        sensors[sname] = svalue

    return SensorsGroup(name, adapter, sensors)

def splitgroups(rawlines):
    groups = []
    lines = []
    for l in rawlines:
        if OPTS.debug:
            print('{}.{} --- {}'.format(n,i,l))
        l = l.strip()
        if l != '':
            lines.append(l)
            continue
        groups.append(lines)
        lines = []

#    return [newsensorsgroup(g) for g in groups]
    return groups

def parsesensors():
    rawlines = readsensors()
    linegroups = splitgroups(rawlines)
    sensorgroups = [newsensorsgroup(g) for g in linegroups]
    return sensorgroups

def printsensors():
    sg = parsesensors()
#    for i in sg:
        #s = '\n'.join(i.printformated(col1=5, col2=20, space=5))
#        m = max([len(s) for s in i.sensors.keys()])
#        s = '\n'.join(i.printformated(col1=m, space=1))
#        print(s)
#        print()

    # The goal to format is to altomatica group sensors in two columns, tring
    # to balance the number of lines.

    col1  = sg[0].printformated(space=1, line=None)
    col1 += ['']
    col1 += sg[1].printformated(space=1, line=None)

    col2 = sg[2].printformated(space=1, line=None)

    l1 = len(col1)
    l2 = len(col2)
    if l1 < l2:
        col1 += [''] * (l2 - l1)
    else:
        col2 += [''] * (l1 - l2)


    maxlen1 = max([len(l) for l in col1])
    lines = []
    for lc1, lc2 in zip (col1, col2):
        lines += ['{:{}} | {}'.format(lc1, maxlen1, lc2)]

    s = '\n'.join(lines)
    print(s)
    return


def parsesensors_OLD():
    i = 0
    n = 0
    lines = []
    maxcollen = [0, 0, 0, 0]


    for l in readsensors():
        if OPTS.debug:
            print('{}.{} --- {}'.format(n,i,l))
        if l == '':
            i += 1
            n = 0
            continue

        l = l.rstrip('\n').replace('\t', ' ').partition(' (')[0].strip()

        maxcollen[i] = len(l) if maxcollen[i] < len(l) else maxcollen[i]

        if OPTS.debug:
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

def printsensors_OLD(lines, maxcollen):
    i = 0 # first column to be printed
    j = 1 # second column to be printed
    if OPTS.invert:
        i = 1
        j = 0

    maxlen=0
    if OPTS.width < maxcollen[i] + maxcollen[j]:
        maxlen = maxcollen[i] + OPTS.sep
    else:
        maxlen = OPTS.width - maxcollen[j]

    if OPTS.onecolumn:
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
    global OPTS
    OPTS = parseargs()
    OPTS = setoptconsts(OPTS)

    if OPTS.old_format:
        lines, maxcollen = parsesensors_OLD()
        printsensors_OLD(lines, maxcollen)
    else:
        print()
        print()
        printsensors()

    return


if __name__ == '__main__': main()
