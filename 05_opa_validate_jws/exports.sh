#!/bin/bash

#export valid_RS256_tokens=$(<./allowed-RS256/input.json) && echo ${valid_RS256_tokens} | jq '.'
#export valid_RS256_tokens=$(<./allowed-RS256/input.json) && echo ${valid_RS256_tokens} | jq '.'

export agent_RS256_token=$(<identities/agent-RS256.jws)
export app_RS256_token=$(<identities/app-details-RS256.jws )
export sub_RS256_token=$(<identities/customer-RS256.jws)

export agent_ES256_token=$(<identities/agent-ES256.jws)
export app_ES256_token=$(<identities/app-details-ES256.jws )
export sub_ES256_token=$(<identities/customer-ES256.jws)


export corrupt_agent_token=$(<identities/agent-RS256-tampered.jws)
export corrupt_app_token=$(<identities/app-details-ES256-tampered.jws)
export corrupt_sub_token=$(<identities/customer-RS256-tampered.jws)


export direct_opa_call_valid_RS256_tokens="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${agent_RS256_token}\",\"app-token\":\"${app_RS256_token}\",\"subject-token\":\"${sub_RS256_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"
export direct_opa_call_valid_ES256_tokens="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${agent_ES256_token}\",\"app-token\":\"${app_ES256_token}\",\"subject-token\":\"${sub_ES256_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"

export tampered_1="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${corrupt_agent_token}\",\"app-token\":\"${app_ES256_token}\",\"subject-token\":\"${sub_ES256_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"
export tampered_2="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${agent_ES256_token}\",\"app-token\":\"${corrupt_app_token}\",\"subject-token\":\"${corrupt_sub_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Testing with 1 tampered jws Tokens (SHOULD FAIL)******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "${tampered_1}"


read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "*******             Dumping token to screen             *******\n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

echo "${tampered_1}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Testing with 2 tampered jws Tokens (SHOULD FAIL)******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'


curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--data-raw "${tampered_2}"

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "*******             Dumping token to screen             *******\n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

echo "${tampered_2}"
