#!/bin/bash

printf "\n\nThis script depends on jose-util.\n"
printf " To install jose-util execute: go get -u github.com/square/go-jose/jose-util\n"
printf "                     then run: go install github.com/square/go-jose/jose-util\n"
printf " and make sure your go install directory is in your path \n\n"

printf "    About to sign and verify identity tokens. \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

printf "    Signing and verifying workforce identity tokens. \n\n"
jose-util sign   --key ../keys/jwk-sig-workforceIDP-ES256-priv.json --alg ES256 --in agent.json > agent-ES256.jws
jose-util verify --key ../keys/jwk-sig-workforceIDP-ES256-pub.json  --in agent-ES256.jws

jose-util sign   --key ../keys/jwk-sig-workforceIDP-RS256-priv.json --alg RS256 --in agent.json > agent-RS256.jws
jose-util verify --key ../keys/jwk-sig-workforceIDP-RS256-pub.json  --in agent-RS256.jws

printf "\n\n    Signing and verifying customer identity token. \n\n"
jose-util sign   --key ../keys/jwk-sig-custIDP-ES256-priv.json --alg ES256 --in customer.json > customer-ES256.jws
jose-util verify --key ../keys/jwk-sig-custIDP-ES256-pub.json  --in customer-ES256.jws

jose-util sign   --key ../keys/jwk-sig-custIDP-RS256-priv.json --alg RS256 --in customer.json > customer-RS256.jws
jose-util verify --key ../keys/jwk-sig-custIDP-RS256-pub.json  --in customer-RS256.jws

printf "\n\n    Signing and verifying client application identity token. \n\n"
jose-util sign   --key ../keys/jwk-sig-APIGW-ES256-priv.json --alg ES256 --in app-details.json > app-details-ES256.jws
jose-util verify --key ../keys/jwk-sig-APIGW-ES256-pub.json  --in app-details-ES256.jws

jose-util sign   --key ../keys/jwk-sig-APIGW-RS256-priv.json --alg RS256 --in app-details.json > app-details-RS256.jws
jose-util verify --key ../keys/jwk-sig-APIGW-RS256-pub.json  --in app-details-RS256.jws
printf "\n\n\n\n"
