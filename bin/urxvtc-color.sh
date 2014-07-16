#!/bin/bash

COLORS=(
	"Red3"
	"Green3"
	"Yellow3"
	"Blue3"
	"Magenta3"
	"Cyan3"
	"Grey25"
	"Red"
	"Green"
	"Yellow"
	"Blue"
	"Magenta"
	"Cyan"
	"Black"
	"White"
)

INDEX=(
#	0   # gray
	1   # red
	2   # green
	3   # yellow
	4   # blue
	5   # purple
#	6   # cyan
#	7   # white
#	8   # light gray
	9   # bright red
	10  # bright green
	11  # bright yellow
	12  # bright blue
	13  # bright purple
#	14  # bright cyan
#	15  # white
)

OPTCOLORS=( "${COLORS[@]}" )
OPT=${1:-'-i'}


[ ${OPT} == '-c' ] && OPTCOLORS=( "${COLORS[@]}" )
[ ${OPT} == '-i' ] && OPTCOLORS=( "${INDEX[@]}" )


RANDOM=$(date +%N)
size=${#OPTCOLORS[@]}
(( i=$RANDOM % $size ))
color=${OPTCOLORS[i]}



urxvtc -cr $color
