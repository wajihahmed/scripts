#!/bin/sh

URL="http://mbp.wfoo.net:8080/openam"

REG="${URL}/oauth2/connect/register"
O2="${URL}/oauth2"
URI="http://myapp.example.com"
CI="masterClient"
CS="Admin123"


#JSON=`curl --request POST --user "${CI}:${CS}" --data "grant_type=password&username=amadmin&password=Admin123" ${O2}/access_token`

JSON=`curl -s --user "mobile:Admin123" --data "grant_type=password&username=demo&password=changeit&response_type=id_token%20token&scope=mail%20openid"  ${O2}/authorize`

echo "=> JSON Payload"
echo "$JSON" ; echo ""


RT=`echo $JSON | cut -f3 -d, | cut -f2 -d: | sed -e 's/\"//g'`
AT=`echo $JSON | cut -f4 -d, | cut -f2 -d: |  sed -e 's/[{}|\"]//g'`

echo "=> OAuth2 Refresh Token: $RT" ; echo ""
echo "=> OAuth2 Access Token: $AT" ; echo ""


#curl -k "${O2}/authorize?response_type=id_token token&scope=openid profile&client_id=mobil&state=af0ifjsldkj 		&redirect_uri=http://myapp.example.com &nonce=n-0S6_WzA2Mj" 

#GET /authorize?
#     response_type=code
#     &scope=openid profile email 		
##     &client_id=client01 		
#     &state=af0ifjsldkj 		
##     &redirect_uri=https://localhost:8020/oidcclient/redirect/client01
