#!/bin/sh
#
# source: http://rcr.io/words/dynamic-xterm-colors.html
# reddit: http://www.reddit.com/r/commandline/comments/2ds233/xterm_party/


OPT=$1
COLOR=$2
INDEX=$3
CODE=''
EXTRA=''

case ${OPT} in
	'co' ) CODE=4 ; EXTRA=";${INDEX};" ;;  # System color N
	'fg' ) CODE=10 ;;                      # Foreground
	'bg' ) CODE=11 ;;                      # Background
	'cu' ) CODE=12 ;;                      # Cursor pointer
	'mo' ) CODE=13 ;;                      # Mouse pointer
	* )
		echo "Invalid option '${OPT}'."
		exit 1
	;;
esac

echo -en "\033]${CODE}${EXTRA};#${COLOR}\007"
