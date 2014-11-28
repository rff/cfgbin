#!/bin/sh
#
# source: http://rcr.io/words/dynamic-xterm-colors.html
# reddit: http://www.reddit.com/r/commandline/comments/2ds233/xterm_party/


A=0
F="0.1"
CODE=10

case ${1:-'fg'} in
	'bg' ) CODE=11 ;;
	'cu' ) CODE=12 ;;
	'mo' ) CODE=13 ;;
	'fg' ) CODE=10 ;;
	* ) 
		echo "Invalid option '$1'."
		exit 1
	;;
esac

while true; do
	test $A -eq 628318 && A=0 || A=$((A + 1))

	R=$(echo "s ($F*$A + 0)*127 + 128" | bc -l | cut -d'.' -f1)
	B=$(echo "s ($F*$A + 2)*127 + 128" | bc -l | cut -d'.' -f1)
	G=$(echo "s ($F*$A + 4)*127 + 128" | bc -l | cut -d'.' -f1)

	printf "\033]%d;#%02x%02x%02x\007" ${CODE} $R $B $G

	sleep 0.01
done

