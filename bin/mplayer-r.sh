#!/bin/bash

[ $# -lt 1 ] && exit 1

KEEP='false'
DEBUG='false'

if [ $1 == '-d' ] ; then
	DEBUG='true'
	shift
fi
if [ $1 == '-k' ] ; then
	KEEP='true'
	shift
fi

TMPFILE="$(mktemp --suffix='.playlist')" || exit 1
trap "[ $KEEP == false ] && rm -f -- '$TMPFILE'" EXIT




find "$@" -type f | sort -R > "$TMPFILE" || exit 1

[ $DEBUG == 'true' ] &&	echo "tmpfile and size: $(wc -l $TMPFILE)"

mplayer -playlist "$TMPFILE" || exit 1

[ $KEEP == 'false ' ] && rm -f -- "$TMPFILE"
trap - EXIT
exit 0
