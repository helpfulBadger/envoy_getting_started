#!/bin/bash

printf "\n\nThis script depends on opa being installed on your system.\n"
printf " To install opa execute:\n"
printf "        Mac OSX:    curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_darwin_amd64\n"
printf "        Linux  :    curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64\n"
printf "        Then   :    chmod 755 ./opa\n"
printf " and make sure OPA is in your path \n\n"

printf "    The opa eval command is useful for iteratively developing your rego rules while also perfecting your input payload. \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

opa eval -i allowed_input.json -d policy.rego 'data.istio.authz.allow'
