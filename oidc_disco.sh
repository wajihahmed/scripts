#!/bin/sh

echo ""
curl http://mbp.wfoo.net:8080/openam/.well-known/openid-configuration?realm=/

echo ""
echo ""
echo ""

curl "http://mbp.wfoo.net:8080/openam/.well-known/webfinger?resource=acct:demo@example.com&rel=http://openid.net/specs/connect/1.0/issuer"


