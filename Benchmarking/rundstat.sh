#!/bin/sh

# need to run as sudo because of bug in netstat

sudo dstat -tcmndr --integer --output /home/fr/mon/dstat.m1-$1 5
