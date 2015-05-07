#!/usr/bin/python3

import argparse
import math
import pprint
import subprocess

__doc__ = """Window Organizer for any "EHWN" window manager"""


__PAD__ = '  '

def print_obj(obj, inline=False, depth=8):
	if depth == 0 or isinstance(obj, str):
		return _print_str_obj(obj, inline)
	depth -= 1
	# Maybe is a dictionary
	try: return _print_dict_obj(obj.__dict__, inline, depth)
	except AttributeError: pass
	# Maybe is an iterable
	try: return _print_iter_obj(obj.__iter__(), inline, depth)
	except AttributeError: pass
	# Well, treat it as string like object
	return _print_str_obj(obj, inline)

def _print_dict_obj(obj_dict, inline, depth):
	newline = '' if inline else '\n'
	lines = '{' + newline
	#for k, v in obj.__dict__.items():
	for k, v in obj_dict.items():
		v_formated = print_obj(v, inline, depth)
		line = "'{}': {}".format(k, v_formated)
		lines += __PAD__ + line + newline
	lines += '}'
	return lines

def _print_iter_obj(obj_iter, inline, depth):
	newline = '' if inline else '\n'
	lines = '[' + newline
	for v in obj_iter:
		v_formated = print_obj(v, inline, depth)
		line = "{}, ".format(v_formated)
		lines += __PAD__ + line + newline
	lines += ']'
	return lines

def _print_str_obj(obj, inline=False):
	return "'{}'".format(obj)



def __print_obj(obj, inline=False):
	pad = '  '
	newline = '' if inline else '\n'
	lines = '{' + newline

	for k, v in obj.__dict__.items():
		try:
			v_str = print_obj(v, inline)
			v_list = v_str.splitlines()
			v_print = ('\n' + pad).join(v_list)
			line = "'{}': {}".format(k, p_value)
		except AttributeError:
			line = "'{}': '{}'".format(k, v)
		lines+= pad + line + newline
	lines += '}'
	return lines

class Point():
#	def __init__(self, x, y):
#		self.x = x
#		self.y = y
#		return
#
#	def __init__(self, value):
#		try:
#			x, y = value.x, value.y
#		except AttributeError:
#			x, y = value
#		self.__init__(x, y)
#		return

	def __init__(self, *args):
		values = args if len(args) >= 2 else args[0]
		try:
			self.x, self.y = values.x, values.y
		except AttributeError:
			self.x, self.y = values
		return

	def __str__(self):
		return '({}, {})'.format(self.x, self.y)

	def __eq__(self, other):
		return self.x == other.x and self.y == other.y

	def __add__(self, other):
		other = Point(other)
		return Point(self.x + other.x, self.y + other.y)

	def __sub__(self, other):
		other = Point(other)
		return Point(self.x - other.x, self.y - other.y)

	def __iadd__(self, other):
		other = Point(other)
		self.x += other.x
		self.y += other.y
		return self

	def __isub__(self, other):
		other = Point(other)
		self.x -= other.x
		self.y -= other.y
		return self

	def distance(self, other):
		other = Point(other)
		x = abs(self.x - other.x)
		y = abs(self.y - other.y)
		return math.hypot(x, y)


class Square():
	def __init__(self, x, y, w, h, anchor=None):
		self._pos = Point(x, y)
		self._size = Point(w, h)
		self.anchor = anchor
		return

	def __str__(self):
		return str(self.__dict__)

	def __contains__(self, other):
		if isinstance(other, Square):
			return (other.tl.x >= self.tl.x and
			        other.tl.y >= self.tl.y and
			        other.br.x <= self.br.x and
			        other.br.y <= self.br.y)
		other =  Point(other)
		return (other.x >= self.tl.x and
		        other.y >= self.tl.y and
		        other.x <= self.br.x and
		        other.y <= self.br.y)

	@property
	def tl(self):
		return Point(self.pos.x, self.pos.y)
	@property
	def tr(self):
		return Point(self.x + self.width, self.pos.y)
	@property
	def bl(self):
		return Point(self.x, self.y + self.height)
	@property
	def br(self):
		return Point(self.x + self.width, self.y + self.height)

	@tl.setter
	def tl(self, value):
		self.pos = value
		return
	@tr.setter
	def tr(self, value):
		self.pos = value - Point(self.width, 0)
		return
	@bl.setter
	def bl(self, value):
		self.pos = value - Point(0, self.height)
		return
	@br.setter
	def br(self, value):
		self.pos = value - self.size
		return


	@property
	def pos(self):
		return Point(self._pos)

	@pos.setter
	def pos(self, value):
		self._pos = Point(value)
		self.update()
		return

	@property
	def x(self):
		return self.pos.x

	@x.setter
	def x(self, value):
		self.pos = value, self.y
		return

	@property
	def y(self):
		return self.pos.y

	@y.setter
	def y(self, value):
		self.pos = self.x, value
		return


	@property
	def size(self):
		return Point(self._size)

	@size.setter
	def size(self, value):
		self._size = Point(value)
		self.update()
		return

	@property
	def width(self):
		return self.size.x

	@width.setter
	def width(self, value):
		self.size = value, self.height
		return

	@property
	def height(self):
		return self.size.y

	@height.setter
	def height(self, value):
		self.size = self.width, value
		return

	@property
	def geometry(self):
		return self.x, self.y, self.width, self.height
	@geometry.setter
	def geometry(self, value):
		self._pos.x, self._pos.y, self._size.x, self._size.y = value
		return


