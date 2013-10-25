#!/bin/sh

if test -x /usr/lib/openbox/gnome-settings-daemon >/dev/null; then
  /usr/lib/openbox/gnome-settings-daemon &
elif which gnome-settings-daemon >/dev/null; then
  gnome-settings-daemon &
fi

# Programs to launch at startup
#hsetroot ~/wallpaper.png &
#xcompmgr -c -t-5 -l-5 -r4.2 -o.55 &

# SCIM support (for typing non-english characters)
#export LC_CTYPE=ja_JP.utf8
#export XMODIFIERS=@im=SCIM
#export GTK_IM_MODULE=scim
#export QT_IM_MODULE=scim
#scim -d &

#xrandr &> ~/saida.xrandr

# Programs that will run after Openbox has started
#(sleep 2 && tint2) &
#(sleep 2 && gnome-volume-control-applet) &
#(sleep 2 && gnome-power-manager) &
#(sleep 2 && nm-applet) &

(sleep 1 ; xcompmgr -c -t-5 -l-5 -r4.2 -o.55) &
(sleep 3 ; urxvtd -q -f -o) &
(sleep 4 ; nitrogen --restore) &
(sleep 5 ; conky) &
(sleep 5 ; nautilus --browser --no-desktop) &

#if ! dropbox running ; then
#	dropbox stop
#fi
#dropbox start

