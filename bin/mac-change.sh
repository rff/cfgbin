#!/bin/bash
#
# virtual box mac slice:
#	08:00:27:::

ERRCODE=0


MACdefault="08:00:28:00:00:01"
MACprefix="08:00:28:00:00:"
MAC=$MACdefault

if [ $# -ne 1 ] ; then
	echo "Argument error!"
	exit 1
fi

if [ ${#1} -eq 2 ]; then
	MAC="${MACprefix}$1"
elif [ ${#1} -eq 17 ]; then
	MAC="$1"
else
	echo "Argument format error!"
	exit 1
fi

echo "[info] Bring eth0 down and wait 2s."
ip link set eth0 down          || exit $?
sleep 2

echo "[info] Change eth0 mac to $MAC."
ip link set eth0 address $MAC  || ERRCODE=$?

echo "[info] Wait 10s and bring eth0 up."
sleep 10
ip link set eth0 up            || exit $?

exit $ERRCODE
