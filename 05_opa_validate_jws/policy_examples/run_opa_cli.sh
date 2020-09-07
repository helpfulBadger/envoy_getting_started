#!/bin/bash

printf "\n\nThis script depends on opa being installed on your system.\n"
printf " To install opa execute:\n"
printf "        Mac OSX:    curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_darwin_amd64\n"
printf "        Linux  :    curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64\n"
printf "        Then   :    chmod 755 ./opa\n"
printf " and make sure OPA is in your path \n\n"

printf "    About to show how to verify jws identity tokens. \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

printf "    This example shows the use of 3 different JWS token functions: \n\n"
printf "                 io.jwt.verify_es256(es256_token, jwks) \n\n"
printf "                 io.jwt.decode(es256_token) \n\n"
printf '                 io.jwt.decode_verify(es256_token, { "cert": jwks, "iss": "xxx", }) \n\n'
printf "    This example uses jws_examples_v1.rego \n\n"

read -n 1 -r -s -p $'Press enter to continue...\n'

opa eval -d jws_examples_v1.rego 'data.jws.examples.v1.result'


printf "*************************************************************************************************************\n\n"
printf "    This next example shows extraction of 3 different JWS tokens for http headers and all of them are valid. \n\n"
printf "    This example uses policy.rego which uses io.jwt.decode_verify() for validating all tokens.\n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test valid ES256 jws Tokens (SHOULD SUCCEED) ******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

opa eval -i allowed-ES256/input.json -d policy.rego 'data.envoy.authz.allow'

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test valid RS256 jws Tokens (SHOULD SUCCEED) ******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

opa eval -i allowed-RS256/input.json -d policy.rego 'data.envoy.authz.allow'

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test corrupt ES256 jws Tokens (SHOULD FAIL)******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

opa eval -i corrupt-ES256/input.json -d policy.rego 'data.envoy.authz.allow'

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test corrupt RS256 jws Tokens (SHOULD FAIL)******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

opa eval -i corrupt-RS256/input.json -d policy.rego 'data.envoy.authz.allow'

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Test missing jws Tokens (SHOULD FAIL)******* \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

opa eval -i missing/input.json -d policy.rego 'data.envoy.authz.allow'

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Testing with a single tampered jws Tokens (SHOULD FAIL)******* \n\n"
printf "          Agent-Authenticated    should = false\n"
printf "          App-Authenticated      should = true\n"
printf "          Customer-Authenticated should = true\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

opa eval -i tampered-token/input.json -d policy.rego 'data.envoy.authz.allow'

read -n 1 -r -s -p $'\nPress enter to continue...\n\n'
printf "******* Testing with 2 tampered jws Tokens (SHOULD FAIL)******* \n\n"
printf "          Agent-Authenticated    should = true\n"
printf "          App-Authenticated      should = false\n"
printf "          Customer-Authenticated should = false\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n\n'

opa eval -i tampered-tokens/input.json -d policy.rego 'data.envoy.authz.allow'
