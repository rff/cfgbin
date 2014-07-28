#!/bin/bash
# chtermc.sh: change terminal colors on the fly.
#
# TODO:
# - support other terminals.
# - rewrite in python.
# - use tput, so it can be a lot more flexible, maybe solve support to other
#   terminals.

set -e -u 

# Tango color scheme
D_black='#2e3436'
L_black='#555753'
D_red='#cc0000'
L_red='#ef2929'
D_green='#4e9a06'
L_green='#8ae234'
D_yellow='#c4a000'
L_yellow='#fce94f'
D_blue='#3465a4'
L_blue='#729fcf'
D_magenta='#75507b'
L_magenta='#ad7fa8'
D_cyan='#06989a'
L_cyan='#34e2e2'
D_white='#d3d7cf'
L_white='#eeeeec'

D_background='#202020'
L_foreground='#d0d090'
L_cursor='#60f080'

ESC='\e'  # \033, \e, \[
BEL='\a'  # \007, \a, \G ?


TANGO_LIST=( "${D_black}" "${D_red}"     "${D_green}" "${D_yellow}"
             "${D_blue}"  "${D_magenta}" "${D_cyan}"  "${D_white}"
             "${L_black}" "${L_red}"     "${L_green}" "${L_yellow}"
             "${L_blue}"  "${L_magenta}" "${L_cyan}"  "${L_white}" )

FG="$L_foreground"

MONO_LIST=( "$FG" "$FG" "$FG" "$FG" "$FG" "$FG" "$FG" "$FG"
            "$FG" "$FG" "$FG" "$FG" "$FG" "$FG" "$FG" "$FG" )

clist=( "${TANGO_LIST[@]}" )

while getopts 'c:tm' arg ; do
	case ${arg} in
		c ) clist=(  $( for i in {0..16} ; do printf ' #%06x' ${OPTARG} ; done) ) ;;
		m ) clist=( "${MONO_LIST[@]}"  ) ;;
		t ) clist=( "${TANGO_LIST[@]}" ) ;;
		? ) exit 1 ;;
	esac
done

# "${ESC}" "]4;" "$i" ";" "${CLIST[$i]}" "${BEL}"

i=0
for rgb in "${clist[@]}" ; do
	echo -en "${ESC}]4;$i;${rgb}${BEL}"
	(( i++ )) || true
done

# URxvt.keysym.M-C-l: command:
# \033]10;#C0C0C0\007
# \033]11;#C0C0C0\007
# 
# URxvt.keysym.M-C-l: command:
# \033]10;#000000000000\007
# \033]11;#FFFFFFFFFFFF\007
# 
# URxvt.keysym.M-C-d: command:
# \033]10;#00FF00\007
# \033]11;#000000\007
# 
# \033]5;0;#00FF00\007
# \033]\007


