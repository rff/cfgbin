#!/usr/bin/python3

import os
import argparse
import subprocess
import sys

def parse():
	parser = argparse.ArgumentParser()
	parser.add_argument('args', nargs=argparse.REMAINDER,
	                    help="Arguments to be passed to topbuild.")
	return parser.parse_args()
### END parse


def calltb(args):
		return subprocess.call(['topbuild'] + args)
### END calltb


def findtoplevel():
	topbuildproj = './repos/toplevel/topbuild.proj'
	path = '.'
	path = os.getcwd()
	#path = os.path.abspath(path) ## i belive it is not needed when the path comes from getcwd (PWD)
	path = os.path.realpath(path)
	while path != '' and path != '/':
		if os.path.isfile(os.path.join(path, topbuildproj)):
			return path
		path, tail = os.path.split(path)
	return None

### END findtoplevel

def main():
	opt = parse()

	initdir = os.getcwd()
	topleveldir = findtoplevel()
	if topleveldir != None:
		os.chdir(topleveldir)
		try:
			r = calltb(opt.args)
		except OSError as e:
			print('Execution failed:', e, file=sys.stderr);
		else:
			if r < 0: print('Child terminated by signal:', -r, file=sys.stderr)
			else:     print('Child returned with code:', r, file=sys.stderr)
		finally:
			pass
		### END try
		os.chdir(initdir)
	else:
		print('Topbuild project not found!', file=sys.stderr);	
	### END if
### END main


### CALL MAIN
if __name__ == '__main__': main()

