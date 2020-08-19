#!/bin/bash


export agent_RS256_token=$(<../identities/agent-RS256.jws)
export app_RS256_token=$(<../identities/app-details-RS256.jws )
export sub_RS256_token=$(<../identities/customer-RS256.jws)

export agent_ES256_token=$(<../identities/agent-ES256.jws)
export app_ES256_token=$(<../identities/app-details-ES256.jws )
export sub_ES256_token=$(<../identities/customer-ES256.jws)

export valid_RS256_tokens="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${agent_RS256_token}\",\"app-token\":\"${app_RS256_token}\",\"subject-token\":\"${sub_RS256_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"
export valid_ES256_tokens="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${agent_ES256_token}\",\"app-token\":\"${app_ES256_token}\",\"subject-token\":\"${sub_ES256_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"

printf "******* Test valid RS256 jws Tokens (SHOULD SUCCEED) ******* \n\n"

#curl -v --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true&explain=full' \

curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header 'Content-Type: text/plain' \
--data-raw "${valid_RS256_tokens}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "******* Test valid ES256 jws Tokens (SHOULD SUCCEED) ******* \n\n"

#curl -v --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true&explain=full' \

curl --location --request POST 'http://localhost:8181/v1/data/envoy/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header 'Content-Type: text/plain' \
--data-raw "${valid_ES256_tokens}"

docker logs 05_opa_validate_jws_opa_1   2> bug_report_rest_succeeds_opa_logs.json
docker logs 05_opa_validate_jws_envoy_1 2> bug_report_rest_succeeds_envoy_logs.txt
