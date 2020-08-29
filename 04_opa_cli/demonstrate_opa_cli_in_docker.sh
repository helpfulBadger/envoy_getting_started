#!/bin/bash

printf "\n\n    This script starts an OPA Server via docker compose and demonstrates testing policies without a local install.\n"
printf "\n\n**************    Starting opa via docker-compose   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose up -d --build

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to check to make sure everything is started    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker ps -a

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to run an OPA policy with an allowed input    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker exec -it 04_opa_cli_opa_1 /app/opa_envoy_linux_amd64 eval -i /data/allowed_input.json -d /policies/policy.rego 'data.envoy.authz.allow'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to run an OPA policy with an denied input    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker exec -it 04_opa_cli_opa_1 /app/opa_envoy_linux_amd64 eval -i /data/blocked_input.json -d /policies/policy.rego 'data.envoy.authz.allow'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to view the decision logs    **************\n\n"
printf "    Now let's take a look at the opa decision logs.\n"
printf "    They are in json lines format. If needed, copy an paste to your favorite json viewer to read them more easily.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker logs 04_opa_cli_opa_1

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to clean up and remove docker instances    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker-compose down
