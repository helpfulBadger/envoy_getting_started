#!/bin/bash
docker build -t local-fastMocks .

docker run -d -p 8000:8000 --name fastMocks    local-fastMocks
docker cp fastmocks:/go/bin/fastMocks_linux .
docker cp fastmocks:/go/bin/fastMocks_darwin .



docker ps

printf "\n\n**************************************\nTesting Default API configuration Endpoints\n**************************************\n"
# curl http://localhost:8000/
curl http://localhost:8000/api/api_1
curl http://localhost:8000/api/api_2
curl http://localhost:8000/api/person/myname
printf "\n   ***** showing container logs ***** \n"
docker logs local-mock
printf "\n\n**************************************\nTesting Server 1 API configuration Endpoints\n**************************************\n"
# curl http://localhost:8001/
curl http://localhost:8001/server/1/api/1
curl http://localhost:8001/server/1/api/2
curl http://localhost:8001/server/1/api/person/myname
printf "\n   ***** showing container logs ***** \n"
docker logs local-mock-s1
printf "\n\n**************************************\nTesting Server 2 API configuration Endpoints\n**************************************\n"
# curl http://localhost:8002/
curl http://localhost:8002/server/2/api/1
curl http://localhost:8002/server/2/api/2
curl http://localhost:8002/server/2/api/person/myname
printf "\n   ***** showing container logs ***** \n"
docker logs local-mock-s2
printf "\n\n**************************************\nTesting Default API configuration Endpoints with request logging\n**************************************\n"
# curl http://localhost:8003/
curl http://localhost:8003/api/api_1
curl http://localhost:8003/api/api_2
curl http://localhost:8003/api/person/myname
printf "\n   ***** showing container logs ***** \n"
docker logs local-mock-w-log
printf "\n\n**************************************\nTesting Server 1 API configuration Endpoints with request logging\n**************************************\n"
# curl http://localhost:8004/
curl http://localhost:8004/server/1/api/1
curl http://localhost:8004/server/1/api/2
curl http://localhost:8004/server/1/api/person/myname
printf "\n   ***** showing container logs ***** \n"
docker logs local-mock-s1-w-log
printf "\n\n**************************************\nTesting Server 2 API configuration Endpoints with request logging\n**************************************\n"
# curl http://localhost:8005/
curl http://localhost:8005/server/2/api/1
curl http://localhost:8005/server/2/api/2
curl http://localhost:8005/server/2/api/person/myname
printf "\n   ***** showing container logs ***** \n"
docker logs local-mock-s2-w-log