class Window():
	def __init__(self, id, desktop, pid, x, y, width, height, wm_class, machine, title, screens=None):
		self.id = int(id)            # hex number
		self.desktop = int(desktop)  # -1 is stycky window
		self.pid = int(pid)
		self._pos = Point(int(x), int(y))
		self._size = Point(int(width), int(height))
		self.wm_class = str(wm_class)
		self.machine = str(machine)
		self.title = str(title)
		self.screens = screens
		return

	def __str__(self):
		return str(self.__dict__)

	def __eq__ (self, other):
		return self.id == other.id

	@property
	def tl(self):
		return Point(self.pos.x, self.pos.y)
	@property
	def tr(self):
		return Point(self.x + self.width, self.pos.y)
	@property
	def bl(self):
		return Point(self.x, self.y + self.height)
	@property
	def br(self):
		return Point(self.x + self.width, self.y + self.height)

	@tl.setter
	def tl(self, value):
		self.pos = value
		return
	@tr.setter
	def tr(self, value):
		self.pos = value - Point(self.width, 0)
		return
	@bl.setter
	def bl(self, value):
		self.pos = value - Point(0, self.height)
		return
	@br.setter
	def br(self, value):
		self.pos = value - self.size
		return


	@property
	def pos(self):
		return Point(self._pos)

	@pos.setter
	def pos(self, value):
		self._pos = Point(value)
		self.update()
		return

	@property
	def x(self):
		return self.pos.x

	@x.setter
	def x(self, value):
		self.pos = value, self.y
		return

	@property
	def y(self):
		return self.pos.y

	@y.setter
	def y(self, value):
		self.pos = self.x, value
		return


	@property
	def size(self):
		return Point(self._size)

	@size.setter
	def size(self, value):
		self._size = Point(value)
		self.update()
		return

	@property
	def width(self):
		return self.size.x

	@width.setter
	def width(self, value):
		self.size = value, self.height
		return

	@property
	def height(self):
		return self.size.y

	@height.setter
	def height(self, value):
		self.size = self.width, value
		return

	@property
	def geometry(self):
		return self.x, self.y, self.width, self.height
	@geometry.setter
	def geometry(self, value):
		self._pos.x, self._pos.y, self._size.x, self._size.y = value
		return


	def update(self):
		set_wingeometry(self.id, self.x, self.y, self.width, self.height)
		return

	def raise_and_focus(self):
		raisefocus_window(self.id)
		return


class Screen():
	def __init__(self, name, x, y, width, height):
		self.name = name
		self.geometry = Square(x, y, width, height)
		self.inside_windows = []
		self.partial_windows = []
		return

	def __str__(self):
		return str(self.__dict__)

	def __eq__(self, other):
		try: return self.name == other.name
		except: return self.name == other

	def isinside(self, w):
		return w in self.geometry

	def ispartial(self, w):
		"""Match any window that apears even partialy in the screen.

		OBS: This function is inconpleate, it only works on windows that
		any CORNER appears on the screen. If a window is larger than the
		screen on one dimension, one edge can cross the whole screen and
		will not match in this function."""
		return (w.tl in self.geometry or
		        w.tr in self.geometry or
		        w.bl in self.geometry or
		        w.br in self.geometry)

	def read_windows(self, wlist):
		self.inside_windows = [w for w in wlist if self.isinside(w)]
		self.partial_windows = [w for w in wlist if self.ispartial(w)]


class Desktop():
	def __init__(self, opts):
		self.active, self.width, self.height = get_desktopconfig()
		if opts.debug:
			print('desktop {}: {} x {}'.format(self.active, self.width, self.height))
		if self.active < 0 or self.width < 0 or self.height < 0:
			print('Can not get desktop size')
			return

		self.screens = get_screens()
		self.all_windows = get_winlist()

		for s in self.screens:
			s.read_windows(self.all_windows)
		for w in self.all_windows:
			w.screens = [idx for idx, s in enumerate(self.screens) if s.isinside(w)]

		if opts.debug:
			print('Screen list:')
			for s in self.screens: print(print_obj(s, False, 2))

		self.windows = get_windesklist(self.all_windows, self.active)
		self.windows = get_winclasslist(self.windows, opts.filter_class)
		self.windows = get_winscreenlist(self.windows, opts.filter_screen)

		if opts.debug:
			print('Window count: {}'.format(len(self.windows)))
			print('Window list:')
			for w in self.windows: print(print_obj(w, True, -1))
		return

	def __str__(self):
		return str(self.__dict__)

	@property
	def size(self):
		return (self.width, self.height)


