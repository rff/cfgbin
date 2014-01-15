#!/bin/bash

# From bash manual:
# Print a trace of simple commands, for commands, case commands,
# select commands, and arithmetic for commands and their arguments
# or associated word lists after they are expanded and before they
# are executed. The value of the PS4 variable is expanded and the
# resultant value is printed before the command and its expanded
# arguments.
set -x

find "$@" \( -name '.?*' -a -prune \) -o \( -name '*.c' -o -name '*.h' -o -name '*.cc' -o -name '*.cpp' -o -name '*.hh' -o -name '*.hpp' \) -a -print | sort > cscope.files

cscope -b -q  # -i'cscope.files' change the default file list cscope.files
ctags -L 'cscope.files'

