#!/bin/sh

curl \
 --header "Content-Type: application/json" \
 --header "X-OpenIDM-Username: openidm-admin" \
 --header "X-OpenIDM-Password: openidm-admin" \
 --request GET \
 "http://localhost:9080/openidm/endpoint/getfwid"

#curl \
# --header "Content-Type: application/json" \
# --header "X-OpenIDM-Username: openidm-admin" \
# --header "X-OpenIDM-Password: openidm-admin" \
# --request POST \
# --data { "name": "bob"} \
# "http://localhost:9080/openidm/endpoint/msfwid?_action=new"
