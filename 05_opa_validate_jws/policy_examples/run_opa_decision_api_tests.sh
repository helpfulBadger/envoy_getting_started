#!/bin/bash


export agent_RS256_token=$(<../identities/agent-RS256.jws)
export app_RS256_token=$(<../identities/app-details-RS256.jws )
export sub_RS256_token=$(<../identities/customer-RS256.jws)

export agent_ES256_token=$(<../identities/agent-ES256.jws)
export app_ES256_token=$(<../identities/app-details-ES256.jws )
export sub_ES256_token=$(<../identities/customer-ES256.jws)

export valid_RS256_tokens="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${agent_RS256_token}\",\"app-token\":\"${app_RS256_token}\",\"subject-token\":\"${sub_RS256_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"
export valid_ES256_tokens="{ \"input\": { \"attributes\":{\"destination\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":80},\"address\":\"172.24.0.7\"}}}},\"metadata_context\":{},\"request\":{\"http\":{\"headers\":{\":authority\":\"localhost:8080\",\":method\":\"GET\",\":path\":\"/anything\",\"accept\":\"*/*\",\"accept-encoding\":\"gzip, deflate, br\",\"actor-token\":\"${agent_ES256_token}\",\"app-token\":\"${app_ES256_token}\",\"subject-token\":\"${sub_ES256_token}\"},\"host\":\"localhost:8080\",\"id\":\"17101214017089129208\",\"method\":\"GET\",\"path\":\"/anything\",\"protocol\":\"HTTP/1.1\"},\"time\":{\"nanos\":355966000,\"seconds\":1597712837}},\"source\":{\"address\":{\"Address\":{\"SocketAddress\":{\"PortSpecifier\":{\"PortValue\":41700},\"address\":\"172.24.0.1\"}}}}},\"parsed_body\":null,\"parsed_path\":[\"anything\"],\"parsed_query\":{}}}"

export missing_tokens='{ "input": {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.24.0.7"}}}},"metadata_context":{},"request":{"http":{"headers":{":authority":"localhost:8080",":method":"GET",":path":"/anything","accept":"*/*","accept-encoding":"gzip, deflate, br","authorization":"Ignored"},"host":"localhost:8080","id":"17101214017089129208","method":"GET","path":"/anything","protocol":"HTTP/1.1"},"time":{"nanos":355966000,"seconds":1597712837}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":41700},"address":"172.24.0.1"}}}}},"parsed_body":null,"parsed_path":["anything"],"parsed_query":{}}}'

