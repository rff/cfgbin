#!/bin/bash
CHANNELS_ON="$(amixer get Master | grep -c '\[on\]')"

[ "${CHANNELS_ON}" != "0" ] && amixer set Master mute   >/dev/null

xset dpms force off
slock

[ "${CHANNELS_ON}" != "0" ] && amixer set Master unmute >/dev/null
