#!/bin/bash

export valid_RS256_tokens=$(<./allowed-RS256/input.json)
export valid_ES256_tokens=$(<./allowed-ES256/input.json)

export missing_tokens=$(<./missing/input.json)
export tampered_token=$(<./tampered-token/input.json)
export tampered_tokens=$(<./tampered-tokens/input.json)

export corrupt_ES256_tokens=$(<./corrupt-ES256/input.json)
export corrupt_RS256_tokens=$(<./corrupt-RS256/input.json)

# export valid_RS256_tokens=$(<./allowed-RS256/input.json) && echo ${valid_RS256_tokens} | jq '.'

printf "    This script runs the Open Policy Agent REST API and verifies the valid and invalid token scenarios. \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n\n'

docker-compose up -d

printf "About to confirm OPA is up and running with  ---> docker ps\n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

docker ps

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test valid RS256 jws Tokens (SHOULD SUCCEED) ******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

#curl -v --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true&explain=full' \

curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "{\"input\":${valid_RS256_tokens}}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test valid ES256 jws Tokens (SHOULD SUCCEED) ******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

#curl -v --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true&explain=full' \

curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "{\"input\":${valid_ES256_tokens}}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test missing jws Tokens (SHOULD FAIL)******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

#curl -v --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true&explain=full' \
curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "{\"input\":${missing_tokens}}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test corrupt ES256 jws Tokens (SHOULD FAIL)******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

#curl -v --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true&explain=full' \
curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "{\"input\":${corrupt_ES256_tokens}}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test corrupt RS256 jws Tokens (SHOULD FAIL)******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

#curl -v --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true&explain=full' \
curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "{\"input\":${corrupt_RS256_tokens}}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Testing with a single tampered jws Tokens (SHOULD FAIL)******* \n\n"
printf "          Agent-Authenticated    should = false\n"
printf "          App-Authenticated      should = true\n"
printf "          Customer-Authenticated should = true\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

#curl -v --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true&explain=full' \
curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "{\"input\":${tampered_token}}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Testing with 2 tampered jws Tokens (SHOULD FAIL)******* \n\n"
printf "          Agent-Authenticated    should = true\n"
printf "          App-Authenticated      should = false\n"
printf "          Customer-Authenticated should = false\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

#curl -v --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true&explain=full' \
curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "{\"input\":${tampered_tokens}}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "\nAbout to shut down and clean up\n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

docker-compose down
