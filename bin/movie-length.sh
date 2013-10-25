#!/bin/bash

if [ $# -lt 1 ] ; then
	exit 1
fi

for i in "$@" ; do
	echo -n "$i: " ;
	find $i -type f  -print0 |
		xargs -0  mplayer -vo dummy -ao dummy -identify 2>/dev/null |
		perl -nle '/ID_LENGTH=([0-9\.]+)/ && ($t +=$1) && printf "%02d:%02d:%02d\n",$t/3600,$t/60%60,$t%60' |
		tail -n 1 ;
done

exit $?
