#!/bin/sh

curl -k -H "Content-type: application/json" -u "openidm-admin:openidm-admin" -X POST "http://localhost:9080/openidm/recon?_action=recon&mapping=systemLdapAccounts_managedUser"
