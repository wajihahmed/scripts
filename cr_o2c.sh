#!/bin/sh


URL="http://mbp.wfoo.net:8080/openam"

AUTHN="${URL}/identity/authenticate"

TOK=`curl -s -k --request POST --data "username=amadmin&password=Admin123" $AUTHN | cut -f2 -d=`

echo "=> OpenAM Token: ${TOK}" ; echo ""


curl \
 --request POST \
 --header "iplanetDirectoryPro: ${TOK}" \
 --header "Content-Type: application/json" \
 --data \
 '{"client_id":["mobile"],
   "realm":["/AD"],
   "userpassword":["password"],
   "com.forgerock.openam.oauth2provider.clientType":["Confidential"],
   "com.forgerock.openam.oauth2provider.redirectionURIs": ["http://mbp.wfoo.net:8080/oauth2/oauth2.htm"],
   "com.forgerock.openam.oauth2provider.scopes":["cn|Name","mail|Email","guid"],
   "com.forgerock.openam.oauth2provider.defaultScopes":["cn"],
   "com.forgerock.openam.oauth2provider.responseTypes":["code","token"],
   "com.forgerock.openam.oauth2provider.name":["Test Client"],
   "com.forgerock.openam.oauth2provider.description":["OAuth 2.0 Client"]
  }' \
  ${URL}/frrest/oauth2/client/?_action=create
