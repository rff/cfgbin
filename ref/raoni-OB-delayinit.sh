#!/bin/bash
	sleep 4

	# all of this is for the conky proper position on the screen
	screendata=$(xrandr | perl -ne 'if (/(^\w+)\W+connected\W+(\d+)x(\d+)([+-]\d+)([+-]\d+)/) {print "$1 $2 $3 $4 $5\n";}')
	monitors=$(xrandr | grep "connected" | wc -l)
	xpos=10
	ypos=0
	conkyrc="/home/raoni/.config/conky/arcs.conkyrc"
	#conkyrc="~/.conky/default.conkyrc"

	if [ "$monitors" == "2" ] ; then
		(( xpos += 120 ))
		xrandr --output VGA1 --auto --pos 120x0 --output LVDS1 --auto --pos 0x900
	else
		xrandr --output LVDS1 --auto
	fi

	nitrogen --restore &
#	tint2 &
	conky -x $xpos -y $ypos -c $conkyrc &
#	gnome-volume-control-applet &
#	gnome-power-manager &
#	nm-applet &
#	x-terminal-emulator &
	xterm &
#	nautilus --browser --no-desktop &

#	if ! dropbox running ; then
#		dropbox stop
#	fi
#	dropbox start
