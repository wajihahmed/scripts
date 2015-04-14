
#curl -s -k --request POST --data "username=cdouthart&password=P@ssw0rd&uri=realm=/poc"  http://ec2-54-68-187-143.us-west-2.compute.amazonaws.com:8080/openam/identity/authenticate

#curl -s -k --request POST --header "X-OpenAM-Username: amadmin" \
#--header "X-OpenAM-Password: Admin123" \
#--header "Content-Type: application/json" \
#--data "{}" \
#http://mbp.wfoo.net:8080/openam/json/authenticate

#curl --request POST --header "X-OpenAM-Username: cdouthart" --header "X-OpenAM-Password: P@ssw0rd" --header "Content-Type: application/json" --data "{}"\
 # http://ec2-54-68-187-143.us-west-2.compute.amazonaws.com:8080/openam/json/poc/authenticate


#curl \
 #--request POST \
 #--header "X-OpenAM-Username: demo" \
 #--header "X-OpenAM-Password: changeit" \
 #--header "Content-Type: application/json" \
 #--data "{}" \
 #http://mbp.wfoo.net:8080/openam/json/authenticate


 curl \
 --request POST \
 --header "X-OpenAM-Username: cdouthart" \
 --header "X-OpenAM-Password: P@ssw0rd" \
 --header "Content-Type: application/json" \
 --data "{}" \
 http://ec2-54-68-187-143.us-west-2.compute.amazonaws.com:8080/openam/json/poc/authenticate
