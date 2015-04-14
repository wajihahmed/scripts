#!/bin/bash

# Author: wajih.ahmed@forgerock.com

FILES=/Users/wahmed/sandbox/openam/openam/debug/*


for f in $FILES
do
	cp /dev/null $f
done
