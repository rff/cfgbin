#!/bin/bash

[ "$#" -eq '0' ] && exit 0

# get arguments.
d1=$1
d2=${2:-$(xdotool get_desktop)}

# Get number of desktops.
dn=$(xdotool get_num_desktops)

relative='no'

if [ "${d1:0:1}" == '+' ] || [ "${d1:0:1}" == '-' ] ; then
	relative='yes'
fi

# Test if the input are numbers.
test "$d1" -eq "$d1" &>/dev/null || exit 1
test "$d2" -eq "$d2" &>/dev/null || exit 1

if [ "$relative" == 'yes' ] ; then
	(( d1 = d2 + d1 ))
	[ "$d1" -lt '0'   ] && (( d1 = dn - 1 ))
	[ "$d1" -ge "$dn" ] && (( d1 = 0 ))
fi


# Test bounds, valid desktop numbers.
[ "$d1" -lt '0' ] && exit 1
[ "$d2" -lt '0' ] && exit 1
[ "$d1" -ge "$dn" ] && exit 1
[ "$d2" -ge "$dn" ] && exit 1

# Test if is the same desktop twice.
[ "$d1" -eq "$d2" ] && exit 0

# Take list of windows in each desk.
l1="$(xdotool search --desktop $d1 '' 2>/dev/null)"
l2="$(xdotool search --desktop $d2 '' 2>/dev/null)"

#echo $d1 $l1
#echo $d2 $l2

for w in $l1 ; do
	xdotool set_desktop_for_window $w $d2
done
for w in $l2 ; do
	xdotool set_desktop_for_window $w $d1
done

exit 0
