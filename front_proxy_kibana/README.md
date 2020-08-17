# Basic Envoy front proxy using docker-compose

This example simply proxies requests from the host machine to an HTTPBIN container running inside docker with no ports exposed on the host.

## Usage

Run `docker-compose up -d` to start services.

Environment variables `SERVICE_NAME` and `SERVICE_PORT` refers to the service Envoy is proxying. These env variables will replace the variables in `envoy.yaml`. See `./compose/envoy/entrypoint.sh` for more details.
