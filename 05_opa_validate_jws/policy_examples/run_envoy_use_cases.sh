#!/bin/bash

export agent_RS256_token=$(<../identities/agent-RS256.jws)
export app_RS256_token=$(<../identities/app-details-RS256.jws )
export sub_RS256_token=$(<../identities/customer-RS256.jws)

export agent_ES256_token=$(<../identities/agent-ES256.jws)
export app_ES256_token=$(<../identities/app-details-ES256.jws )
export sub_ES256_token=$(<../identities/customer-ES256.jws)

export agent_RS256_tampered=$(<../identities/agent-RS256-tampered.jws)
export app_details_ES256_tampered=$(<../identities/app-details-ES256-tampered.jws)
export customer_RS256_tampered=$(<../identities/customer-RS256-tampered.jws)

printf "**************************************************************************\n"
printf "**************    Call envoy with valid RS256 jws tokens    **************\n"
printf "**************                   SHOULD PASS                **************\n"
printf "**************************************************************************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: ${app_RS256_token}" \
--header "Subject-Token: ${sub_RS256_token}" \
--header "Actor-Token: ${agent_RS256_token}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**************************************************************************\n"
printf "**************    Call envoy with valid ES256 jws tokens    **************\n"
printf "**************                   SHOULD PASS                **************\n"
printf "**************************************************************************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: ${app_ES256_token}" \
--header "Subject-Token: ${sub_ES256_token}" \
--header "Actor-Token: ${agent_ES256_token}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "****************************************************************\n"
printf "**************    Call envoy with no jws tokens   **************\n"
printf "**************              SHOULD FAIL           **************\n"
printf "****************************************************************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**********************************************************************\n"
printf "**************    Call envoy with corrupt jws tokens    **************\n"
printf "**************                 SHOULD FAIL              **************\n"
printf "**********************************************************************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: www" \
--header "Subject-Token: www" \
--header "Actor-Token: www"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**********************************************************************\n"
printf "**************    Call envoy with 1 tampered jws token    **************\n"
printf "**************                 SHOULD FAIL              **************\n"
printf "**********************************************************************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: ${app_ES256_token}" \
--header "Subject-Token: ${sub_ES256_token}" \
--header "Actor-Token: ${agent_RS256_tampered}"


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "*************************************************************************\n"
printf "**************    Call envoy with 2 tampered jws tokens    **************\n"
printf "**************                  SHOULD FAIL                **************\n"
printf "*************************************************************************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: ${app_details_ES256_tampered}" \
--header "Subject-Token: ${customer_RS256_tampered}" \
--header "Actor-Token: ${agent_RS256_token}"
