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

RANDOM=$(date +%N)
size=${#COLORS[@]}
(( i=RANDOM % $size ))
color=${COLORS[i]}

urxvtc -cr $color
