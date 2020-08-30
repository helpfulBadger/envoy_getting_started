#!/bin/bash
docker build -t local-fastMocks .

docker run -d -rm -p 8000:8000 --name fastMocks    local-fastMocks
docker cp fastmocks:/go/bin/fastMocks_linux .
docker cp fastmocks:/go/bin/fastMocks_darwin .

docker stop fastMocks
