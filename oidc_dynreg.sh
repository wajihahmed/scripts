#!/bin/sh

URL="http://mbp.wfoo.net:8080/openam"

REG="${URL}/oauth2/connect/register"
O2="${URL}/oauth2"
URI="http://myapp.example.com"
CI="masterClient"
CS="Admin123"


JSON=`curl --request POST --user "${CI}:${CS}" --data "grant_type=password&username=amadmin&password=Admin123" ${O2}/access_token`

echo "=> JSON Payload"
echo "$JSON" ; echo ""


RT=`echo $JSON | cut -f3 -d, | cut -f2 -d: | sed -e 's/\"//g'`
AT=`echo $JSON | cut -f4 -d, | cut -f2 -d: |  sed -e 's/[{}|\"]//g'`

echo "=> OAuth2 Refresh Token: $RT" ; echo ""
echo "=> OAuth2 Access Token: $AT" ; echo ""

curl --request POST \
     --header "Content-Type: application/x-www-form-urlencoded" \
     --header "Authorization: Bearer ${AT}" \
     --data "{ \
	"application_type": "web", \
	"redirect_uris": "https://client.example.org/callback", \
	"client_name": "iphone", \
	"logo_uri": "https://client.example.org/logo.png", \
	"subject_type": "pairwise", \
	"sector_identifier_uri": "https://other.example.net/file_of_redirect_uris.json", \
	"token_endpoint_auth_method": "client_secret_basic", \
	"jwks_uri": "https://client.example.org/my_public_keys.jwks", \
	"userinfo_encrypted_response_alg": "RSA1_5", \
	"userinfo_encrypted_response_enc": "A128CBC-HS256", \
	"contacts": ["wajih.ahmed@fr.com"], \
	"request_uris": ["https://client.example.org/rf.txt"] \
    }" ${REG}


# {"application_type":"web","scopes":["openid"],"client_secret":"9c1ca999-32ee-4439-8a13-ccfba721a10d","client_type":"Confidential","registration_access_token":"1a9820e7-2c11-4554-a427-8afd8af307a0","subject_type":"Public","id_token_signed_response_alg":"HS256","client_id_issued_at":1416337264,"client_id":"87ead009-79e5-4f2e-ae8c-9b7b635b7748","client_secret_expires_at":0,"response_types":["code"],"registration_client_uri":"http://mbp.wfoo.net:8080/openam/oauth2/connect/register?client_id=87ead009-79e5-4f2e-ae8c-9b7b635b7748"}
