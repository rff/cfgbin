#!/bin/bash

### get active desktop ID.
desktopID=$(xdotool get_desktop)

xy=0
step=20

### list windows from all desktops including
### geometry information and sorted by Y position
### OBS: The list command is in the end of the while loop.

while read winID deskID x y w h res; do
	#$winID $deskID $x $y $w $h
	[ $deskID -ne $desktopID ] && continue
	#xdotool windowmove --sync $winID $xy $xy
	wmctrl -iR $winID 
	wmctrl -ir $winID -e 0,$xy,$xy,-1,-1
	(( xy+=step )) 
	printf "%s %2d %4d %4d %4d %4d $res\n" $winID $deskID $x $y $w $h
done < <(wmctrl -lG | sort -h -k 4)

### Old code I got from which I create mine code.
#for windowId in $(xdotool search --desktop $desktopID "") ; do
#	echo "--- winID $windowId ---"
#	xdotool getwindowname $windowId
#	xdotool getwindowgeometry --shell $windowId
##	#xdotool windowmove --sync $windowId $xy $xy; 
##	((xy+=40)); 
#done

