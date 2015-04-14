#!/bin/sh

URL="http://mbp.wfoo.net:8081/openam"
#URL="http://mbp.wfoo.net:8080/openam"


curl -k -H 'X-Requested-With: XMLHttpRequest' ${URL}/setup/setSetupProgress &

curl -k -H 'X-Requested-With: XMLHttpRequest' \
 --request POST \
 --data 'DIRECTORY_SSL=SIMPLE&DIRECTORY_SERVER=localhost&DIRECTORY_JMX_PORT=61686&ROOT_SUFFIX=dc%3Dopenam%2Cdc%3Dforgerock%2Cdc%3Dorg&locale=en_US&AM_ENC_KEY=Admin12345678&DS_DIRMGRPASSWD=Admin123&AMLDAPUSERPASSWD=Agent123&AMLDAPUSERPASSWD_CONFIRM=Agent123&BASE_DIR=/Users/wahmed/sandbox/poc/sp_config&ADMIN_PWD=Admin123&ADMIN_CONFIRM_PWD=Admin123&SERVER_URI=%2Fopenam&DIRECTORY_PORT=6389&DATA_STORE=embedded&SERVER_HOST=sp.wfoo.org&DS_DIRMGRDN=cn%3DDirectory+Manager&DIRECTORY_ADMIN_PORT=6444&SERVER_URL=http%3A%2F%2Fsp.wfoo.org%3A6080&acceptLicense=true&PLATFORM_LOCALE=en_US&COOKIES_DOMAIN=.wfoo.org&' \
 ${URL}/config/configurator

