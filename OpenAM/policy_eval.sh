#!/bin/sh

URL="http://mbp.wfoo.net:8081/openam"
AUTHN="${URL}/json/authenticate"


TOK=`curl -s -k --request POST --header "X-OpenAM-Username: amadmin" --header "X-OpenAM-Password: Admin123" --header "Content-Type: application/json" --data "{}" $AUTHN | cut -f2 -d: | cut -f1 -d, | sed -e 's/"//g'` 
SUBTOK=`curl -s -k --request POST --header "X-OpenAM-Username: demo" --header "X-OpenAM-Password: changeit" --header "Content-Type: application/json" --data "{}" $AUTHN | cut -f2 -d: | cut -f1 -d, | sed -e 's/"//g'` 

echo "=> OpenAM Token: ${TOK}" ; echo ""
echo "=> Subject Token: ${SUBTOK}" ; echo ""

curl ${URL}/json/policies?_action=evaluate\&_prettyPrint=true \
--request POST \
--cookie "iPlanetDirectoryPro=${TOK}" \
--header "Content-Type: application/json" \
--data '{
    "subject": {
        "ssoToken": "'"${SUBTOK}"'"
    },
    "resources": [
        "amount"
    ],
    "application": "Quick Trade"
}'
