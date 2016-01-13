#!/bin/sh

# Author: wajih.ahmed
# This script only works with latest night build of OpenAM 13
# This scipts adds custom resource types, an application adn then associated policies


URL="http://mbp.wfoo.net:8081/openam"
AUTHN="${URL}/json/authenticate"

TOK=`curl -s -k --request POST --header "X-OpenAM-Username: amadmin" --header "X-OpenAM-Password: Admin123" --header "Content-Type: application/json" --data "{}" $AUTHN | cut -f2 -d: | cut -f1 -d, | sed -e 's/"//g'` 

j2v ()
{
    # Note how variable is dereferenced aka indirect expansion :-)
    echo ${!1} | sed -e "s/^.*\"$2\"[ ]*:[ ]*\"//" -e 's/".*//'
}

echo "=> OpenAM Token: ${TOK}" ; echo ""

#Create New Resource Type
RT=`curl "${URL}/json/resourcetypes?_action=create" \
--silent \
--cookie "iPlanetDirectoryPro=${TOK}" \
--header 'Content-Type: application/json' \
--data '{
    "patterns":["book/screen","book/screen/button","book/reports","book/dashboard","amount"],
    "actions": {
        "approve": false,
        "view": true,
        "modify": false,
        "book": false
    },
    "name": "Trade Book",
    "description": "Trading Resource Types"
}'`


UUID=`j2v RT uuid`
echo "=> UUID: ${UUID}" ; echo ""

#Create New Application
curl "${URL}/json/applications/?_action=create"  \
--cookie "iPlanetDirectoryPro=${TOK}" \
--header 'Content-Type: application/json' \
--data '{
    "resourceTypeUuids":  ["'"${UUID}"'"],
    "applicationType": "iPlanetAMWebAgentService",
    "realm": "/",
    "conditions": ["AMIdentityMembership","AND","AuthLevel","AuthScheme","AuthenticateToRealm","AuthenticateToService","IPv4","IPv6","LDAPFilter","LEAuthLevel","NOT","OAuth2Scope","OR","Policy","ResourceEnvIP","Script","Session","SessionProperty","SimpleTime"],
    "subjects": ["AND","AuthenticatedUsers","Identity","JwtClaim","NONE","NOT","OR","Policy"],
    "entitlementCombiner": "DenyOverride",
    "name": "Quick Trade",
    "description": "The Quick Trade Application",
    "editable": "true",
    "attributeNames": [""]
}'

echo "" ; echo ""

#Create New Policy
curl "${URL}/json/policies/Trader" -X PUT \
--header 'Content-Type: application/json' \
--header 'If-None-Match: *' \
--cookie "iPlanetDirectoryPro=${TOK}" \
--data '{
    "applicationName": "Quick Trade",
    "actions": {
        "book":true,
        "view":true
    },
    "resources": ["book/screen","book/screen/button","book/screen/tab","amount"],
    "resourceTypeUuid": "'"${UUID}"'",
    "subject": {
        "type":"Identity",
        "subjectValues": ["id=trader,ou=group,dc=openam,dc=forgerock,dc=org"]
    },
    "condition": {
        "type": "LDAPFilter",
        "ldapFilter": "postalAddress=USA"
    },
    "name": "Trader",
    "description": "",
    "actionValues": {
        "book":true,
        "view":true
    },
    "resourceAttributes": [
        {
            "type": "User",
            "propertyName": "cn",
            "propertyValues": [
            ]
        },
        {
            "type": "Static",
            "propertyName": "attr1",
            "propertyValues": [
                "one"
            ]
        }
    ]
}'

echo ""


# '{"name":"Trader","active":true,"description":"","resources":["book/screen","book/screen/button","book/screen/tab"],"applicationName":"Quick Trade","actionValues":{"book":true,"view":true},"subject":{"type":"AND","subjects":[{"type":"JwtClaim","claimName":"sub","claimValue":"trader joe"}]},"resourceTypeUuid":"337bf803-a9d0-4843-81f8-b4176a5d720e","actions":{"book":true,"view":true},"resourceAttributes":[]}'
