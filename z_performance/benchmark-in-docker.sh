#!/bin/bash
printf "\n\n**************************************\nThis script starts a fastMocks server in docker with the load generators also inside docker to compare to the baseline\n**************************************\n"

printf "\n\n**************    About to start fastMocks and load generators   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose -f compose/docker-compose_mocks.yml up -d

printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to test the endpoint with curl  ******* \n\n"
printf "    This will test the endpoint to determine if everything is working correctly.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
curl -v http://localhost:8000/api/customer

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to benchmark throughput and latency with WRK  ******* \n\n"
printf "    WRK is a very high throughput load testing tool that typically scales better than workloads and therefore does not affect the measurement \n"
printf "    as much as other tools. This will run a 30 second benchmark and save the output to results/api-customer-wrk-in-docker.txt\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "    Running load test.....\n"

docker exec compose_wrk_1 /wrk_linux -t 4 -c100 -d30s --latency http://mock:8000/api/customer > results/api-customer-wrk-in-docker.txt

printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to benchmark throughput and latency with WRK2  ******* \n\n"
printf "    WRK2 is a variant of WRK that has a constant throughput option. This is simply to show the baseline for this tool if we use constant load later.\n"
printf "    This will run a 30 second benchmark and save the output to results/api-customer-wrk2-in-docker.txt\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "    Running load test.....\n"

##docker exec compose_wrk2_1 /wrk2_linux -t 4 -c100 -d30s --latency http://mock:8000/api/customer > results/api-customer-wrk2-in-docker.txt
docker exec compose_wrk2_1  /wrk2_linux -t 4 -c100 -d15s -R 29500 http://mock:8000/api/customer > results/api-customer-wrk2-in-docker.txt

printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to benchmark throughput and latency with Hey  ******* \n\n"
printf "    Hey is a golang based load testing tool that typically scales better than workloads and therefore does not affect the measurement \n"
printf "    as much as other tools. This will run a 30 second benchmark and save the output to results/api-customer-hey-in-docker.txt\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "    Running load test.....\n"

docker exec compose_hey_1 /hey_linux -z 30s -c 75              'http://mock:8000/api/customer' > results/api-customer-hey-in-docker.txt

printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to stop the fastMock server and load generators  ******* \n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose -f compose/docker-compose_mocks.yml down 
