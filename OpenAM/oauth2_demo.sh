#!/bin/sh

# Author: wajih.ahmed@forgerock.com

URL="http://mbp.wfoo.net:8080/openam"

AUTHN="${URL}/identity/authenticate"
O2="${URL}/oauth2"
URI="http://mbp.wfoo.net:8080/oauth2/oauth2.htm"
CI="mobile2"
CS="password"

TOK=`curl -s -k --request POST --data "username=demo&password=changeit" $AUTHN | cut -f2 -d=`

echo "=> OpenAM Token: ${TOK}" ; echo ""


# Emulate an interactive session (note the save_consent and decision variables)
CODE=`curl -s -D - -k --request POST --cookie "iPlanetDirectoryPro=${TOK}" --header "Content-Type: application/x-www-form-urlencoded" --data "response_type=code&save_consent=1&decision=allow&client_id=${CI}&redirect_uri=${URI}&scope=mail%20cn%20guid" ${O2}/authorize | grep Location | cut -f3 -d=`

echo "=> OAuth2 Authorization Code: $CODE" ; echo ""

# Request Access Token will all scopes
JSON=`curl -s -k --request POST --data "grant_type=authorization_code&code=${CODE}&redirect_uri=${URI}&client_id=${CI}&client_secret=${CS}" ${O2}/access_token`

#JSON=`curl -s --user "mobile2:password" --data "grant_type=password&username=demo&password=changeit&scope=mail%20cn%20guid"  ${O2}/access_token`

echo "=> JSON Payload"
echo "$JSON" ; echo ""


RT=`echo $JSON | cut -f4 -d, | cut -f2 -d: | sed -e 's/\"//g'`
AT=`echo $JSON | cut -f5 -d, | cut -f2 -d: |  sed -e 's/[{}|\"]//g'`

echo "=> OAuth2 Refresh Token: $RT" ; echo ""
echo "=> OAuth2 Access Token: $AT" ; echo ""

echo "=> Token Info"
curl ${O2}/tokeninfo?access_token=$AT
echo "" ; echo ""

# Narrower scope
JSON=`curl -s -k --request POST --data "grant_type=refresh_token&redirect_uri=${URI}&refresh_token=${RT}&client_id=${CI}&client_secret=${CS}&scope=guid" ${O2}/access_token`

echo "=> Narrower Scope"
echo "$JSON" ; echo ""

RT=`echo $JSON | cut -f4 -d, | cut -f2 -d: | sed -e 's/\"//g'`

echo "=> Another Narrower scope"
curl -s -k --request POST --data "grant_type=refresh_token&redirect_uri=${URI}&refresh_token=${RT}&client_id=${CI}&client_secret=${CS}&scope=mail" ${O2}/access_token
echo ""




# JSON parsing
# sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}'
