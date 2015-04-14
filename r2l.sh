#!/bin/sh

# This script will work only if the auth filter is using "method" : "simple"

URL=http://mbp.wfoo.net:5080/r2l

curl \
 --request PUT \
 --header "Content-Type: application/json" \
 --header "If-None-Match: *" \
 --header "X-OpenIDM-Username: cn=Directory Manager" \
 --header "X-OpenIDM-Password: Admin123" \
 --data '{
  "_id": "r2luser1",
  "contactInformation": {
    "telephoneNumber": "+1 408 555 1212",
    "emailAddress": "r2luser1@example.com"
  },
  "name": {
    "familyName": "New",
    "givenName": "User"
  },
  "displayName": "New User"
 }' \
 ${URL}/users/r2luser1


curl \
--header "X-OpenIDM-Username: cn=Directory Manager" \
--header "X-OpenIDM-Password: Admin123" \
 ${URL}/users/r2luser1
