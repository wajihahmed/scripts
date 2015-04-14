#!/bin/bash

H1=`uname -n`
H2=$H1
P1=1389
P2=2389
SP1=1636
SP2=2636
AC1=4444
AC2=5444
PW="secret12"
ADM="cn=Directory Manager"
SFX="dc=example,dc=com"

cp -r opendj opendj1
cd opendj1

./setup -i -n -b $SFX -a -h $H1 -p $P1 --adminConnectorPort $AC1 -D "$ADM" -w $PW -q -Z $SP1 --generateSelfSignedCertificate

bin/dsconfig delete-backend -h $H1 -D "$ADM" -w $PW -p $AC1 -X -n \
          --backend-name userRoot
bin/dsconfig create-backend -h $H1 -D "$ADM" -w $PW -p $AC1 -X -n \
  --set base-dn:dc=example,dc=com --set enabled:true --type persistit --backend-name users
# Create indexes...
dsconfig create-backend-index -h $H1 -D "$ADM" -w $PW -p $AC1 -X -n \
--backend-name users --set index-type:equality --set index-type:substring --type generic --index-name cn
dsconfig create-backend-index -h $H1 -D "$ADM" -w $PW -p $AC1 -X -n \
--backend-name users --set index-type:equality --set index-type:substring --type generic --index-name sn
dsconfig create-backend-index -h $H1 -D "$ADM" -w $PW -p $AC1 -X -n \
--backend-name users --set index-type:equality --type generic --index-name uid
dsconfig create-backend-index -h $H1 -D "$ADM" -w $PW -p $AC1 -X -n \
--backend-name users --set index-type:equality --set index-type:substring --type generic --index-name mail

# bin/stop-ds
bin/make-ldif -t config/MakeLDIF/example.template -o /tmp/example$$.ldif
bin/import-ldif -h $H1 -D "$ADM" -w $PW -p $AC1 -X -n users -l /tmp/example$$.ldif
# bin/start-ds

cd ../
cp -r opendj opendj2
cd opendj2

./setup -i -n -b $SFX -a -h $H2 -p $P2 --adminConnectorPort $AC2 -D "$ADM" -w $PW -q -Z $SP2 --generateSelfSignedCertificate

bin/dsconfig delete-backend -h $H2 -D "$ADM" -w $PW -p $AC2 -X -n \
          --backend-name userRoot
bin/dsconfig create-backend -h $H2 -D "$ADM" -w $PW -p $AC2 -X -n \
  --set base-dn:dc=example,dc=com --set enabled:true --type persistit --backend-name users
# Create indexes...
dsconfig create-backend-index -h $H2 -D "$ADM" -w $PW -p $AC2 -X -n \
--backend-name users --set index-type:equality --set index-type:substring --type generic --index-name cn
dsconfig create-backend-index -h $H2 -D "$ADM" -w $PW -p $AC2 -X -n \
--backend-name users --set index-type:equality --set index-type:substring --type generic --index-name sn
dsconfig create-backend-index -h $H2 -D "$ADM" -w $PW -p $AC2 -X -n \
--backend-name users --set index-type:equality --type generic --index-name uid
dsconfig create-backend-index -h $H2 -D "$ADM" -w $PW -p $AC2 -X -n \
--backend-name users --set index-type:equality --set index-type:substring --type generic --index-name mail

bin/dsreplication enable --host1 $H1 --port1 $AC1 --bindDN1 "$ADM" --bindPassword1 $PW --replicationPort1 8989 --host2 $H2 --port2 $AC2 --bindDN2 "$ADM" --bindPassword2 $PW --replicationPort2 9989 --adminUID admin --adminPassword password --baseDN $SFX -X -n

bin/dsreplication initialize --baseDN $SFX --adminUID admin --adminPassword password --hostSource $H1 --portSource $AC1 --hostDestination $H2 --portDestination $AC2 -X -n


