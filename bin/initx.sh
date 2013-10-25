#!/bin/sh

export DISPLAY=${1:-":0"}
X ${DISPLAY} -quiet -terminate           & sleep 2
openbox                                  & sleep 1
xrandr -display ${DISPLAY}               \
       --output VGA1  --auto --pos 0x0 \
       --output LVDS1 --auto --pos 120x1080 #; sleep 1
nitrogen --restore                       #; sleep 1

conky --display ${DISPLAY} -qbd -c ~/.config/conky/norge.conkyrc      -a tr -x 130 -y 1080
conky --display ${DISPLAY} -qbd -c ~/.config/conky/default.conkyrc    -a tr -x 10  -y 5
#conky --display ${DISPLAY} -qbd -c ~/.config/conky/auler.conkyrc      -a tr -x 370 -y 5
#conky --display ${DISPLAY} -qbd -c ~/.config/conky/arcs.conkyrc       -a tr -x 660 -y 5
conky --display ${DISPLAY} -qbd -c ~/.config/conky/arcs_small.conkyrc -a br -x 130 -y 5

urxvtd -q -f -o
urxvtc -display ${DISPLAY} -geometry 80x24-120+1230 -name urxvt-bg -tr -e alsamixer -g
urxvtc -display ${DISPLAY} -geometry 80x48+120-0

xterm  -display ${DISPLAY} -geometry 80x48+0+0 &

setxkbmap -display ${DISPLAY} us intl

if ! dropbox running ; then
        dropbox stop
fi
dropbox start
