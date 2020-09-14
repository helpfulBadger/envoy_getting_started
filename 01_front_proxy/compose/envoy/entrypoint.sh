#!/bin/sh

printf "\n\n***** Environment Variables ---> debug level: ${DEBUG_LEVEL}, name: ${SERVICE_NAME}, port: ${SERVICE_PORT} *****\n\n"

sed -e "s/\${SERVICE_NAME}/${SERVICE_NAME}/" -e "s/\${SERVICE_PORT}/${SERVICE_PORT}/" /config/envoy.yaml > /etc/envoy.yaml

printf "\n\n***** Dumping source config file /config/envoy.yaml *****\n\n"
cat /config/envoy.yaml

printf "\n\n***** Dumping final config file /etc/envoy.yaml *****\n\n"
cat /etc/envoy.yaml

/usr/local/bin/envoy -c /etc/envoy.yaml -l ${DEBUG_LEVEL}
