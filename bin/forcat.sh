#!/bin/bash

# reference from:
#   http://unix.stackexchange.com/questions/31947/how-to-add-a-newline-to-the-end-of-a-file/263965#263965

set -e
set -u

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
GREY='\e[37m'
DEFAULT='\e[39m'
RESET='\e[0m'

BOLD='\e[1m'
DIM='\e[2m'
ITALIC='\e[3m'       # seems like only rxvt.
UNDERLINE='\e[4m'
BLINK='\e[5m'
REVERSE='\e[7m'
HIDDEN='\e[8m'

for f in "$@" ; do
	ftype="$(file -b --mime-type $f)"
	feof="$(tail -c1 $f)"

	echo -e -n "${GREY}${f}${RESET} :"

	if [[ "${ftype}" == "inode/x-empty" ]] ; then
		echo -e " ${RED}<Empty file>${RESET}"
		continue
	fi
	if [[ "${ftype}" != "text/"* ]] ; then
		echo -e " ${RED}<Non text file>${RESET}"
		continue
	fi
#	if [[ -n "${feof}" ]] ; then
#		echo -e " ${RED}<No new line at end-of-file>${RESET}"
#	else
#		echo
#	fi
	echo 
	echo -e "${YELLOW}----------------------------${RESET}"
	cat $f
	[[ -n "${feof}" ]] && 
		echo -e "\n${RED}<No new line at end of file>${RESET}"
	echo -e "${YELLOW}============================${RESET}"
done
