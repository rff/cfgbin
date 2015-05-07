#!/bin/bash

START=${1:-1}
END=${2:-+10}
[[ "$END" == +* ]] && END=$(( START + END ))
DELTA=$(( END - START + 1 ))

head -n $END | tail -n $DELTA
