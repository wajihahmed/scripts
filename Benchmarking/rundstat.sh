#!/bin/sh

dstat -tcmndr --integer --output /home/fr/mon/dstat.m1-$1 5
