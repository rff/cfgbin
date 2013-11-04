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

INDEX=( {0..15} )

OPTCOLORS=( "${COLORS[@]}" )
OPT="${1:-'-i'}"


[ ${OPT} == '-c' ] && OPTCOLORS=( "${COLORS[@]}" )
[ ${OPT} == '-i' ] && OPTCOLORS=( "${INDEX[@]}" )


RANDOM=$(date +%N)
size=${#OPTCOLORS[@]}
(( i=$RANDOM % $size ))
color=${OPTCOLORS[i]}



urxvtc -cr $color
