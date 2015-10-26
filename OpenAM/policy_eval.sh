#!/bin/sh

# Author: wajih.ahmed@forgerock.com

URL="http://mbp.wfoo.net:8081/openam"
AUTHN="${URL}/identity/authenticate"

TOK=`curl -s -k --request POST --data "username=amadmin&password=Admin123" $AUTHN | cut -f2 -d=`
SUBTOK=`curl -s -k --request POST --data "username=demo&password=changeit" $AUTHN | cut -f2 -d=`

echo "=> OpenAM Token: ${TOK}" ; echo ""
echo "=> Subject Token: ${SUBTOK}" ; echo ""

curl ${URL}/json/policies?_action=evaluate \
--request POST \
--cookie "iPlanetDirectoryPro=${TOK}" \
--header "Content-Type: application/json" \
--data '{
    "subject": {
        "ssoToken": "'"${SUBTOK}"'"
    },
    "resources": [
        "book/screen",
        "book/reports"
    ],
    "application": "Quick Trade"
}'
