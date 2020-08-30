#!/bin/bash
printf "\n\n**************************************\nThis script starts a fastMocks server on inside docker to compare to the baseline\n**************************************\n"

if [ "$1" == "nobuild" ]; then
    printf "...skipping build \n"
else
    docker build -t local-fastmocks fastMocks
fi

printf "\n\n**************    About to start fastMocks   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker run -d -p 8000:8000 --name fastMocks    local-fastmocks
printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to test the endpoint with curl  ******* \n\n"
printf "    This will test the endpoint to determine if everything is working correctly.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
curl -v http://localhost:8000/api/customer

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to benchmark throughput and latency with WRK  ******* \n\n"
printf "    WRK is a very high throughput load testing tool that typically scales better than workloads and therefore does not affect the measurement \n"
printf "    as much as other tools. This will run a 30 second benchmark and save the output to results/api-customer-host-baseline-wrk.txt\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "    Running load test.....\n"
./wrk_darwin -t 4 -c100 -d30s --latency http://localhost:8000/api/customer  > results/api-customer-docker-wrk.txt
printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to benchmark throughput and latency with WRK2  ******* \n\n"
printf "    WRK2 is a variant of WRK that has a constant throughput option. This is simply to show the baseline for this tool if we use constant load later.\n"
printf "    This will run a 30 second benchmark and save the output to results/api-customer-host-baseline-wrk2.txt\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "    Running load test.....\n"
./wrk_darwin -t 4 -c100 -d30s --latency http://localhost:8000/api/customer  > results/api-customer-docker-wrk2.txt
printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to benchmark throughput and latency with Hey  ******* \n\n"
printf "    Hey is a golang based load testing tool that typically scales better than workloads and therefore does not affect the measurement \n"
printf "    as much as other tools. This will run a 30 second benchmark and save the output to results/api-customer-host-baseline-hey.txt\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "    Running load test.....\n"
./hey_darwin -z 30s -c 75              'http://localhost:8000/api/customer' > results/api-customer-docker-hey.txt
printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to stop the fastMock server  ******* \n\n"
docker stop fastMocks
docker rm fastMocks
