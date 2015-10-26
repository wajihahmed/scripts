#!/bin/sh

while true; do
D=`date '+%m-%d %H:%M:%S'`
R=`/home/fr/opendj/bin/dsreplication status --hostname m1.fr.int --port 4444 --adminUID admin --adminPassword Admin123 --trustAll --no-prompt --script-friendly`
echo -n $D 
echo -n " "
echo -n $R
echo ""
sleep 5s
done
