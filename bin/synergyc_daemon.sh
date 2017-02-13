#!/bin/bash

trap 'log "Trap EXIT"' EXIT

SERVER="arrr"
DEBUG_LVL="DEBUG"
LOG_FILE="/tmp/synergyc_daemon.log"

function log() {
	echo "[$(date)] $*" &>>${LOG_FILE}
}

# TODO: rework it so we can find and will other instances of itself (of this on
# script).
function killprog() {
    $PROGNAME="$1"

    if ! pgrep -u ${USER} ${PROGNAME} &>/dev/null ; then
        log "Instance of ${PROGNAME} found. Killing It"
        pkill -u ${USER} ${PROGNAME}
        pkill -u ${USER} -9 ${PROGNAME}
    fi
}


log "Starting daemon"

killprog "synergyc"

while true ; do
    log "Starting synergyc"
    synergyc -f -d ${DEBUG_LVL} ${SERVER}  &>>${LOG_FILE}
    EXIT_STATUS=$?
    log "synergyc exited with code ${EXIT_STATUS}"
done

log "Exting daemon"
