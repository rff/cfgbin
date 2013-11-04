#!/bin/bash

# ┌───┐ ┏━━━┓
# │ 0 │ ┃ 0 ┃
# └───┘ ┗━━━┛

CHARS='  '

echo '┌──────────────────┐'
#echo '┏━━━━━━━━━━━━━━━━━━┓'
for f in 40 100 ; do
    echo -n '│ '
#    echo -n '┃ '
    for i in {0..7} ; do
        (( c = i + f ))
        echo -en "\e[${c}m${CHARS}\e[0m";
    done
    echo ' │'
#    echo ' ┃'
done
echo '└──────────────────┘'
#echo '┗━━━━━━━━━━━━━━━━━━┛'
