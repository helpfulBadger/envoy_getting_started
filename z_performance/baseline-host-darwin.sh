#!/bin/bash

printf "\n\n    This script starts a fastMocks server on the host for baselining throughput and latency \n"
printf "\n\n**************    About to start fastMocks   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

cd fastMocks/ && ./fastMocks_darwin -cf mock_api_data.json &


read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to show background jobs  ******* \n\n"
printf "    The fastMock server is in the background and can be seen with the jobs command.\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

printf "\n\n************** \n"
ps -eaf | grep -i fastmocks | grep -i -v grep 
printf "\n\n************** \n\n"
jobs

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
./wrk_darwin -t 4 -c100 -d30s --latency http://localhost:8000/api/customer  > results/api-customer-host-baseline-wrk_d.txt
printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to benchmark throughput and latency with WRK2  ******* \n\n"
printf "    WRK2 is a variant of WRK that has a constant throughput option. This is simply to show the baseline for this tool if we use constant load later.\n"
printf "    This will run a 30 second benchmark and save the output to results/api-customer-host-baseline-wrk2.txt\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "    Running load test.....\n"
./wrk_darwin -t 4 -c100 -d30s --latency http://localhost:8000/api/customer  > results/api-customer-host-baseline-wrk2_d.txt
printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to benchmark throughput and latency with Hey  ******* \n\n"
printf "    Hey is a golang based load testing tool that typically scales better than workloads and therefore does not affect the measurement \n"
printf "    as much as other tools. This will run a 30 second benchmark and save the output to results/api-customer-host-baseline-hey.txt\n"
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "    Running load test.....\n"
./hey_darwin -z 30s -c 75              'http://localhost:8000/api/customer' > results/api-customer-host-baseline-hey_d.txt
printf "    Finished!!!!\n"

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n******* About to stop the fastMock server  ******* \n\n"
ps -eaf | grep -i fastmocks | grep -i -v grep 

printf "    The 2nd column above contains the process ID for the fastMock Server. \n\nType the process ID and hit enter to stop it. \n"
read fastMockPID

kill ${fastMockPID}
ps -eaf | grep -i fastmocks | grep -i -v grep 
