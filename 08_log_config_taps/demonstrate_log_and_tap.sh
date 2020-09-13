#!/bin/bash

printf "\n\n    This script starts an envoy front proxy and exposes it on localhost:8080.\n"
printf "    Envoy is configured to forward traffic to an httpbin instance that is only exposed inside docker.\n"
printf "    It also starts fluent bit. elasticSearch and kibana and configures the docker log driver to forward logs\n"
printf "\n\n**************    Starting envoy & httpbin via docker-compose   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose up -d

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to check to make sure everything is started    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker ps -a

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to wait 30 seconds for elasticSearch to be ready   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n               ...Waiting 30 seconds.....\n\n"
sleep 30
curl -v --location --request GET 'http://localhost:9200'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to call httpbin via envoy front proxy    **************\n\n"
printf "    The following curl command initiates a request through envoy to httpbin.\n"
printf "    Explore the logs and come back here when you are ready to clean up. \n"
read -n 1 -r -s -p $'Press enter to continue...\n'
curl -v --location --request GET 'http://localhost:8080/anything'




read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to clean up and remove docker instances    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker-compose down




files=($( ls * )) #Add () to convert output to array
counter=0
for i in $files ; do
  echo Next: $i
  let counter=$counter+1
  echo $counter
done