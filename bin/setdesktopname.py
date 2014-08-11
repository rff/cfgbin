#!/usr/bin/python2
#
# from: http://superuser.com/questions/508128/is-it-possible-to-set-the-name-of-the-current-virtual-desktop-via-commandline
# answer: http://superuser.com/a/734211

"Helper for setting current desktop's name"

import sys

from xpybutil import conn, root

import xpybutil.ewmh as ewmh

if len(sys.argv) == 2 and sys.argv[1] == '--help':
    print "Usage: "
    print "   set_desktop_name NAME_OF_NEW_DESKTOP  - sets current desktop name"
    print "   set_desktop_name NR NAME_OF_NEW_DESKTOP - sets name of NRth desktop"

if len(sys.argv) > 2:
    desktop_offset = int(sys.argv[1])
    new_name = sys.argv[2]

else:
    desktop_offset = ewmh.get_current_desktop().reply()
    new_name = sys.argv[1]

current_names = ewmh.get_desktop_names().reply()

current_names[desktop_offset] = new_name

# Not sure why I have to do it twice - somehow
# doesn't work if I only call it once
c = ewmh.set_desktop_names(current_names)
c = ewmh.set_desktop_names(current_names)


