#!/bin/bash

if test "$#" -lt 1; then
    echo "Usage: $0 <jobid>"
    exit 1
fi

ID=$1

cd results

# client
scp -i ~/.ssh/mykey.pem -C  vagrant@192.168.100.20:mon/*$ID* .
 
# server
scp -i ~/.ssh/mykey.pem -C -r vagrant@192.168.100.21:mon/*$ID* .
scp -i ~/.ssh/mykey.pem -C -r vagrant@192.168.100.21:/tmp/dj_gc.log .

exit 0