def sep_config(arg):
	l = [int(x) for x in arg.split(',')]

	if not (1 <= len(l) <= 4) or min(l) < 0:
		msg = "Argument must be a comma separated list of 1 to 4 positive integers"
		raise argparse.ArgumentTypeError(msg)

	dx = l[0]
	try: dy = l[1]
	except IndexError: dy = dx
	try: startx = l[2]
	except IndexError: startx = dx
	try: starty = l[3]
	except IndexError: starty = startx

	#dx = l[0]
	#dy = l[1] if len(l) >= 2 else dx
	#startx = l[2] if len(l) >= 3 else dx
	#starty = l[3] if len(l) >= 4 else startx
	
	return (dx, dy, startx, starty)


def parseargs():
	parser = argparse.ArgumentParser()
	parser.add_argument('-s', '--sep', type=sep_config, default='25', help='Windows separations in cascade')
	parser.add_argument('-D', '--debug', action='store_true', help='Debug output')
	parser.add_argument('-e', '--edges', action='store_true', help='Send windows to the edges')
	parser.add_argument('-c', '--cascade', action='store_true', help='Cascade windows')
	parser.add_argument('-r', '--alignr', action='store_true', help='Cascade windows are aligned to their top right edges')
	parser.add_argument('-l', '--alignl', action='store_true', help='Cascade windows are aligned to their top left  edges')
	parser.add_argument('-d', '--alignd', action='store_true', help='Cascade windows are aligned in a "smart" dinamic way"')
	parser.add_argument('-F', '--filter_class', help='Apply action only to especified windows class')
	parser.add_argument('-S', '--filter_screen', type=int, help='Apply action only to windows in especified screen')
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


def has_xdotool():
	return cmdcall(['which', 'xdotool']) == 0


def has_wmctrl():
	return cmdcall(['which', 'wmctrl']) == 0


def get_activedesktop():
	d, w, h = get_desktopconfig(None)
	return d
	#return int(cmdoutput(['xdotool', 'get_desktop']))


def get_desktopconfig(desktop=None):
	output = cmdoutput(['wmctrl', '-d'])
	outputlines = output.splitlines()
	for l in outputlines:
		l = l.split(None, 4)
		if (desktop is None and l[1] == b'*') or (int(l[0]) == desktop):
			width, height = l[3].split(b'x', 1)
			return (int(l[0]), int(width), int(height))
	return (-1, -1, -1)


def set_wingeometry(wid, x=-1, y=-1, w=-1, h=-1):
	#print(' '.join(['wmctrl', '-ir', str(wid), '-e', '0,{},{},{},{}'.format(x,y,w,h)]))
	output = cmdcall(['wmctrl', '-ir', str(wid), '-e', '0,{},{},{},{}'.format(x,y,w,h)])
#	wmctrl -ir $winID -e 0,$x,$y,-1,-1
#	#xdotool windowmove --sync $winID $xy $xy
	return


def set_winposition(wid, x, y):
	"""Set the position of a window

        wid: Xorg ID of the window.
	x, y: New coordenades of the window.
	Origin of the screen is the top left corner and the anchor of the window
	too. """
	set_wingeometry(wid, x, y)
	return

def raisefocus_window(wid):
	output = cmdcall(['wmctrl', '-ia', str(wid)])
	return

def raisefocus_window_here(wid):
	output = cmdcall(['wmctrl', '-iR', str(wid)])
	return

def get_screens():
	output = cmdoutput(['xrandr', '-q'])
	outputlines = output.splitlines()
	slist = list()
	for l in outputlines:
		ll = l.split(None, 3)
		s_name = str(ll[0], encoding='utf-8')
		s_connect = ll[1]
		if s_connect != b'connected':
			continue
		# The output may be connected but offline. This try/catch tries
		# to resolve this case.
		try: size, x, y = ll[2].split(b'+')
		except ValueError: continue
		w, h = size.split(b'x')
		s_x = int(x)
		s_y = int(y)
		s_w = int(w)
		s_h = int(h)
		s = Screen(s_name, s_x, s_y, s_w, s_h)
		slist.append(s)
	return slist

