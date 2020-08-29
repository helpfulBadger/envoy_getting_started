#!/bin/bash

printf "\n\n    This script starts an envoy front proxy and exposes it on localhost:8080.\n"
printf "    Envoy is configured to forward traffic to an httpbin instance that is only exposed inside docker.\n"
printf "    It also starts fluent bit. elasticSearch and kibana and configures the docker log driver to forward logs\n"
printf "\n\n**************    Starting envoy & httpbin via docker-compose   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose up -d --build

printf "\n\n**************    Checking to make sure everything is started    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker ps -a

printf "\n\n**************    Waiting 30 seconds for elasticSearch to be ready   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
sleep 30
curl -v --location --request GET 'http://localhost:9200'

printf "\n\n**************    Opening Kibana and setting up an index   **************\n\n"
printf "    If elasticSearch response above says it's ready then open kiban in a web browser and setup an index.\n"
printf "    If elasticSearch response above indicates that it isn't ready then wait a bit.\n"
printf "    The command below works on Mac OSX to open kibana in a browser. If it doesn't work on your OS then \n"
printf "    open your web browser and navigate to http://localhost:5601/app/kibana#/management/kibana/index_pattern?_g=()\n"
printf "    Click create index and enter log* as the pattern.\n"
printf "\n\n    Then come back here to go to the next step.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

open "http://localhost:5601/app/kibana#/management/kibana/index_pattern?_g=()"

printf "\n\n**************    Opening Kibana log search page   **************\n\n"
printf "    On the search page, you should already see envoy logs streaming in.\n"
printf "    Explore the envoy logs and come back here when you are ready. \n"
printf "\n\n    When you are ready for the next step hit enter.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
open "http://localhost:5601/app/kibana#/discover"

printf "\n\n**************    Calling httpbin via envoy front proxy    **************\n\n"
printf "    The following curl command initiates a request through envoy to httpbin.\n"
printf "    Explore the logs and come back here when you are ready to clean up. \n"
read -n 1 -r -s -p $'Press enter to continue...\n'
curl -v --location --request GET 'http://localhost:8080/anything'

printf "\n\n**************    Cleaning up and removing docker instances    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker-compose down
