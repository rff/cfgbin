#!/usr/bin/python3

import os
import argparse
import subprocess
import sys


LOCAL_TOPBUILD_CMD='/home/raoni/ws/git/topbuild/src/topbuild/main.py'

def __parse():
	parser = argparse.ArgumentParser()
	parser.add_argument('args', nargs=argparse.REMAINDER,
	                    help="Arguments to be passed to topbuild.")
	return parser.parse_args()

def parse():
	class Empty(object):
		pass
	c = Empty()
	c.args = sys.argv[1:]
	return c
### END parse


def calltb(args):
		return subprocess.call(['python', LOCAL_TOPBUILD_CMD] + args)
### END calltb


def findtoplevel():
	topbuildproj = './repos/toplevel/topbuild.proj'
	path = '.'
	path = os.getcwd()
	#path = os.path.abspath(path) ## i belive it is not needed when the path comes from getcwd (PWD)
        #path = os.path.realpath(path) ## it removes symlinks, may not be a
                                       ## good idea, what if we link a folder
                                       ## from outside the repo. If we come
                                       ## inside the folder, it would not find
                                       ## that we are in a tb repo.
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
		#print('Topbuild project found!', file=sys.stderr);	
		execdir = topleveldir
	else:
		#print('Topbuild project not found!', file=sys.stderr);	
		execdir = initdir
	### END if
	os.chdir(execdir)
	try:
		r = calltb(opt.args)
	except OSError as e:
		print('Execution failed:', e, file=sys.stderr);
	else:
		if r < 0: print('Child terminated by signal:', -r, file=sys.stderr)
		#else:     print('Child returned with code:', r, file=sys.stderr)
	finally:
		pass
	### END try
	os.chdir(initdir)
### END main


### CALL MAIN
if __name__ == '__main__': main()

