#!/bin/bash

printf "\n\n    This script starts an Envoy Server via docker compose and demonstrates:\n"
printf "       * The use of Envoy JWS authorization policies\n"
printf "       * Using OPA and API contract reference data to determine if a Client App is allowed to access an API.\n"
printf "       * Using OPA and Identity token Issuer data to determine if a Client App is being used by the correct user type.\n"
printf "\n\n**************    About to start envoy via docker-compose   **************\n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

docker-compose up -d --build

read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n\n**************    About to check to make sure everything is started    **************\n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n'

docker ps -a

read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n******* About to execute all of the Statically defined newman test cases for app_000123 which has should be allowed on all endpoints  ******* \n\n"
printf "    The request will go to envoy. Evoy validates that the JWS tokens are valid. Envoy the forwards the request to Open Policy Agent (OPA).\n"
printf "    OPA takes tokens out of the headers and validates the Client is authorized for the endpoint and the type of use is valid for the app.\n"
printf "    Envoy uses the decision from OPA to determine if it forwards the request to HOVERFLY Mocks or not.\n\n"
printf "    ---> newman run     /data/Envoy_OPA.postman_collection.json\n                        --folder Static-Test-Cases \n\n"
read -n 1 -r -s -p $'\n\nPress enter to continue...\n'
printf "\n......Executing\n"

docker run --rm -t --network=host -v "${PWD}/data":/data \
        postman/newman run /data/Envoy_OPA.postman_collection.json \
            --folder Static-Test-Cases 

read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n******* About to execute all of the iteration data based tests for both app_123456 and app_000123 on endpoints with GET methods ******* \n\n"
printf "    The request will go to envoy. Evoy validates that the JWS tokens are valid. Envoy the forwards the request to Open Policy Agent (OPA).\n"
printf "    OPA takes tokens out of the headers and validates the Client is authorized for the endpoint and the type of use is valid for the app.\n"
printf "    Envoy uses the decision from OPA to determine if it forwards the request to HOVERFLY Mocks or not.\n\n"
printf "    ---> newman run     /data/Envoy_OPA.postman_collection.json\n                        --folder run_get_request_tests_from_data_file_with_2_apps\n                        --iteration-data /data/get_tests.json \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n......Executing\n"

docker run --rm -t --network=host -v "${PWD}/data":/data \
        postman/newman run /data/Envoy_OPA.postman_collection.json \
            --folder run_get_request_tests_from_data_file_with_2_apps \
            --iteration-data /data/get_tests.json

read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n******* About to execute all of the iteration data based tests for both app_123456 and app_000123 on endpoints with POST methods ******* \n\n"
printf "    The request will go to envoy. Evoy validates that the JWS tokens are valid. Envoy the forwards the request to Open Policy Agent (OPA).\n"
printf "    OPA takes tokens out of the headers and validates the Client is authorized for the endpoint and the type of use is valid for the app.\n"
printf "    Envoy uses the decision from OPA to determine if it forwards the request to HOVERFLY Mocks or not.\n\n"
printf "    ---> newman run     /data/Envoy_OPA.postman_collection.json\n                        --folder run_post_request_tests_from_data_file_with_2_apps\n                        --iteration-data /data/post_tests.json \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n......Executing\n"

docker run --rm -t --network=host -v "${PWD}/data":/data \
        postman/newman run /data/Envoy_OPA.postman_collection.json \
            --folder run_post_request_tests_from_data_file_with_2_apps \
            --iteration-data /data/post_tests.json

read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n******* About to execute all of the iteration data based tests for both app_123456 and app_000123 on endpoints with PUT methods ******* \n\n"
printf "    The request will go to envoy. Evoy validates that the JWS tokens are valid. Envoy the forwards the request to Open Policy Agent (OPA).\n"
printf "    OPA takes tokens out of the headers and validates the Client is authorized for the endpoint and the type of use is valid for the app.\n"
printf "    Envoy uses the decision from OPA to determine if it forwards the request to HOVERFLY Mocks or not.\n\n"
printf "    ---> newman run     /data/Envoy_OPA.postman_collection.json\n                        --folder run_put_request_tests_from_data_file_with_2_apps\n                        --iteration-data /data/put_tests.json \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n......Executing\n"

docker run --rm -t --network=host -v "${PWD}/data":/data \
        postman/newman run /data/Envoy_OPA.postman_collection.json \
            --folder run_put_request_tests_from_data_file_with_2_apps \
            --iteration-data /data/put_tests.json

read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n******* About to execute all of the iteration data based tests for both app_123456 and app_000123 on endpoints with DELETE methods ******* \n\n"
printf "    The request will go to envoy. Evoy validates that the JWS tokens are valid. Envoy the forwards the request to Open Policy Agent (OPA).\n"
printf "    OPA takes tokens out of the headers and validates the Client is authorized for the endpoint and the type of use is valid for the app.\n"
printf "    Envoy uses the decision from OPA to determine if it forwards the request to HOVERFLY Mocks or not.\n\n"
printf "    ---> newman run     /data/Envoy_OPA.postman_collection.json\n                        --folder run_delete_request_tests_from_data_file_with_2_apps\n                        --iteration-data /data/delete_tests.json \n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n......Executing\n"

docker run --rm -t --network=host -v "${PWD}/data":/data \
        postman/newman run /data/Envoy_OPA.postman_collection.json \
            --folder run_delete_request_tests_from_data_file_with_2_apps \
            --iteration-data /data/delete_tests.json
            
read -n 1 -r -s -p $'\nPress enter to continue...\n'
printf "\n\n**************    About to clean up and remove docker instances    **************\n\n"
read -n 1 -r -s -p $'\nPress enter to continue...\n'
docker-compose down

printf "\n......Complete\n"
