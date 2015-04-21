#!/bin/bash

set -x
set -u
set -e

which X &> /dev/null || exit 1

export DISPLAY=${1:-":0"}

#VT=$(tty)
#VT=vt${VT#/dev/tty}
VT=vt${XDG_VTNR}

X ${DISPLAY} ${VT}                                           \
  -novtswitch -terminate -nolisten tcp -retro                      \
  -fn -misc-ubuntu-medium-r-normal--0-0-0-0-p-0-iso8859-1 &
XPID=$!
sleep 2

if test -e ~/.xinitrc ; then
    set -x
    set +u
    set +e
    source ~/.xinitrc
    set -x
    set -u
    set -e
fi

if which dropbox &>/dev/null ; then
    if ! dropbox running ; then
        dropbox stop
    fi
    dropbox start
fi

wait ${XPID}
