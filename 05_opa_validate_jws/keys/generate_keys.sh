#!/bin/bash

printf "\n\nThis script depends on jose-util.\n"
printf " To install jose-util execute: go get -u github.com/square/go-jose/jose-util\n"
printf "                     then run: go install github.com/square/go-jose/jose-util\n"
printf " and make sure your go install directory is in your path \n\n"

printf "    About to generate JWK encryption keys. \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

printf "    Generating customer identity provider encryption key. \n\n"
jose-util generate-key --use sig --alg ES256 --kid custIDP-ES256

printf "    Generating workforce identity provider encryption key. \n\n"
jose-util generate-key --use sig --alg ES256 --kid workforceIDP-ES256

printf "    Generating system account identity provider encryption key. \n\n"
jose-util generate-key --use sig --alg ES256 --kid APIGW-ES256

