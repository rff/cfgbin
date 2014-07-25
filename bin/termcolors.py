#!/usr/bin/env python
# Copyright (C) 2006 by Johannes Zellner, <johannes@zellner.org>
# modified by mac@calmar.ws to fit my output needs
# modified by rff@ to fit my output needs(2)

import sys
import os
import argparse
#import subprocess

FGCOLOR=16 # black
COLOROPTIONS = (8, 16, 88, 256)


def nl():
    os.system('echo')

def echo(msg):
    os.system('echo -n "{}"'.format(msg))

def out(bgcolor):
    os.system('tput setaf {}'.format(FGCOLOR))
    os.system('tput setab {}'.format(bgcolor))
    os.system('echo -n "{:4}"'.format(bgcolor))
    #os.system("tput setab 0")  # not working to restore to default background, it set to black.
    os.system('/bin/echo -ne "\e[0m"')


def printblock(start, end, width):
    for y in range(start, end):
        out(y)
        if (y - start) % width == width - 1: nl()


def printdoubleblock(start, end, width):
    half = (end - start) / 2
    for y in range(start, start + half):
        out(y)
        if (y - start) % width != width - 1:
            continue
        echo('    ')
	middle = y - width + half + 1
        for y in range(middle, middle + width):
            out(y)
        nl()


def gettermcolors():
    return int(os.popen('tput colors').read().strip())


def parseargs():
    termcolors = gettermcolors()
    parser = argparse.ArgumentParser()
    for c in COLOROPTIONS:
        parser.add_argument('--{}'.format(c), action='store_const', const=c,
                            default=termcolors, dest='termcolors',
                            help='Force {} colors terminal test'.format(c))
    parser.add_argument('-c', '--colors', action='store', choices=COLOROPTIONS,
                        type=int, default=termcolors, dest='termcolors',
                        help="Force N colors terminal test")
    return parser.parse_args()


def main():
    opts = parseargs()

    colors = opts.termcolors
    cubewidth = 4 if colors == 88 else 6
    graystart = 16 + cubewidth**3

    print('{} colors terminal'.format(colors))

    if colors < 8: return 0
    print('ANSI 8 colors:')
    printblock(0, 8, 8)
    print

    if colors < 16: return 0
    print('High-intensity (bold/blink) of ANSI 8 colors:')
    printblock(8, 16, 8)
    print

    if colors < 88: return 0
    print('{0}x{0}x{0} RGB color cube:'.format(cubewidth))
    #printblock(16, graystart, cubewidth)
    printdoubleblock(16, graystart, cubewidth)
    print

    print('Grayscale ramp:')
    printblock(graystart, colors, 8)
    print



if __name__ == '__main__': main()

