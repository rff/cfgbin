#!/bin/bash
# Para ser compativel com /bin/sh substituir "[[" e "]]" por "[" e "]" e
# "&&" no penultimo if, na linha 27 por "-a"

DIRNAME="."
TAR_FLAGS="--bzip2 --same-permissions --same-owner --atime-preserve=replace --verbose --verbose"
DATE="`date +%Y.%m.%d-%H.%M.%S.%N-GMT%z`"
RELEASE_AND_VERSION="$1-$DATE" ;
VERSION="version"

if [[ $# -lt 1 ]]; then
	echo "	ERROR: no archive to backup" ;
	echo "	usage: `basename "$0"` <source> [<targetdir>]" ;
	exit 1 ;
fi
if [[ $# -gt 2 ]]; then
	echo "	ERROR: too many parameters" ;
	echo "	usage: `basename "$0"` <source> [<targetdir>]" ;
	exit 1 ;
fi

if ! [[ -r $1 ]]; then
	echo "	ERROR: invalid archive or not permited to read" ;
	echo "	usage: `basename "$0"` <source> [<targetdir>]" ;
	exit 1 ;
fi

if [[ $# -ge 2 ]]; then
	if ! [[ -d $2 && -w $2 ]]; then
		echo "	ERROR: invalid directory or not permited to write" ;
		echo "	usage: `basename "$0"` <source> [<targetdir>]" ;
		exit 1 ;
	fi
	DIRNAME=$2 ;
fi

FILENAME="$DIRNAME/$RELEASE_AND_VERSION.tar.bz2" ;

if [[ -e $VERSION ]]; then
	if ! [[ -w $VERSION ]]; then
		echo "	ERROR: not permited to write on file \"$VERSION\"" ;
		echo "	backup need that filename to generate version file." ;
		echo "	* You can move original \"$VERSION\" file to other place ou change his name" ;
		echo "	  and after the execution of backup you can restore they original state;" ;
		echo "	* Or you can execute backup with enough privilege to write on \"$VERSION\"" ;
		echo "	  and let backup do all the work for you." ;

		exit 1 ;
	fi

	mv "$VERSION" "$VERSION.backupsh.bak"
fi

echo "$RELEASE_AND_VERSION" >> "$VERSION" ;

tar --create $TAR_FLAGS --file="$FILENAME" --exclude="$FILENAME" "$1" "$VERSION";

if [[ $? -ne 0 ]]; then
	if [[ -e "$VERSION.backupsh.bak" ]]; then
		mv "$VERSION.backupsh.bak" "$VERSION" ;
	else
		rm "$VERSION" ;
	fi

	echo "	ERROR: tar fail" ;
	exit 1 ;
fi

if [[ -e "$VERSION.backupsh.bak" ]]; then
	mv "$VERSION.backupsh.bak" "$VERSION" ;
else
	rm "$VERSION" ;
fi


echo "	BACKUP CREATED: \"$FILENAME\"" ;

exit 0;
