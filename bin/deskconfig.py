#!/usr/bin/python3

import argparse
import math
import pprint
import subprocess


class Window():
	def __init__(self, id, desktop, x, y, width, height, machine, title):
		self.id=int(id)            # hex number
		self.desktop=int(desktop)  # -1 is stycky window
		self.x=int(x)
		self.y=int(y)
		self.pos=(int(x), int(y))
		self.width=int(width)
		self.height=int(height)
		self.size=(int(width), int(height))
		self.machine=str(machine)
		self.title=str(title)

	def __str__(self):
		return str(self.__dict__)

	def __eq__ (self, other):
		return self.id == other.id
 #and
		       #self.desktop == o.desktop and
		       #self.x == o.x and
		       #self.y == o.y and
		       #self.width == o.width and
		       #self.height == o.height and
		       #self.machine == o.machine and
		       #self.title == o.title


def parseargs():
	parser = argparse.ArgumentParser()
	parser.add_argument('-s', '--sep', type=int, default=0, help='Windows separations')
	parser.add_argument('-c', '--color', action='store_true', help='Color output')
	return parser.parse_args()


def setoptconsts(opts):
	opts.VERSION = '0.0.0'
	return opts


def cmdcall(arg):
	return subprocess.call(arg)


def cmdoutput(arg):
	#output = subprocess.Popen(['cmd', 'args'], stdout=subprocess.PIPE).output
	#for l in output: print('line: "{}"'.format(l))
	return subprocess.check_output(arg)


def get_activedesktop():
	return int(cmdoutput(['xdotool', 'get_desktop']))

def get_desktopsize(desktop):
	output = cmdoutput(['wmctrl', '-d'])
	outputlines = output.splitlines()
	for l in outputlines:
		l = l.split(None, 4)
		if int(l[0]) == desktop:
			width, height = l[3].split(b'x', 1)
			return (int(width), int(height))
	return (-1, -1) 

def set_winposition(wid, x, y):
	output = cmdcall(['wmctrl', '-ir', str(wid), '-e', '0,{},{},-1,-1'.format(x,y)])
#	wmctrl -ir $winID -e 0,$x,$y,-1,-1
#	#xdotool windowmove --sync $winID $xy $xy


def get_winlist():
	output = cmdoutput(['wmctrl', '-lG'])
	outputlines = output.splitlines()
	wlist = list()
	for l in outputlines:
		ll=l.split(None, 7)
		w_id = int(ll[0], base=16)
		w_desktop = int(ll[1])
		w_x = int(ll[2])
		w_y = int(ll[3])
		w_w = int(ll[4])
		w_h = int(ll[5])
		w_machine = str(ll[6])
		w_title = str(ll[7])
		w = Window(w_id, w_desktop, w_x, w_y, w_w, w_h, w_machine, w_title)
		wlist.append(w)
	return wlist


def get_windesklist(winlist, desktop):
	return [w for w in winlist if w.desktop == desktop]


def get_corner(wlist, corner):
	left = corner == 'tl' or corner == 'bl'
	top  = corner == 'tl' or corner == 'tr'
	maxx = max(w.x + w.width  for w in wlist)
	maxy = max(w.y + w.height for w in wlist)

	win = wlist[0]
	wind = 0

	for w in wlist:
		wx = w.x if left == True else maxx - (w.x + w.width)
		wy = w.y if top  == True else maxy - (w.y + w.height)
		wd = math.sqrt(wx**2 + wy**2)
		winx = win.x if left == True else maxx - (win.x + win.width)
		winy = win.y if top  == True else maxy - (win.y + win.height)
		wind = math.sqrt(winx**2 + winy**2)
		if wd < wind: win = w
	return win, wind


def main():
	opts = parseargs()
	setoptconsts(opts)

	w_hack = 2 # hack for windows decarations

	d = get_activedesktop()
	wl = get_winlist()
	wdl = get_windesklist(wl, d)
	d_width, d_height = get_desktopsize(d)
	print('desktop {}: {} x {}'.format(d, d_width, d_height))
	if d_width < 0 or d_height < 0:
		print('Can not get desktop size')
		return

	corners_list = ['tl', 'tr', 'bl', 'br']
	while len(corners_list) > 0 and len(wdl) > 0:
		select_list = list()
		for corner in corners_list:
			w, d = get_corner(wdl, corner)
			select_list.append((w, d, corner))
		w, d, corner  = min(select_list, key=lambda i: i[1])
		x = 0 if corner == 'tl' or corner == 'bl' else d_width - w.width - w_hack
		y = 0 if corner == 'tl' or corner == 'tr' else d_height - w.height - w_hack
		set_winposition(w.id, x, y)
		wdl.remove(w)
		corners_list.remove(corner)


if __name__ == '__main__': main()
