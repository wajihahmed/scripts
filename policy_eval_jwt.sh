#!/bin/sh

URL="http://mbp.wfoo.net:8081/openam"
AUTHN="${URL}/identity/authenticate"

TOK=`curl -s -k --request POST --data "username=amadmin&password=Admin123" $AUTHN | cut -f2 -d=`

echo "=> OpenAM Token: ${TOK}" ; echo ""

curl ${URL}/json/policies?_action=evaluate \
--request POST \
--cookie "iPlanetDirectoryPro=${TOK}" \
--header "Content-Type: application/json" \
--data '{
    "subject": {
        "jwt": "eyJhbGciOiJub25lIiwidHlwIjoiSldUIn0.eyJpc3MiOiJtYnAud2Zvby5uZXQiLCJzdWIiOiJ0cmFkZXIgam9lIiwibmJmIjoxNDI3OTIzMDE4LCJleHAiOjE0Mjc5MjY2MTgsImlhdCI6MTQyNzkyMzAxOCwianRpIjoiaWQxMjM0NTYiLCJ0eXAiOiJodHRwczovL2V4YW1wbGUuY29tL3JlZ2lzdGVyIn0."
    },
    "resources": [
        "book/screen",
        "book/reports"
    ],
    "application": "Quick Trade"
}'
