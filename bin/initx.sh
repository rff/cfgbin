#!/bin/sh

export DISPLAY=${1:-":0"}
X ${DISPLAY} -quiet -terminate           & sleep 2
openbox                                  & sleep 1

monitors=$(xrandr | grep -wc "connected")


CONKY_SHOW_ARCS='false'
CONKY_NORGE_POS='-a bl -x 10 -y -120'
URXVT_ALSAMIXER_POS='68x16-0-0'
URXVT_DEFAULT_POS='80x24+646+0'
XTERM_DEFAULT_POS='80x56+0+0'


if [ "${monitors}" == "2" ] ; then
	xrandr -display ${DISPLAY}                   \
	       --output VGA1  --auto --pos 0x0       \
	       --output LVDS1 --auto --pos 120x1080

	CONKY_SHOW_ARCS='true'
	CONKY_NORGE_POS='-a tr -x 130 -y 1080'
	URXVT_ALSAMIXER_POS='80x24-120+1230'
	URXVT_DEFAULT_POS='80x48+120-0'
	XTERM_DEFAULT_POS='80x48+0+0'
else
	true
	# xrandr --output LVDS1 --auto
fi

setxkbmap -display ${DISPLAY} us intl
xrdb -display ${DISPLAY} ~/.Xresources

nitrogen --restore

conky --display ${DISPLAY} -qbd -c ~/.config/conky/default.conkyrc 
conky --display ${DISPLAY} -qbd -c ~/.config/conky/norge.conkyrc      ${CONKY_NORGE_POS}
#conky --display ${DISPLAY} -qbd -c ~/.config/conky/auler.conkyrc      -a tr -x 370 -y 5
#conky --display ${DISPLAY} -qbd -c ~/.config/conky/arcs.conkyrc       -a tr -x 660 -y 5
$CONKY_SHOW_ARCS && conky --display ${DISPLAY} -qbd -c ~/.config/conky/arcs_small.conkyrc -a br -x 130 -y 5

urxvtd -q -f -o
urxvt  -display ${DISPLAY} -geometry ${URXVT_ALSAMIXER_POS} -name urxvt-bg -tr -fg gray -e alsamixer -g
urxvtc -display ${DISPLAY} -geometry ${URXVT_DEFAULT_POS}
xterm  -display ${DISPLAY} -geometry ${XTERM_DEFAULT_POS} &


if ! dropbox running ; then
        dropbox stop
fi
dropbox start

