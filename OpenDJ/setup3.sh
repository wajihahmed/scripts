#!/bin/bash

# This script creates a backend on OpenDJ

./setup -i -n -b "dc=example,dc=com" -a -h `uname -n` -p 1389 --adminConnectorPort 4444 -D "cn=Directory Manager" -w "secret12" -q -Z 1636 --generateSelfSignedCertificate

bin/dsconfig delete-backend -h `uname -n` -D "cn=Directory Manager" -w "secret12" -p 4444 -X -n \
          --backend-name userRoot
bin/dsconfig create-backend -h `uname -n` -D "cn=Directory Manager" -w "secret12" -p 4444 -X -n \
  --set base-dn:dc=example,dc=com --set enabled:true --type persistit --backend-name users
# Create indexes...
dsconfig create-backend-index -h `uname -n` -D "cn=Directory Manager" -w "secret12" -p 4444 -X -n \
--backend-name users --set index-type:equality --set index-type:substring --type generic --index-name cn
dsconfig create-backend-index -h `uname -n` -D "cn=Directory Manager" -w "secret12" -p 4444 -X -n \
--backend-name users --set index-type:equality --set index-type:substring --type generic --index-name sn
dsconfig create-backend-index -h `uname -n` -D "cn=Directory Manager" -w "secret12" -p 4444 -X -n \
--backend-name users --set index-type:equality --type generic --index-name uid
dsconfig create-backend-index -h `uname -n` -D "cn=Directory Manager" -w "secret12" -p 4444 -X -n \
--backend-name users --set index-type:equality --set index-type:substring --type generic --index-name mail

bin/stop-ds
bin/make-ldif -t config/MakeLDIF/example.template -o /tmp/example$$.ldif
bin/import-ldif -n users -l /tmp/example$$.ldif
bin/start-ds
