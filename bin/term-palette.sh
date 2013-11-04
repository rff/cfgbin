#!/bin/bash

# ┌───┐ ┏━━━┓
# │ 0 │ ┃ 0 ┃
# └───┘ ┗━━━┛

CHARS='  '
TYPE='none'
OPT=${1:-'-u'}

[ ${OPT} == '-u' ] && TYPE='utf8'
[ ${OPT} == '-U' ] && TYPE='utf8-thick'
[ ${OPT} == '-a' ] && TYPE='ascii'
[ ${OPT} == '-A' ] && TYPE='ascii-thick'
[ ${OPT} == '-s' ] && TYPE='simple'
[ ${OPT} == '-n' ] && TYPE='none'

case $TYPE in
    utf8 )
           LINE_TOP='┌──────────────────┐\n'
        LINE_VBEGIN='│ '
                            LINE_VEND=' │\n'
        LINE_BOTTON='└──────────────────┘\n'
    ;;
    utf8-thick )
           LINE_TOP='┏━━━━━━━━━━━━━━━━━━┓\n'
        LINE_VBEGIN='┃ '
                            LINE_VEND=' ┃\n'
        LINE_BOTTON='┗━━━━━━━━━━━━━━━━━━┛\n'
    ;;
    ascii )
           LINE_TOP='+------------------+\n'
        LINE_VBEGIN='| '
                            LINE_VEND=' |\n'
        LINE_BOTTON='+------------------+\n'
    ;;
    ascii-thick )
           LINE_TOP='+==================+\n'
        LINE_VBEGIN='| '
                            LINE_VEND=' |\n'
        LINE_BOTTON='+==================+\n'
    ;;
    simple )
        LINE_TOP='\n'
        LINE_VBEGIN=' '
        LINE_VEND=' \n'
        LINE_BOTTON='\n'
    ;;
    none ) ;&
    * )
        LINE_TOP=''
        LINE_VBEGIN=''
        LINE_VEND='\n'
        LINE_BOTTON=''
    ;;
esac

echo -en "$LINE_TOP"
for f in 40 100 ; do
    echo -en "$LINE_VBEGIN"
    for i in {0..7} ; do
        (( c = i + f ))
        echo -en "\e[${c}m${CHARS}\e[0m";
    done
    echo -en "$LINE_VEND" 
done
echo -en "$LINE_BOTTON"

