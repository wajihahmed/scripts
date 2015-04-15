#!/bin/bash

FILES=*

P=`pwd`
B=`basename $P`

if [ "$B" = "debug" ]; then
 for f in $FILES
 do
	cp /dev/null $f
 done
fi
