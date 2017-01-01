#!/bin/sh
# This is a preprocessor for 'less'.  It is used when this environment
# variable is set:   LESSOPEN="|lesspipe.sh %s"

lesspipe() {
	case "$1" in
		*.tar) tar tf $1 2>/dev/null ;; # View contents of .tar and .tgz files
		*.tgz|*.tar.gz|*.tar.Z|*.tar.z) tar ztf $1 2>/dev/null ;;
		*.Z|*.z|*.gz) gzip -dc $1  2>/dev/null ;; # View compressed files correctly
		*.zip) unzip -l $1 2>/dev/null ;; # View archives
		*.arj) unarj -l $1 2>/dev/null ;;
		*.rpm) rpm -q -p -i -l $1 2>/dev/null ;;
		*.cpio) cpio --list -F $1 2>/dev/null ;;
		*.1|*.2|*.3|*.4|*.5|*.6|*.7|*.8|*.9|*.n|*.man) FILE=`file -L $1`
		FILE=`echo $FILE | cut -d ' ' -f 2`
		if [ "$FILE" = "troff" ]; then
			groff -s -p -t -e -Tascii -mandoc $1
		fi ;;
		*) file $1 | grep text > /dev/null ;
		if [ $? = 1 ] ; then # it's not some kind of text
			strings $1
		fi ;;
	esac
}

lesspipe $1
