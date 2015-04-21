#!/bin/bash

if ! which xdotool &>/dev/null ; then
	echo "ERROR: xdotool not found"
	exit 1
fi
if ! which wmctrl &>/dev/null ; then
	echo "ERROR: wmctrl not found"
	exit 1
fi


### get active desktop ID.
desktopID=$(xdotool get_desktop)

xy=20
x=$xy
y=$xy
step=20
prev_w=0
alignr='no'

[ "$1" == '-r' ] && alignr='yes'




### list windows from all desktops including
### geometry information and sorted by Y position
### OBS: The list command is in the end of the while loop.
while read winID deskID winX winY winW winH winRES; do
	[ "$deskID" -ne "$desktopID" ] && continue
	if [ "$alignr" == 'yes' ] ; then
		#(( x = prev_w > w ? xy + prev_w - w : xy ))
		(( prev_w = prev_w == 0 ? winW : prev_w ))
		(( x = x + prev_w - winW ))
		(( x = x < 0 ? y : x ))
		(( prev_w = winW ))
	else
		(( x = y ))
	fi
	wmctrl -iR $winID
	wmctrl -ir $winID -e 0,$x,$y,-1,-1
	#xdotool windowmove --sync $winID $xy $xy
	(( y += step ))
	(( x += step ))
	printf "%s %2d %4d %4d %4d %4d %s\n" $winID $deskID $winX $winY $winW $winH
done < <(wmctrl -lG | sort -h -k 4)




### Old code I got from which I create mine code.
#for windowId in $(xdotool search --desktop $desktopID "") ; do
#	echo "--- winID $windowId ---"
#	xdotool getwindowname $windowId
#	xdotool getwindowgeometry --shell $windowId
##	#xdotool windowmove --sync $windowId $xy $xy; 
##	((xy+=40)); 
#done

