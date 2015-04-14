#!/bin/sh

curl \
 --header "X-OpenIDM-Username: openidm-admin" \
 --header "X-OpenIDM-Password: openidm-admin" \
 --header "Content-Type: application/json" \
 --request POST \
 --data '{
  "_id":"bond",
  "userName":"bond",
  "sn":"Bond",
  "givenName":"James",
  "mail":"james@example.com",
  "telephoneNumber":"5556787",
  "description":"Created by OpenIDM REST.",
  "password":"Admin123",
  "shell":"/bin/bash"
 }' \
 "http://localhost:9080/openidm/managed/user?_action=create"
