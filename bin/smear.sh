#!/bin/bash

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
DEFAULT='\e[39m'
RESET='\e[0m'

BOLD='\e[1m'
DIM='\e[2m'
ITALIC='\e[3m'       # seems like only rxvt.
UNDERLINE='\e[4m'
BLINK='\e[5m'
REVERSE='\e[7m'
HIDDEN='\e[8m'


color=$DEFAULT

lines=${LINES:-$(tput lines)}
columns=${COLUMNS:-$(tput cols)}
sep=' '
reverse='false'
newline=''

skipnext=0
# $ARG -> argument to be processed.
# $1 -> next argument.
# $skipnext -> next X param were consumed in an argument handling, so skip them
# shift command -> keep $@ in sync with the "$@" passed to the for function, so
#     $1 aways points to the next param.
for ARG in "$@" ; do
    shift
    if (( skipnext > 0 )) ; then
        (( skipnext-- ))
        continue
    fi

     case "$ARG" in
         -l | --lines )
             lines=$1
             skipnext=1
         ;;

         -c | --columns )
             columns=$1
             skipnext=1
         ;;

         -n | --no-newline )
             newline='-n'
         ;;

	 -r | --reverse )
             reverse='true'
         ;;

         --color )
             #COLOR=$1
             echo "Option not implemented. Ignoring."
             skipnext=1
         ;;

         =? )
             sep=${ARG: -1}
         ;;

         * )
             echo "Invalid argument: $ARG"
             exit 1
         ;;
    esac
done

if [ $reverse == 'true' ] ; then
    color=$REVERSE
fi


eval printf -v linetoprint "%0.s${sep}" {1..${columns}}

echo -en "${color}"
for (( i = 0; i < lines; i++ )) ; do
    echo $newline $linetoprint
done
echo -e "${RESET}"

exit 0
