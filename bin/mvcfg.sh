#!/bin/bash
#
# This script helps to put some order in the programs that do not received the
# memo that all config files and folders should now be inside ~/.config.  It is
# a simple helper that moves all config folders in "~/" to "~/.config" and
# create a symlink in its original places.  For not it only works in folders,
# because files are a little more on a case by case bases.
#
# usage: mvcfg.sh <dotfolder> .. <dotfolder>

set -e
set -u
#set -x

exiterror() {
	echo 'ERROR:' "$@" 1>&2
	exit 1
}

warnmsg() {
	echo 'WARNING:' "$@" 1>&2
}

debugmsg() {
	echo 'DEBUG:' "$@" 1>&2
}


[ "${HOME}" == "${PWD}" ] || exiterror "You need to run from home."
[ -e ".config" ] || exiterror "No .config found in home."


for dotcfg in "$@" ; do
	cfg=$(basename "${dotcfg}")
	cfg="${cfg#.}"
	#debugmsg "dotcfg: \"${dotcfg}\""
	#debugmsg "cfg: \"${cfg}\""

	if [ ".${cfg}" != "${dotcfg}" ] ; then
		warnmsg "${dotcfg} is not on the $HOME. Ignoring."
		continue
	fi
	if ! [ -d ."${cfg}" ] ; then
		warnmsg "${dotcfg} is not a folder. Ignoring."
		continue
	fi
	if [ -L ."${cfg}" ] ; then 
		warnmsg "${dotcfg} is a symlink. It may not work if it is not relative. Ignoring."
		continue
	fi

	mv "${dotcfg}" "${HOME}/.config/${cfg}"
	ln -s  "${HOME}/.config/${cfg}" "${dotcfg}"
done