def get_winlist():
	output = cmdoutput(['wmctrl', '-lGpx'])
	outputlines = output.splitlines()
	wlist = list()
	for l in outputlines:
		ll=l.split(None, 9)
		w_id = int(ll[0], base=16)
		w_desktop = int(ll[1])
		w_pid = int(ll[2])
		w_x = int(ll[3])
		w_y = int(ll[4])
		w_w = int(ll[5])
		w_h = int(ll[6])
		w_wm_class = str(ll[7], encoding='utf-8')
		w_machine = str(ll[8], encoding='utf-8')
		w_title = str(ll[9], encoding='utf-8')
		w = Window(w_id, w_desktop, w_pid, w_x, w_y, w_w, w_h, w_wm_class, w_machine, w_title)
		wlist.append(w)
	return wlist


def get_windesklist(winlist, desktop):
	return [w for w in winlist if w.desktop == desktop]

def get_winscreenlist(winlist, screen):
	return winlist if screen is None else [w for w in winlist if screen in w.screens]

def get_winclasslist(winlist, wm_class):
	return winlist if wm_class is None else [w for w in winlist if w.wm_class == wm_class]


def get_corner(wlist, corner, desktop_size):
	left = corner in ['tl', 'bl']
	top  = corner in ['tl', 'tr']
	#maxx = max(w.x + w.width  for w in wlist)
	#maxy = max(w.y + w.height for w in wlist)
	maxx = desktop_size[0]
	maxy = desktop_size[1]

	win = wlist[0]
	wind = 0

	for w in wlist:
		wx = w.x if left == True else maxx - (w.x + w.width)
		wy = w.y if top  == True else maxy - (w.y + w.height)
		wd = math.sqrt(wx**2 + wy**2)
		#print('{} {} {}'.format(corner, w.id, wd))

		winx = win.x if left == True else maxx - (win.x + win.width)
		winy = win.y if top  == True else maxy - (win.y + win.height)
		wind = math.sqrt(winx**2 + winy**2)
		if wd < wind: win = w
	return win, wind


def move_to_edges(opts, desktop):
	"""Move windows entirely to the inside the desktop screen"""
	w_hack = 0 # hack for windows decorations

	wl = desktop.windows[:]
	corners_list = ['tl', 'tr', 'bl', 'br']

	while len(corners_list) > 0 and len(wl) > 0:
		select_list = list()
		for corner in corners_list:
			w, d = get_corner(wl, corner, desktop.size)
			select_list.append((w, d, corner))
		w, d, corner  = min(select_list, key=lambda i: i[1])
		x = 0 if corner == 'tl' or corner == 'bl' else desktop.width - w.width - w_hack
		y = 0 if corner == 'tl' or corner == 'tr' else desktop.height - w.height - w_hack
		if opts.debug:
			print('Window select list: {}'.format(select_list))
			print('Window selected:')
			print('  corner: {}'.format(corner))
			print('    w.id: {}'.format(w.id))
			print('       d: {}'.format(w.y))
			print('     w.x: {}'.format(w.x))
			print('     w.y: {}'.format(w.y))
			print('   new x: {}'.format(x))
			print('   new y: {}'.format(y))
		w.pos = (x, y)
		wl.remove(w)
		corners_list.remove(corner)
	return


def cascade(opts, desktop):

	for s in desktop.screens:
		dx, dy, startx, starty = opts.sep
		startx += s.geometry.x
		starty += s.geometry.y
		if opts.debug:
			print('Sep geometry: dx: {} dy: {} startx: {} starty: {}'.format(dx, dy, startx, starty))
		x = startx - dx
		y = starty - dy
		prev_w = None

		for w in sorted(desktop.windows, key=lambda w: w.x):
			if not s.isinside(w):
				continue
			if opts.debug:
				print('Window selected:')
				print('      w.id: {}'.format(w.id))
				print('     w.pos: {}'.format(w.pos))
				print('prev_w.pos: {}'.format(None if prev_w is None else prev_w.pos))

			if prev_w is None:
				prev_w = w

			x += dx
			y += dy

			if opts.alignd and prev_w.width - w.width > 0:
				x += prev_w.width - w.width

			if opts.alignr:
				x += prev_w.width - w.width

			if opts.alignl:
				pass

			w.tl = (x, y)
			w.raise_and_focus()
			prev_w = w

			# If the windows go to the right end of the screen, start from
			# the left again and give an extra space in Y.
			if w.tr.x > desktop.width - 2*dx:
				x = startx - dx
				y += dx
				prev_w = None

			if opts.debug:
				print('   new pos: {}'.format((x,y)))
	return


def main():
	opts = parseargs()
	setoptconsts(opts)
	desktop = Desktop(opts)
	if opts.debug:
		print('desktop size: {}'.format(desktop.size))

	if opts.edges:
		move_to_edges(opts, desktop)
	if opts.cascade:
		cascade(opts, desktop)


if __name__ == '__main__': main()