export corrupt_ES256_tokens='{ "input": {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.24.0.7"}}}},"metadata_context":{},"request":{"http":{"headers":{":authority":"localhost:8080",":method":"GET",":path":"/anything","accept":"*/*","accept-encoding":"gzip, deflate, br","actor-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6Indvcmtmb3JjZUlEUC1FUzI1NiJ9.ewog.BelPJ0lBnn5RaW1GwaIXWLPeDCk5vXXFna2rwyzze5549JlYIcXc7q2SKqK22hVFWFcJxpqHjCfDpbfCypLrpA","actor-token-type":"urn:ietf:params:oauth:token-type:identity_token","app-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6IkFQSUdXLUVTMjU2In0.ewog.q2ES4cOOFSJMBgHGGnZfx6sNQk8UJ21Oejq1_99EVjIvAVZen3ZuN9HWaJjX8VsVjuYPg2pR2OjDk9tQhdI0Qg","authorization":"Ignored- whatever parallel authorization mechanism  is fine","cache-control":"no-cache","created":"2020-08-17T22:11:09.587Z","digest":"e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855","postman-token":"ea556c73-d8ab-49b7-936c-e2d6f8ce6948","session-id":"2f98eb6b-e7e0-4e96-87e6-1949f5296631","signature":"customSig=JWS","subject-token":"eyJhbGciOiJFUzI1NiIsImtpZCI6ImN1c3RJRFAtRVMyNTYifQ.ewog.nUztCfQuRZoknUp2_IkefNqUDyVf6HIaJv6hHkLaRv5cX237Kas_W_gWxLIuuhtyZzus4nz92YqdwG93ZfhSFA","subject-token-type":"urn:ietf:params:oauth:token-type:identity_token","user-agent":"PostmanRuntime/7.24.1","x-forwarded-proto":"http","x-request-id":"16590c0f-e715-4724-9af2-231f01da5704"},"host":"localhost:8080","id":"17101214017089129208","method":"GET","path":"/anything","protocol":"HTTP/1.1"},"time":{"nanos":355966000,"seconds":1597712837}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":41700},"address":"172.24.0.1"}}}}},"parsed_body":null,"parsed_path":["anything"],"parsed_query":{}}}'
export corrupt_RS256_tokens='{ "input": {"attributes":{"destination":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":80},"address":"172.24.0.7"}}}},"metadata_context":{},"request":{"http":{"headers":{":authority":"localhost:8080",":method":"GET",":path":"/anything","accept":"*/*","accept-encoding":"gzip, deflate, br","actor-token":"eyJhbGciOiJSUzI1NiIsImtpZCI6Indvcmtmb3JjZUlEUC1SUzI1NiJ9.www.KH1eJ3QK2uAPuRoWovlEPNJTHlw4FQKn4fAIuBp_AxaQokoqp9XrsaCECFrp_R_MblY6qQnC8WxMdqPpT0u473vKP-3hBXBgC69p3W9CD-U0Nd_X9mFHNtEm9JXGCTvbp6NY8xMRaeyjijw6o43WDlQFvPOv5yW25dxRvbuYHxcmsRssHmGY3-bESQHS18Nbd5eSeviuZ2A84enyJRih1W5ZuyOlpjcxDqZqgKFWbrhcZivRoXQfxxyX2IuAif_AGr2YFXkZQ0-kekJdEmrmQ6rxXdDryMjD4eL61iJj9hqOldAioq2wpvJxLCWDPLLrmpmtYkYr9XzxZiw0Rwwk9A","app-token":"eyJhbGciOiJSUzI1NiIsImtpZCI6IkFQSUdXLVJTMjU2In0.www.SvHTr8fGCzMSo4Uktw_WqeJGVv9M_--qRPrBiBTz0eJtc21whf32-TcVRBY9i4DS400iGNkMaaeIP15BEmgZ42olS27ngBXB-j_fw7i7hTRBEPS01snwE2uxBiPX-NLmQd8d5LDfTM69lK_cl3vhgMaM6xHDUeTNAftEnCqhSc1lk5leiOYaMiRFA2IsrF1ebyS7MpRtIszauyPE5Yo6j20YCIseoO5ULZj4X715DB2TeCZNTTLTadm-lRFig3EsgJRxNApIMMdN3wyb7qRPi4LXcwj2S91DHuA5AsOy4yd-dnf-OXsTXCB54lKVnPsynL1sxrgWimUSEFmAwS75sA","subject-token":"eyJhbGciOiJSUzI1NiIsImtpZCI6ImN1c3RJRFAtUlMyNTYifQ.www.iwb5jb5umv4dv8FHH7MGfdLCTKUcZg_J4svPY5ejm8rB-QXKLzP2RWE_VcbSfa3hK8fNPSjj9WyFCv3hozYlppw7PAEZeyeYf6Rh2S6LmWJj2FDMHvI8chjCz2ZdE3JQO_CqPDp_Ok1i6EkBE4-OfZycT7c3-CeQMWXagtmEH5FCJTxM2x_m3xuzbn2NhHdUlhMTAdReh3_Cmr-63ECfDOg_ctRqHZAxzIKPnu0EEJTWBBFZdG7w8q1LaaQcn0FNleaBUL5gXlCBI2yoRtVVZQ3CAmLwKdWQ8iXZOOiYFbuszXXJLgscxM23ufr2AcUKFm4DgxjSUy1YptsQlZy3mQ"},"host":"localhost:8080","id":"17101214017089129208","method":"GET","path":"/anything","protocol":"HTTP/1.1"},"time":{"nanos":355966000,"seconds":1597712837}},"source":{"address":{"Address":{"SocketAddress":{"PortSpecifier":{"PortValue":41700},"address":"172.24.0.1"}}}}},"parsed_body":null,"parsed_path":["anything"],"parsed_query":{}}}'


printf "******* Test valid RS256 jws Tokens (SHOULD SUCCEED) ******* \n\n"

#curl -v --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true&explain=full' \

curl --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header 'Content-Type: text/plain' \
--data-raw "${valid_RS256_tokens}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "******* Test valid ES256 jws Tokens (SHOULD SUCCEED) ******* \n\n"

#curl -v --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true&explain=full' \

curl --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header 'Content-Type: text/plain' \
--data-raw "${valid_ES256_tokens}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "******* Test missing jws Tokens (SHOULD FAIL)******* \n\n"

#curl -v --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true&explain=full' \
curl --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header 'Content-Type: text/plain' \
--data-raw "${missing_tokens}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "******* Test corrupt ES256 jws Tokens (SHOULD FAIL)******* \n\n"

#curl -v --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true&explain=full' \
curl --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header 'Content-Type: text/plain' \
--data-raw "${corrupt_ES256_tokens}"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "******* Test corrupt RS256 jws Tokens (SHOULD FAIL)******* \n\n"

#curl -v --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true&explain=full' \
curl --location --request POST 'http://localhost:8181/v1/data/istio/authz/allow?pretty=true' \
--header 'Content-Type: application/json' \
--header 'Accept: application/json' \
--header 'Content-Type: text/plain' \
--data-raw "${corrupt_RS256_tokens}"
