#!/bin/bash

printf "\n\n    This script starts an Envoy Server via docker compose and demonstrates the use of JWS authorization policies.\n"
printf "\n\n**************    About to start envoy via docker-compose   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

export agent_RS256_token=$(<identities/agent-RS256.jws)
export app_RS256_token=$(<identities/app-details-RS256.jws )
export sub_RS256_token=$(<identities/customer-RS256.jws)

export agent_ES256_token=$(<identities/agent-ES256.jws)
export app_ES256_token=$(<identities/app-details-ES256.jws )
export sub_ES256_token=$(<identities/customer-ES256.jws)

export direct_opa_call_valid_RS256_tokens="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${agent_RS256_token}\",\"app-token\":\"${app_RS256_token}\",\"subject-token\":\"${sub_RS256_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"
export direct_opa_call_valid_ES256_tokens="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${agent_ES256_token}\",\"app-token\":\"${app_ES256_token}\",\"subject-token\":\"${sub_ES256_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"

docker-compose up -d --build

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to check to make sure everything is started    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker ps -a

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n******* About to send a request to envoy with valid RS256 jws Tokens (SHOULD SUCCEED) ******* \n\n"
printf "    The request will go to envoy. Envoy forwards it to Open Policy Agent (OPA). There are 3 identity tokens in this mock.\n"
printf "    OPA takes tokens out of the headers and validates the signature on each. If the signatures are valid it lets the request through.\n"
printf "    Envoy uses the decision from OPA to determine if it forwards the request to httpbin or not.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: ${app_RS256_token}" \
--header "Subject-Token: ${sub_RS256_token}" \
--header "Actor-Token: ${agent_RS256_token}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "************** About to send call envoy with valid ES256 jws tokens (SHOULD SUCCEED) **************\n\n"
printf "    This example is the same as the previous one except the tokens are signed with the ES256 algorithm.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: ${app_ES256_token}" \
--header "Subject-Token: ${sub_ES256_token}" \
--header "Actor-Token: ${agent_ES256_token}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**************   About to call envoy with no jws tokens (SHOULD BE BLOCKED)   **************\n\n"
printf "    In this example the identity tokens are missing. OPA will not be able to validate\n"
printf "    the tokens and return a blocking decision to Envoy.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "**************    About to send call envoy with corrupt jws tokens (SHOULD BE BLOCKED)    **************\n\n"
printf "    In this example the identity tokens are corrupt. OPA will not be able to validate\n"
printf "    the tokens and throw an error. OPA errors result in blocking the request.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything' \
--header "App-Token: www" \
--header "Subject-Token: www" \
--header "Actor-Token: www"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to view the decision logs    **************\n\n"
printf "    Now let's take a look at the envoy decision logs.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker logs 06_envoy_validate_jws_envoy_1

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to clean up and remove docker instances    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
docker-compose down
