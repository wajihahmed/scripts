#!/bin/sh

URL="http://mbp.wfoo.net:8080"

AM="${URL}/openam"

AUTHN="${AM}/identity/authenticate"

TOK=`curl -s -k --request POST --data "username=amadmin&password=Admin123" $AUTHN | cut -f2 -d=`

echo "=> OpenAM Token: ${TOK}" ; echo ""

# --data @body.json

curl \
 --request POST \
 --header "iplanetDirectoryPro: ${TOK}" \
 --header "Content-Type: application/json" \
 --data \
 '{"client_id":["mobileADD"],
   "realm":["/ADD"],
   "userpassword":["password"],
   "com.forgerock.openam.oauth2provider.clientType":["Confidential"],
   "com.forgerock.openam.oauth2provider.redirectionURIs":
     ["'"${URL}/oauth2/oauth2.htm"'","'"${URL}/oIDc/openidc.htm"'"],
   "com.forgerock.openam.oauth2provider.scopes":["cn|Name","mail|Email","openid","profile"],
   "com.forgerock.openam.oauth2provider.defaultScopes":["cn"],
   "com.forgerock.openam.oauth2provider.responseTypes":["code","token","id_token","code token","token id_token","code id_token","code token id_token"],
   "com.forgerock.openam.oauth2provider.idTokenSignedResponseAlg":["HS256"],
   "com.forgerock.openam.oauth2provider.name":["Test Client"],
   "com.forgerock.openam.oauth2provider.description":["OIDC 1.0 Client"]
  }' \
  ${AM}/frrest/oauth2/client/?_action=create
