#!/bin/bash

IDENT="sed \\'s/^/  /\\'"
NOIDENT='cat'
PREFIX='node-'
HOSTS_DEFAULT="${PREFIX}sc00 ${PREFIX}sc01 ${PREFIX}pl00 ${PREFIX}pl01"
HOSTS_EXTRA="${PREFIX}pl02 ${PREFIX}cmm"

RED='\e[31m'
GREEN='\e[32m'
YELLOW='\e[33m'
BLUE='\e[34m'
MAGENTA='\e[35m'
CYAN='\e[36m'
DEFAULT='\e[39m'
RESET='\e[0m'
COLOR=$GREEN

prefix=$PREFIX
hosts=''
dryrun=''
verbose='false'
ident=$IDENT

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
		-a | --all )
			hosts+=" ${HOSTS_DEFAULT}"
			;;

		-x | --extra )
			hosts+=" ${HOSTS_EXTRA}"
			;;

		 -p | --prefix )
			if [ $1 == '-' ] ; then
				prefix=${PREFIX}
			else
				prefix=$1
			fi
			skipnext=1
			;;

		 -n | --noprefix )
			prefix=''
			;;

		-d | --dryrun )
			dryrun='echo [dryrun]'
			;;

		-v | --verbose )
			verbose='true'
			;;

		-i | --ident )
			ident=$IDENT
			;;

		-r | --noident | --raw )
			ident=$NOIDENT
			;;

		-- )
			cmd="$@"
			parse='false'
			break
			;;
		* )
			hosts+=" ${prefix}${ARG}"
			;;
	esac
done

maxlen=0
for h in $hosts ; do
	len=${#h}
	[ $len -gt $maxlen ] && maxlen=$len
done

#(( llen=maxlen/2 ))
#(( rlen=maxlen-llen ))

for h in $hosts ; do
#	echo "-------- $h --------"
#	printf -- "------- %-${maxlen}s ----------------------------------------\n" "$h"
	echo -e "${COLOR}${h}:${RESET}"
	[ $verbose == 'true' ] && echo "[cmd] ssh $h $cmd" 2>&1 | sed 's/^/    /'
	$dryrun ssh $h "$cmd" 2>&1 | sed 's/^/    /'
done

#echo "-------- DONE --------"
#printf -- "------- %.${maxlen}s ----------------------------------------\n" "===================="
echo "===================="

