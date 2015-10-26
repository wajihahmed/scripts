keytool \
 -genkey \
 -alias jwe-key \
 -keyalg rsa \
 -keystore ./keystore.jks \
 -storepass changeit \
 -keypass changeit \
 -dname "CN=www.wfoo.org,O=WFOO"
 
 
 #
