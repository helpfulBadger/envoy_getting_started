#!/bin/bash

printf "\n\n    This script starts an envoy front proxy and exposes it on localhost:8080.\n"
printf "    Envoy is configured to forward traffic to an Open Policy Agent instance via gRPC to authorize each request.\n"
printf "    Envoy is then configured to forward traffic to an httpbin instance that is only exposed inside docker.\n"
printf "\n\n**************    Starting envoy, opa & httpbin via docker-compose   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose up -d --build

printf "\n\n**************    About to check to make sure everything is started    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker ps -a

printf "\n\n**************    About to call httpbin via envoy front proxy    **************\n\n"
printf "    The following curl command initiates a request through envoy to httpbin.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
curl -v --location --request GET 'http://localhost:8080/anything'

printf "\n\n**************    Viewing the decision logs    **************\n\n"
printf "    The command above should have succeeded. Now let's take a look at the opa decision logs.\n"
printf "    They are in json lines format. If needed, copy an paste to your favorite json viewer to read them more easily.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker logs 03_opa_integration_opa_1

printf "\n\n**************    About to make a call via a forbidden POST method    **************\n\n"
printf "    The following curl command initiates a request through envoy to httpbin.\n"
printf "    This request should be blocked. \n"
read -n 1 -r -s -p $'Press enter to continue...\n'
curl -v --location --request POST 'http://localhost:8080/anything'

printf "\n\n**************    About to view the decision logs    **************\n\n"
printf "    The command above should have been blocked. Now let's take a look at the opa decision logs.\n"
printf "    They are in json lines format. If needed, copy an paste to your favorite json viewer to read them more easily.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker logs 03_opa_integration_opa_1

printf "\n\n**************    About to clean up and remove docker instances    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker-compose down
