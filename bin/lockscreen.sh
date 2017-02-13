#!/bin/bash
CHANNELS_ON="$(amixer get Master | grep -c '\[on\]')"

[ "${CHANNELS_ON}" != "0" ] && amixer set Master mute   >/dev/null

sleep 1s
xset dpms force off
slock
xset +dpms

[ "${CHANNELS_ON}" != "0" ] && amixer set Master unmute >/dev/null
