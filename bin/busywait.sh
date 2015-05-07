#!/bin/bash

COLOR='\e[0;33m'
RESET='\e[0m'
bs='\b'
for (( _i=0, i=1 ; ; _i++, i++ )) ; do
	let 'c = i % 8'
	color="\e[0;3${c}m"
	printf "${bs}${color}.${RESET}%d" $i
	test ${#i} -gt ${#_i} && bs+='\b'
	sleep 10
done
