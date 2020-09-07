#!/bin/bash
printf "    This script runs all jws rego policy tests inside the docker container. \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n\n'

docker-compose up -d

printf "About to confirm OPA is up and running with  ---> docker ps\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n\n'

docker ps

printf "About to run OPA tests ---> docker exec opa test /policies -v \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n\n'

docker exec -it policy_examples_opa_1 /app/opa_envoy_linux_amd64 test /policies -v

printf "\nAbout to shut down and clean up\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose down
