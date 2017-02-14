#!/bin/bash

#printf '\33]50;%s%d\007' "xft:$1:pixelsize=" $2
printf '\33]50;%s%d\007' "xft:$1:autohint=true:antialias=true:hintstyle:hintfull:size=" $2
