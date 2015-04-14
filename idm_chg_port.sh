#!/bin/sh

find . -name 'boot.properties' -exec perl -pi.orig -e 's/8080/9080/g ; s/8443/9443/g ; s/8444/9444/g' {} \;
find . -name 'ui-configuration.json' -exec perl -pi.orig -e 's/\"selfRegistration\"\s:\sfalse,/\"selfRegistration\"\s:\strue,/g ; 's/\"securityQuestions\"\s:\strue,/g'


