#!/bin/bash

export agent_RS256_token=$(<../identities/agent-RS256.jws)
export app_RS256_token=$(<../identities/app-details-RS256.jws )
export sub_RS256_token=$(<../identities/customer-RS256.jws)

export agent_ES256_token=$(<../identities/agent-ES256.jws)
export app_ES256_token=$(<../identities/app-details-ES256.jws )
export sub_ES256_token=$(<../identities/customer-ES256.jws)

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**************    Call envoy with valid RS256 jws tokens    **************\n\n"

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: ${app_RS256_token}" \
--header "Subject-Token: ${sub_RS256_token}" \
--header "Actor-Token: ${agent_RS256_token}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**************    Call envoy with no jws tokens   **************\n\n"

curl -v --location --request GET 'http://localhost:8080/anything'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**************    Call envoy with valid ES256 jws tokens    **************\n\n"

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: ${app_ES256_token}" \
--header "Subject-Token: ${sub_ES256_token}" \
--header "Actor-Token: ${agent_ES256_token}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**************    Call envoy with corrupt jws tokens    **************\n\n"

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: www" \
--header "Subject-Token: www" \
--header "Actor-Token: www"
