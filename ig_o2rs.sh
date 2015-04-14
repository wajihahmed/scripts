#!/bin/sh

# Author: wajih.ahmed@forgerock.com

JSON=`curl -s --user "mobile2:password" --data "grant_type=password&username=demo&password=changeit&scope=mail%20cn" http://mbp.wfoo.net:8080/openam/oauth2/access_token`

AT=`echo $JSON | cut -f5 -d, | cut -f2 -d: |  sed -e 's/[{}|\"]//g'`


echo "Authorization Bearer Token: ${AT}"
echo ""

curl -S --header "Authorization: Bearer ${AT}" http://127.0.0.1:4080/rs
