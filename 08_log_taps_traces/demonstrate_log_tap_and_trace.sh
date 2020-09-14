#!/bin/bash

printf "\n\n**************    Demostration of configuring log fields, taps and traces    **************\n\n"
printf "\n\n    This script starts an envoy front proxy and exposes it on localhost:8080.\n"
printf "    Envoy is configured to forward traffic to service 1 and it in turn calls service 2.\n"

printf "\n\n**************    About to remove temporary files from previous run (if any)    **************\n\n"
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
rm -Rf tmp/
mkdir -p tmp/service1
mkdir -p tmp/service2
mkdir -p tmp/front

printf "\n\n**************    Starting envoy, service 1 and service 2 via docker-compose   **************\n\n"
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'

docker-compose up -d --build

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to check to make sure everything is started    **************\n\n"
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
docker ps -a

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to call service 1 via Envoy to start a trace   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
curl --location --request GET 'localhost:8000/trace/1' 

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n*********************************************************************************************************\n\n"
printf "\n\n**************                              CUSTOM LOG FORMAT                              **************\n\n"
printf "\n\n*********************************************************************************************************\n\n"
printf "\n\n**************    About to show the logs for the Front Proxy Envoy in our new custom format   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker logs 08_log_taps_traces_front-envoy_1 1>tmp/front_envoy_stdOut.log 2>tmp/front_envoy_stdErr.log
cat tmp/front_envoy_stdOut.log | docker run --rm -i imega/jq '.' --sort-keys && printf "\n\n"

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to show the logs for service 1's Envoy in our new custom format   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker logs 08_log_taps_traces_service1_1 1>tmp/service1_envoy_stdOut.log 2>tmp/service1_envoy_stdErr.log
cat tmp/service1_envoy_stdOut.log | docker run --rm -i imega/jq '.' --sort-keys && printf "\n\n"

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to show the logs for service 2's Envoy in our new custom format   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker logs 08_log_taps_traces_service2_1 1>tmp/service2_envoy_stdOut.log 2>tmp/service2_envoy_stdErr.log
cat tmp/service2_envoy_stdOut.log | docker run --rm -i imega/jq '.' --sort-keys && printf "\n\n"

printf "\n\n*********************************************************************************************************\n\n"
printf "\n\n**************                        TAPS for REQUESTs & RESPONSES                        **************\n\n"
printf "\n\n*********************************************************************************************************\n\n"

printf "\n\n**************    About to show the Request / Response TAPS for the Front Proxy Envoy in our new custom format   **************\n\n"
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
printf "\n\n**************    About to show the Request / Response TAPS for service 1's Envoy in our new custom format   **************\n\n"
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

read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n\n**************    About to show the Request / Response TAPS for service 2's Envoy in our new custom format   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

ls -alGh tmp/service2
read -n 1 -r -s -p $'Press enter to continue...\n'

for file in tmp/service2/*; do 
    printf "\n\n**************    Displaying Tap    **************\n\n"
    printf "\n\n ...File: ${i} \n\n"
    cat $file
    read -n 1 -r -s -p $'Press enter to continue...\n'
    printf "\n\n**************    decoding response body   **************\n\n"
    cat $file | docker run --rm -i imega/jq -r '.http_buffered_trace.response.body.as_bytes' | base64 -d && printf "\n\n"
    read -n 1 -r -s -p $'Press enter to continue...\n'
done

printf "\n\n*********************************************************************************************************\n\n"
printf "\n\n**************                                    TRACES                                   **************\n\n"
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

