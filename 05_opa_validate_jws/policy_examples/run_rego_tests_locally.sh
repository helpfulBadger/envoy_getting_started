#!/bin/bash

printf "\n\nThis script depends on opa being installed on your system.\n"
printf " To install opa execute:\n"
printf "        Mac OSX:    curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_darwin_amd64\n"
printf "        Linux  :    curl -L -o opa https://openpolicyagent.org/downloads/latest/opa_linux_amd64\n"
printf "        Then   :    chmod 755 ./opa\n"
printf " and make sure OPA is in your path \n\n"

printf "    To run OPA tests just create a rego test file and run opa test . -v \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

opa test . -v
