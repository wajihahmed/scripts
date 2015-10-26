#!/bin/sh

VMID=`/home/fr/java/bin/jps | grep jboss | cut -d ' ' -f 1`
/home/fr/java/bin/jstat -gc $VMID 1000 > /home/fr/jstat/jstat.m1:$1 &
