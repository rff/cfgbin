#!/usr/bin/python3

import os
import argparse
import pathlib


def char(string):
    if len(string) != 1:
         msg = '"{}" is not a single character'.format(string)
         raise argparse.ArgumentTypeError(msg)
    return string

def perfect_square(string):
     value = int(string)
     sqrt = math.sqrt(value)
     if sqrt != int(sqrt):
         msg = "%r is not a perfect square" % string
         raise argparse.ArgumentTypeError(msg)
     return value

def parse():
    parser = argparse.ArgumentParser()
    parser.add_argument('-v', '--verbose', action='store_true',
                        help="Verbose/Debug output")
    parser.add_argument('-a', '--above', action='store_true',
                        help="Show index numbers above path line (default is below)")
    parser.add_argument('-l', '--left', action='store_const', dest="align",
                        default='left', const='left',
                        help="Show index numbers left aligned with its path\
                              componet (that iis the default)")
    parser.add_argument('-r', '--right', action='store_const', dest="align",
                        default='left', const='right',
                        help="Show index numbers righ aligned with its path\
                              componet (default is left aligned)")
    parser.add_argument('-c', '--center', action='store_const', dest="align",
                        default='left', const='center',
                        help="Show index numbers center aligned with its path\
                              componet (default is left aligned)")
    parser.add_argument('-s', '--sep', type=char, default=' ',
                        help="Single char to use as path separators in index numbers")
    parser.add_argument('-f', '--fill', type=char, default=' ',
                        help="Single char to use as fill char bettwen index numbers")
    parser.add_argument('-C', '--color', action='store_true',
                        help="Use colors in output (default is no)")
    return parser.parse_args()


def setoptsconstants(opt):
#    opt.SEP = ' '
#    opt.FILL = ' '
    return


def get_path():
    #pwd = os.environ['PWD'];
    #pwd = os.getenv('PWD');
    path = os.getcwd();
    return path


def main():
    opt = parse()
    setoptsconstants(opt)

    path = pathlib.PurePath(get_path());
    index = len(path.parts) - 1
    line = ''
    fill = ''
    for part in path.parts[1:]:
        index -= 1
        num = str(index)
        if opt.align == "right":
            fill = opt.fill * (len(part) - len(num))
            line += opt.sep + fill + num
        elif opt.align == "center":
            line += fill
            fill = opt.fill * (round((len(part) - len(num)) / 2))
            line += opt.sep + fill + num
            fill = opt.fill * (len(part) - len(num) - len(fill))
        elif opt.align == "left":
            line += fill + opt.sep + num
            fill = opt.fill * (len(part) - len(num))
        else:
            raise Exception("align invalid argument")

    if opt.color:
        colorpath=''
        color = False
        for part in path.parts[1:]:
            colorpath += '/'
            #part = '/' + part
            colorpath += '\033[37m' + part + '\033[0m' if color else part
            color = not color
        path = colorpath

    if opt.above:
        print(line)
        print(path)
    else:
        print(path)
        print(line)



if __name__ == '__main__': main()
