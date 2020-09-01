#!/bin/bash

printf "\n\n    This script starts an envoy front proxy and exposes it on localhost:8080.\n"
printf "    Envoy is configured to forward traffic to an httpbin instance that is only exposed inside docker.\n"
printf "\n\n**************    Starting envoy & httpbin via docker-compose   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose up -d
# if you want to force a rebuild of the envoy container use the --build parameter
# docker-compose up -d --build

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to check to make sure everything is up    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker ps -a
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to call httpbin via envoy front proxy    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to clean up and remove docker instances    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose down
