#!/bin/bash
printf "    This script runs all jws rego policy tests inside the docker container. \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker exec -it 05_opa_validate_jws_opa_1 /app/opa_envoy_linux_amd64 test /policy_examples -v
