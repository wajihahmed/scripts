#!/bin/sh


URL="http://mbp.wfoo.net:8081/openam"
AUTHN="${URL}/identity/authenticate"

TOK=`curl -s -k --request POST --data "username=amadmin&password=Admin123" $AUTHN | cut -f2 -d=`

echo "=> OpenAM Token: ${TOK}" ; echo ""

#Get Resource Type
curl "${URL}/json/resourcetypes" \
--cookie "iPlanetDirectoryPro=${TOK}"
