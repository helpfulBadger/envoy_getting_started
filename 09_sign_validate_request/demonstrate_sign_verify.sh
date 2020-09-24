#!/bin/bash

printf "\n\n**************    Demostration of signing and verifying signed requests using OPA    **************\n\n"
printf "\n\n    This script starts an envoy front proxy and exposes it on localhost:8000.\n"
printf "    The Envoy front proxy is configured to forward traffic to Envoy service 1 and it in turn calls the App.\n"
printf "    Signatures will still work if the signed headers and body are missing or empty.\n"
printf "    In both cases it prevents someone from adding values to missing or empty fields.\n"

printf "\n\n**************    About to remove temporary logs and taps files from previous run (if any)    **************\n\n"
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
rm -Rf tmp/
mkdir -p tmp/service1
mkdir -p tmp/front

printf "\n\n**************    Starting the environment via docker-compose   **************\n\n"
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'

docker-compose up -d --build

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to check to make sure everything is started    **************\n\n"
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
docker ps -a


# All signed attributes are missing
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    Sending a request with all signed fields missing.   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
curl --location --request POST 'localhost:8000/anything' \
        --header 'Content-Type: application/json' \
        --header 'Accept: application/json' 


# All signed attributes empty
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    Sending a request with all signed fields empty.   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
curl --location --request POST 'localhost:8000/anything' \
        --header 'Content-Type: application/json' \
        --header 'Accept: application/json' \
        --header 'Actor-Token:' \
        --header 'App-Token:' \
        --header 'Subject-Token:' \
        --header 'Session-Id:' \
        --header 'Request-Id:' \
        --data-raw ""


# All signed attributes are populated
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    Sending a request with all signed fields populated.   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl --location --request POST 'localhost:8000/anything' \
        --header 'Content-Type: application/json' \
        --header 'Accept: application/json' \
        --header 'Actor-Token: some_user' \
        --header 'App-Token: some_app' \
        --header 'Subject-Token: some_subject' \
        --header 'Session-Id: 0001' \
        --header 'Request-Id: 0001' \
        --data-raw "{\"body-key\":\"body-value\"}"


read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n*********************************************************************************************************\n\n"
printf "\n\n**************                              Displaying LOGs                                **************\n\n"
printf "\n\n*********************************************************************************************************\n\n"
printf "\n\n**************    About to show the logs for the Front Proxy Envoy                         **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker logs 09_sign_validate_request_front-envoy_1 1>tmp/front_envoy_stdOut.log 2>tmp/front_envoy_stdErr.log
cat tmp/front_envoy_stdOut.log | docker run --rm -i imega/jq '.' --sort-keys && printf "\n\n"

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to show the Open Policy Agent logs for signing the request         **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker logs 09_sign_validate_request_sign_1 1>tmp/signing_opa_stdOut.log 2>tmp/signing_opa_stdErr.log
cat tmp/signing_opa_stdErr.log | docker run --rm -i imega/jq '.' --sort-keys && printf "\n\n"


read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to show the logs for service 1's Envoy                             **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker logs 09_sign_validate_request_service1_1 1>tmp/service1_envoy_stdOut.log 2>tmp/service1_envoy_stdErr.log
cat tmp/service1_envoy_stdOut.log | docker run --rm -i imega/jq '.' --sort-keys && printf "\n\n"

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to show the Open Policy Agent logs for verifying the request         **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker logs 09_sign_validate_request_verify_1 1>tmp/verifying_opa_stdOut.log 2>tmp/verifying_opa_stdErr.log
cat tmp/verifying_opa_stdErr.log | docker run --rm -i imega/jq '.' --sort-keys && printf "\n\n"



printf "\n\n*********************************************************************************************************\n\n"
printf "\n\n**************                   Displaying TAPS for REQUESTs & RESPONSES                  **************\n\n"
printf "\n\n*********************************************************************************************************\n\n"

printf "\n\n**************    About to show the Request / Response TAPS for the Front Proxy Envoy      **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

ls -alGh tmp/front
read -n 1 -r -s -p $'Press enter to continue...\n'

for file in tmp/front/*; do 
    printf "\n\n**************    Displaying Tap    **************\n\n"
    printf "\n\n ...File: ${i} \n\n"
    cat $file
    read -n 1 -r -s -p $'Press enter to continue...\n'
    printf "\n\n**************    decoding response body   **************\n\n"
    cat $file | docker run --rm -i imega/jq -r '.http_buffered_trace.response.body.as_bytes' | base64 -d && printf "\n\n"
    read -n 1 -r -s -p $'Press enter to continue...\n'
done

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to show the Request / Response TAPS for service 1's Envoy          **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

ls -alGh tmp/service1
read -n 1 -r -s -p $'Press enter to continue...\n'

for file in tmp/service1/*; do 
    printf "\n\n**************    Displaying Tap    **************\n\n"
    printf "\n\n ...File: ${i} \n\n"
    cat $file
    read -n 1 -r -s -p $'Press enter to continue...\n'
    printf "\n\n**************    decoding response body   **************\n\n"
    cat $file | docker run --rm -i imega/jq -r '.http_buffered_trace.response.body.as_bytes' | base64 -d && printf "\n\n"
    read -n 1 -r -s -p $'Press enter to continue...\n'
done

printf "\n\n*********************************************************************************************************\n\n"
printf "\n\n**************                              Displaying TRACES                              **************\n\n"
printf "\n\n*********************************************************************************************************\n\n"
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    Open a web browser to show the traces in Jaeger    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

open "http://localhost:16686/"


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to clean up and remove docker instances    **************\n\n"
printf "\n\n          ....    Logs and Taps will left in the tmp directory for exploration after program exit\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker-compose down

