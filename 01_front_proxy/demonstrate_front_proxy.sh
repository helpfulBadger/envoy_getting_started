#!/bin/bash

printf "\n\n    This script starts an envoy front proxy and exposes it on localhost:8080.\n"
printf "    Envoy is configured to forward traffic to an httpbin instance that is only exposed inside docker.\n"
printf "\n\n**************    Starting envoy & httpbin via docker-compose   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose up -d --build

printf "\n\n**************    Checking to make sure everything is up    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker ps -a
printf "\n\n**************    Calling httpbin via envoy front proxy    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything'

printf "\n\n**************    Cleaning up and removing docker instances    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose down
