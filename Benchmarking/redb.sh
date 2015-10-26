#!/bin/bash

read -p "Are you sure you want to wipe out opendj/db directory? " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
	/home/fr/opendj/bin/stop-ds
	date 
    	rm -rf /home/fr/opendj/changelogDb
    	time rm -rf /home/fr/opendj/db
	#time cp -r /home/fr/opendj/db-500M-fresh /home/fr/opendj/db
	time cp -r /home/fr/opendj/db-200M-fresh /home/fr/opendj/db
	cd /home/fr/opendj/db/userRoot
	time ls *.gz | parallel -j 16 pigz -d
   	date
fi

