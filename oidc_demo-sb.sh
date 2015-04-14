#!/bin/sh

# Author: wajih.ahmed@forgerock.com

AMURL="http://mbp.wfoo.net:8080/openam"
REALM="" #For root realm use ""
ANE="${AMURL}/json/authenticate?realm=/${REALM}" # Authentication Endpoint
O2="${AMURL}/oauth2"

O2CI="mobile"
O2CS="password"
REDURI="http://mbp.wfoo.net:8080/oauth2/oauth2.htm" # OAuth 2 Client Redirection URI space delimited
DIS=`curl -s -k ${AMURL}/.well-known/openid-configuration?realm=/${REALM}` # use \$O2 for nightly
USERNAME="demo"
PASSWD="changeit"

# ======================== Do not edit below this line ====================
DISCO=`echo $DIS | sed -e 's/oauth2\/\//oauth2\//g'`
echo $DISCO

j2v () 
{
    # Note how variable is dereferenced aka indirect expansion :-)
    echo ${!1} | sed -e "s/^.*\"$2\"[ ]*:[ ]*\"//" -e 's/".*//'
}

#ATE=`echo $DISCO | sed -e 's/^.*"token_endpoint"[ ]*:[ ]*"//' -e 's/".*//'`
ATE=`j2v DISCO token_endpoint`
UIE=`j2v DISCO userinfo_endpoint`
AZE=`j2v DISCO authorization_endpoint`

# Legacy Endpoint
#TOK=`curl -s -k --request POST --data "username=${USERNAME}&password=${PASSWD}&uri=realm=/{$REALM}" "${AMURL}/identity/authenticate" | cut -f2 -d=`

TOK=`curl -s -k --request POST --header "X-OpenAM-Username: ${USERNAME}" --header "X-OpenAM-Password: ${PASSWD}" --header "Content-Type: application/json" --data "{}" $ANE | cut -f2 -d: | cut -f1 -d, | sed -e 's/"//g'` 

echo ""
echo "=> OpenAM Token: ${TOK}" ; echo ""


# Emulate an interactive session (note the save_consent and decision variables)

CODE=`curl -s -D - -k --request POST --cookie "iPlanetDirectoryPro=${TOK}" --header "Content-Type: application/x-www-form-urlencoded" --data "response_type=code&save_consent=1&decision=allow&client_id=${O2CI}&redirect_uri=${REDURI}&scope=mail%20openid%20profile" ${AZE} | grep Location`
IMPLICIT=`curl -s -D - -k --request POST --cookie "iPlanetDirectoryPro=${TOK}" --header "Content-Type: application/x-www-form-urlencoded" --data "response_type=id_token%20token&save_consent=1&decision=allow&client_id=${O2CI}&redirect_uri=${REDURI}&scope=mail%20openid%20profile" ${AZE} | grep Location`
HYBRID=`curl -s -D - -k --request POST --cookie "iPlanetDirectoryPro=${TOK}" --header "Content-Type: application/x-www-form-urlencoded" --data "response_type=id_token&save_consent=1&decision=allow&client_id=${O2CI}&redirect_uri=${REDURI}&scope=mail%20openid%20profile" ${AZE} | grep Location`

echo "=> OAuth2 Authorization Code Flow = $CODE" ; echo ""
echo "=> OAuth2 Implicit Flow = $IMPLICIT" ; echo ""
echo "=> OAuth2 Hybrid Flow = $HYBRID" ; echo ""

AC=`echo $CODE | cut -f3 -d=`
ATI=`echo $IMPLICIT | cut -f6 -d=`

echo "####################################################################################"
echo "=> OAuth2 Authorization Code: $AC";
echo "####################################################################################"
echo ""

# Request Access Token will all scopes - TER = Token Endpoint Response
TER=`curl -s -k --request POST --data "grant_type=authorization_code&code=${AC}&redirect_uri=${REDURI}&client_id=${O2CI}&client_secret=${O2CS}&claims=email" ${ATE}`

# An Example of password grant
#TER=`curl -s -k --request POST --user "${O2CI}:${O2CS}" --data "grant_type=password&username=${USERNAME}&passord=${PASSWD}&scope=mail%20cn%20openid%20profile&realm=/${REALM}"  ${ATE}`

echo "=> JSON payload returned from /access_token endpoint using Authorization Code Grant"
echo "$TER" ; echo ""


RT=`j2v TER refresh_token`
IDT=`j2v TER id_token`
AT=`j2v TER access_token`


echo "=> OAuth2 Refresh Token: $RT" ; echo ""
echo "=> OAuth2 Access Token: $AT" ; echo ""
echo "=> OIDC ID Token JWT (decoded) Header: "
echo $IDT | cut -f1 -d.  | /usr/bin/base64 -D ; echo ""
echo ""
echo "=> OIDC ID Token JWT (decoded) Payload: "
echo $IDT | cut -f2 -d.  | /usr/bin/base64 -D ; echo ""

# Can use $AT or $ATI
echo ""
echo "=> Token Info"
#curl -s -k --request POST --header "access_token: $AT" --data "" ${ATE}
#curl -s -k --request POST --header "" --data "access_token=$AT" ${ATE}
curl ${O2}/tokeninfo?access_token=$AT

echo ""
echo "=> User Info"
curl -s -k --request POST --data "access_token=$AT&claims=email" ${UIE}
echo ""


# JSON parsing
# sed -e 's/[{}]/''/g' | awk -v k="text" '{n=split($0,a,","); for (i=1; i<=n; i++) print a[i]}'
