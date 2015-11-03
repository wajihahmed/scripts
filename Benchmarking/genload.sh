#!/bin/sh

if test "$#" -lt 2; then
    echo "Usage: $0 <hostname> <type> where type is srch auth mod add mixed"
    exit 1
fi

H=$1
TYPE=$2
ID=`date +%y%m%d%H%M%S`
SI="/home/fr/mon/sysinfo.$H.$ID"
export OPENDJ_JAVA_ARGS="-Xmx2g -Xms2g"


if [ $H = "m1" ]
then
 IP=192.168.100.21
elif [ $H = "s2" ]
then
 IP=192.168.100.22
elif [ $H = "m2" ]
then
 IP=192.168.100.23
else
 IP=localhost
fi


getmon() {
echo "=============================" >> $SI
#/home/fr/opendj/bin/ldapsearch -h $IP -p 1389 -b "cn=monitor" \
#    -D "cn=directory manager" -w Admin123 \
#    objectclass=* | grep -E "ds-backend-entry-count|Backlog|requests|EnvironmentNBINs|EnvironmentCacheDataBytes|Fetch|Miss" >> $SI
/home/fr/opendj/bin/ldapsearch -h $IP -p 1389 -b "cn=monitor" \
    -D "cn=directory manager" -w Admin123 \
    objectclass=*  >> $SI
}

killpid() {
ssh -i ~/$H.pem fr@$IP 'bash -s' <<EOF
sudo pkill dstat
sudo pkill monrepl.sh
EOF
getmon
}

trap killpid SIGINT SIGHUP SIGTERM


ssh -i ~/$H.pem fr@$IP 'bash -s' <<EOF
sudo dstat -tcmndr --integer --output /home/fr/mon/dstat.${H}.${ID} 5 > /dev/null &
/home/fr/mon/monrepl.sh > /home/fr/mon/replstat.${H}.${ID}  &
# dstat -tal --tcp --integer --mem -N lo,total --freespace
EOF


cd /home/fr/tk/bin
./ldapsearch -h $IP -p 1389 -b "cn=System Information,cn=monitor" \
    -D "cn=directory manager" -w Admin123 \
    objectclass=* | grep -Ev "TLS" > $SI


SR="/home/fr/mon/srchrate.$H.$ID"
MR="/home/fr/mon/modrate.$H.$ID"
AR="/home/fr/mon/authrate.$H.$ID"
ADR="/home/fr/mon/addrate.$H.$ID"

if [ $TYPE = "srch" ] 
then
CON=20
THRD=10
FILT="(uid=user%d)"
echo "Starting searchrate Job with $ID using $CON clients with $THRD threads each with search filter $FILT" | tee -a $SI
getmon
./searchrate \
    -h $IP -p 1389 -b "dc=cts,dc=example,dc=com" \
    -D "cn=directory manager" -w Admin123 \
    -F -c $CON -t $THRD -g "rand(0,500000000)" \
    "$FILT" | tee -a $SR
fi


if [ $TYPE = "mod" ]
then
echo "Starting modrate Job with $ID using 4 clients with 4 threads each on givenName" | tee -a $SI
getmon
./modrate -h $IP -p 1389 -D "cn=directory manager" -w Admin123 \
   -F -c 4 -t 4 -b "uid=user%d,ou=people,dc=cts,dc=example,dc=com" \
   -g "rand(0,500000000)" -g "randstr(20)" 'givenName:%2$s' | tee -a $MR
fi

if [ $TYPE = "add" ]
then
echo "Starting addrate Job with $ID using 4 clients with 4 threads each" | tee -a $SI
getmon
./addrate -h $IP -p 1389 -D "cn=directory manager" -w Admin123 --noRebind \
   --resourcePath /home/fr/MakeLDIF --noPurge --deleteMode off \
   -c 4 -t 4 /home/fr/MakeLDIF/addrate.template | tee -a $ADR
fi


if [ $TYPE = "auth" ]
then
echo "Starting authrate Job with $ID using 50 clients" | tee -a $SI
getmon
./authrate -h $IP -p 1389 -D "uid=user%d,ou=people,dc=cts,dc=example,dc=com" -w password \
   -f -c 50 -g "rand(0,500000000)" | tee -a $AR
fi

if [ $TYPE = "mixed" ]
then
echo "Starting Mixed Job with $ID" | tee -a $SI
getmon
./searchrate \
    -h $IP -p 1389 -b "dc=cts,dc=example,dc=com" \
    -D "cn=directory manager" -w Admin123 \
    -F -c 20 -t 10 -M 30000 -g "rand(0,500000000)" \
    "(uid=user%d)" | tee -a $SR &
./authrate -h $IP -p 1389 -D "uid=user%d,ou=people,dc=cts,dc=example,dc=com" -w password \
   -f -c 50 -M 10000 -g "rand(0,500000000)" | tee -a $AR &
./modrate -h $IP -p 1389 -D "cn=directory manager" -w Admin123 \
   -F -c 4 -t 4 -M 1000 -b "uid=user%d,ou=people,dc=cts,dc=example,dc=com" \
   -g "rand(0,500000000)" -g "randstr(20)" 'givenName:%2$s' | tee -a $MR
fi


#killpid

exit 0


