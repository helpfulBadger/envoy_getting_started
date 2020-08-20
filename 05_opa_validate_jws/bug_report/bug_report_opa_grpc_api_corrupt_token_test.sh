#!/bin/bash

export agent_RS256_token=$(<../identities/agent-RS256.jws)
export app_RS256_token=$(<../identities/app-details-RS256.jws )
export sub_RS256_token=$(<../identities/customer-RS256.jws)

export agent_ES256_token=$(<../identities/agent-ES256.jws)
export app_ES256_token=$(<../identities/app-details-ES256.jws )
export sub_ES256_token=$(<../identities/customer-ES256.jws)

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**************    Call envoy with corrupt jws tokens    **************\n\n"

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: www" \
--header "Subject-Token: www" \
--header "Actor-Token: www"

docker logs 05_opa_validate_jws_opa_1   2> bug_report_grpc_corrupt_token_opa_logs.json
docker logs 05_opa_validate_jws_envoy_1 2> bug_report_grpc_corrupt_token_envoy_logs.txt
