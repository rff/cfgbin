#!/usr/bin/python3

import argparse
import random
import pprint

def hourtominutes(h):
	return h * 60

def formatminutes(m, sep=''):
	mm = m % 60
	hh = m // 60
	return '{0:02}{1}{2:02}'.format(hh, sep, mm)

def parse():
	parser = argparse.ArgumentParser()
	parser.add_argument('-d', '--days', type=int, default=20,
	                    help="How many days to generate time")
	parser.add_argument('-s', '--sep', type=str, default='',
	                    help="Separation char for time format")
	parser.add_argument('-v', '--verbose', action='store_true',
	                    help="Verbose/Debug output")
	parser.add_argument('-a', '--ajust', action='store_true',
	                    help="Make total drift end in 0")
	return parser.parse_args()
### end parse


def setoptsconstants(opt):
	opt.START = hourtominutes(8)
	opt.END   = hourtominutes(17)
	opt.LUNCH = hourtominutes(1)
	opt.HOURS = opt.END - opt.START - opt.LUNCH
	opt.DRIFT = 9
	opt.SHIFT = (opt.START, opt.END)
### end setoptsCONSTANTS


def main():
	opt = parse()
	setoptsconstants(opt)

	time_total  = 0 
	drift_total = 0
	sheet = []
	for i in range(opt.days):
		sheet.append([])

		d_start = random.randint(-opt.DRIFT, opt.DRIFT)
		d_end = random.randint(-opt.DRIFT, opt.DRIFT)

		if opt.ajust:
			# max/min possibel drift to the rest of days
			d_max = (opt.days - i -1) * 2 * opt.DRIFT
			if drift_total > d_max:
				delta = drift_total - d_max
				random.randrange(delta)
				d_start = delta - i
				d_end = -i
			elif -drift_total > d_max:
				delta = -drift_total - d_max
				i = random.randrange(delta)
				d_start = -(delta - i)
				d_end = i
			### end if ###
		### end if ###

		t_start = opt.START + d_start
		t_end = opt.END + d_end
		t_day = t_end - t_start - opt.LUNCH

		drift_total += d_end - d_start
		time_total += t_day

		sheet[i].append(t_start)
		sheet[i].append(t_end)
		sheet[i].append(formatminutes(t_start, sep=opt.sep))
		sheet[i].append(formatminutes(t_end, sep=opt.sep))
		sheet[i].append(t_day)
		sheet[i].append(formatminutes(t_day, sep=opt.sep))
		sheet[i].append('{:2} {:2}'.format(d_start, d_end))
		sheet[i].append(drift_total)
	### end for ###

	t = time_total
	d = drift_total
	fmt_t = formatminutes(t, sep=opt.sep)
	t_theoric = opt.days * opt.HOURS
	fmt_t_theoric = formatminutes(t_theoric, sep=opt.sep)

	if opt.verbose:
		pprint.pprint(sheet)
		print('counted: {} ({})'.format(t, fmt_t))
		print('theoric: {} ({})'.format(t_theoric, fmt_t_theoric))
		print('drift: {} | {}'.format(d, t - t_theoric))
	### end if ###

	for day in sheet:
		print('{} - {}'.format(day[2], day[3]))
	### end for ###
### end main


if __name__ == '__main__':
	main()

