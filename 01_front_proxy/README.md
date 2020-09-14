# Using Envoy as a Front Proxy

## Overview

[Envoy](https://www.envoyproxy.io/) is an open source edge and service proxy that has become extremely popular as the backbone underneath most of the leading service mesh products (both open source and commercial). This article is intended to demystify it a bit and help people understand how to use it on it's own in a minimalist fashion. 

Envoy is just like any other proxy. It receives requests and forwards them to services that are located behind it. The 2 ways to deploy Envoy are:
1. Front Proxy - In a front proxy deployment Envoy is very similar to NGINX, HAProxy, or an Apache web server. The Envoy server has it's own IP address and is a separate server on the network from the services that it protects. Traffic comes in and get forwarded to a number of different services that are located behind it. Envoy supports a variety of methods for making routing decisions. 
    * One mechanism is to use path based routing to determine the service of interest. For instance a request coming in as: `/service1/some/other/stuff` can use the first uri path element as a routing key. `service1` can be used to route requests to service 1. Additionally, `service2` in `/service2/my/applications/path` can be used to route the request to a set of servers that support service 2. The path can be rewritten as it goes through Envoy to trim off the service routing prefix.
    * Another mechanism is to use Server Name Indication (SNI) which is a TLS extension to determine where to forward a request. Using this technique, `service1.com/some/other/stuff` would use the server name to route to the `service1` services. Additionally, `service2.com/my/applications/path` would use service2.com to route the request to `service2`.
    <img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/Envoy-front%20proxy-front-proxy.svg" /><br>
    The diagram above shows the front proxy approach. 

1. Sidecar Proxy - In a sidecar deployment, the Envoy server is located at the same IP address as each service that it protects. The Envoy server when deployed as as sidecar only has a single service instance behind it. The sidecar approach can intercept all inbound traffic and optionally all outbound traffic on behalf of the service instance. [IP Tables](https://en.wikipedia.org/wiki/Iptables) rules are typically used to configure the operating system to capture and redirect this traffic to Envoy. <img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/Envoy-front%20proxy-sidecar.svg" /><br>
    The diagram above shows the sidecar approach.

In this article and example project we will start with the simplest possible Envoy deployment. This example just uses docker compose to show how to get Envoy up and running. There will be a number of subsequent articles that expand on this simple approach to demostrate more Envoy capabilies. Open Policy Agent will also be introduced to handle more complex authorization use cases that cannot be handled by Envoy alone. 

The diagram below shows the environment that we are about to build and deploy locally. 

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/Envoy-front%20proxy-envoy_in_docker.svg" />

## Building an Envoy Front Proxy
_Note: The [code for the complete working example](https://github.com/helpfulBadger/envoy_getting_started/tree/master/01_front_proxy) can be found on Github._

If you don't have docker installed, do it now. You can find details (https://docs.docker.com/get-started/)
You can validate docker is installed correctly 

```
$ docker --version 
Docker version 19.03.12, build 48a66213fe 
```

### Set Up Dockerfile Using Envoy Image
Next we will make a dockerfile build on an  Envoy docker image. The Envoy images are located on [Dockerhub](https://hub.docker.com/r/envoyproxy/envoy/tags). We will use `docker-compose` to build some configurability into our Envoy environment. 

### Dockerfile
``` Dockerfile
FROM envoyproxy/envoy:v1.15-latest

COPY entrypoint.sh /
RUN chmod 500 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
```


### Set Up entrypoint.sh file 
The dockerfile references 'entrypoint.sh', a file we have not created yet. This bash file will configure environment variables in our docker-compose file to determine which service (`SERVICE_NAME`) our Envoy proxy routes to and the port (`SERVICE_PORT`) on that service. (We haven't set up our service yet) 

Additionally, we specify how much detail is captured in the logs by setting the `DEBUG_LEVEL` environment variable. As you can see from the script below on line 3, we replace those environment variables on the fly in Envoy's configuration file before starting Envoy.

Using vscode (you can you whatever editor you like) crete and edit and he entrypoint.sh file
code  `entrypoint.sh`  

### entrypoint.sh

```bash 
#!/bin/sh

sed -e "s/\${SERVICE_NAME}/${SERVICE_NAME}/" -e "s/\${SERVICE_PORT}/${SERVICE_PORT}/" /config/envoy.yaml > /etc/envoy.yaml

/usr/local/bin/envoy -c /etc/envoy.yaml -l ${DEBUG_LEVEL}
```

### Set Up Envoy Config (envoy.yaml) file
The above script references a envoy configuration file 'envoy.yaml'. Lets set that up now. 

Envoy is very flexible and powerful. There is an enormous amount of expressiveness that the Envoy API and configuration files support. With this flexibility and power, Envoy configuration files can become quite complicated with a lot layers in the YAML hierarchy. Additionally, each feature has a lot of configuration parameters. The documentation can only cover so much of that functionality with an open source community of volunteers. 


---
**NOTE**

_One of the challenges that I have when reading through the documentation and trying to apply it, is that the documentation has a variety of YAML snippets. There are very few places that these YAML snippets are pulled together into a functioning example. There are a few examples in the source code examples directory but they are far from comprehensive. That leaves a lot of tinkering for engineers to figure out how to compose a functional configuration while interpreting sometimes unclear error messages on their way to the promised land. That is the entire reason that I am writing a series of getting started guides. These articles are intended to give folks a known to work starting point for Envoy authorization features and extensions like Open Policy Agent._

---


**Define Listener**
The Envoy configuration starts with defining a listener as we can see starting on line 3 below. The first property is the address and port to accept traffic on (lines 3 through 6). The next property is a filter chain. Filter chains are very powerful and enable configuration for a wide variety of possible behaviors.
```yaml 
static_resources:
  listeners:
  ...
      filter_chains:
      ...
  ```

 This filter chain is as simple as it gets. It simply accepts any HTTP traffic with any URI pattern and routes it to the cluster named `service`. The `http_connection_manager` component starts on line 9 and extends to line 24. Execution order is determined by the order they are listed in the configuration file. The important part for this discussion begins on line 14 with the `route_config`. This sets up routing requests for any domain (line 18) and any request URI that begins with a slash (line 20) to go to the cluster named `service`. 

### full envoy.yaml file
```yaml
 filter_chains:
          - filters:
            - name: envoy.filters.network.http_connection_manager
              typed_config:
                "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
                codec_type: auto
                stat_prefix: ingress_http
                route_config:
                  name: local_route
                  virtual_hosts:
                    - name: backend
                      domains: ["*"]
                      routes:
                        - match: { prefix: "/" }
                          route: { cluster: service }
                http_filters:
                  - name: envoy.filters.http.router
                    typed_config: {}
```

 The cluster definitions are in a separate section to make them reusable destination across a variety of rules. The definitions begin on line 25. We can see that there is only a single cluster defined. It has the name `service`, uses DNS to find server instances and uses round robin to direct traffic across multiple instances. The hostname is on line 32 and the port is on line 33. As we can see these are the environment variables that we will swap out with the entry.sh script. 

```yaml
 clusters:
    - name: service
      connect_timeout: 0.25s
      type: STRICT_DNS
      lb_policy: round_robin
      load_assignment:
        cluster_name: service
        endpoints:
        - lb_endpoints:
          - endpoint:
              address:
                socket_address:
                  address: ${SERVICE_NAME}
                  port_value: ${SERVICE_PORT}
```


The last section of the configuration file tells Envoy where to listen for admin traffic. The admin gui is a handy little tool that we will not cover in this guide but is definitely worth poking around in to observe what is going on inside an individual Envoy instance. 





### Full Envoy Configuration (envoy.yaml)

```yaml 
static_resources:
  listeners:
    - address:
        socket_address:
          address: 0.0.0.0
          port_value: 80
      filter_chains:
          - filters:
            - name: envoy.filters.network.http_connection_manager
              typed_config:
                "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
                codec_type: auto
                stat_prefix: ingress_http
                route_config:
                  name: local_route
                  virtual_hosts:
                    - name: backend
                      domains: ["*"]
                      routes:
                        - match: { prefix: "/" }
                          route: { cluster: service }
                http_filters:
                  - name: envoy.filters.http.router
                    typed_config: {}
  clusters:
    - name: service
      connect_timeout: 0.25s
      type: STRICT_DNS
      lb_policy: round_robin
      load_assignment:
        cluster_name: service
        endpoints:
        - lb_endpoints:
          - endpoint:
              address:
                socket_address:
                  address: ${SERVICE_NAME}
                  port_value: ${SERVICE_PORT}
admin:
  access_log_path: "/dev/null"
  address:
    socket_address:
      address: 0.0.0.0
      port_value: 8001
```



### Docker Compose Configuration

Now that we understand the Envoy configuration we can move on to understanding the rest of the simple environment that we are setting up. Line 4 shows the trigger that causes docker to build the Envoy container. Docker will only build the Envoy Dockerfile the first time it sees that an image does not exist. If you want to force rebuilding the Envoy container on subsequent runs add the `--build` parameter to your docker compose command.  We expose Envoy to the host network on lines 6 and 7 and provide the configuration file that we just created on line 9. 

``` yaml
version: "3.8"
services:
  envoy:
    build: ./compose/envoy
    ports:
      - "8080:80"
      - "8001:8001"
    volumes:
      - ./envoy.yaml:/config/envoy.yaml
    environment:
      - DEBUG_LEVEL=debug
      - SERVICE_NAME=app
      - SERVICE_PORT=80

  app:
    image: kennethreitz/httpbin:latest
```

The service to route to and port are defined on the environment variables on lines 12 and 13. Notice the name app matches the name of our final service on line 15. We are simply using HTTPBIN to reflect our request back to us. 

## Running and Trying out our Example

The last step to getting our front proxy up is simply running the included script that demonstrates our example. The script explains what it is about to do to ensure you know what are about to see scrolling across your terminal screen. Line 8 starts our environment. Line 14 let's you check to make sure both containers are running before trying to send them a request. 

``` bash
#!/bin/bash

printf "\n\n    This script starts an envoy front proxy and exposes it on localhost:8080.\n"
printf "    Envoy is configured to forward traffic to an httpbin instance that is only exposed inside docker.\n"
printf "\n\n**************    Starting envoy & httpbin via docker-compose   **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose up -d
# if you want to force a rebuild of the envoy container use the --build parameter
# docker-compose up -d --build

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to check to make sure everything is up    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker ps -a
read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to call httpbin via envoy front proxy    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

curl -v --location --request GET 'http://localhost:8080/anything'

read -n 1 -r -s -p $'Press enter to continue...\n'
printf "\n\n**************    About to clean up and remove docker instances    **************\n\n"
read -n 1 -r -s -p $'Press enter to continue...\n'

docker-compose down
```


Line 19 simply calls Envoy with a curl command with the `--verbose` parameter set so that you can see the headers and request details. Then line 25 tears down the whole environment. 

## Containers UP!!!!

If you have successfully started your environment then you should see something like this: 

```
**************    About to check to make sure everything is up    **************

Press enter to continue...
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                                                     NAMES
40f0f4910943        kennethreitz/httpbin:latest   "gunicorn -b 0.0.0.0…"   6 seconds ago       Up 4 seconds        80/tcp                                                    01_front_proxy_app_1
fc9387fb0626        01_front_proxy_envoy          "/entrypoint.sh"         6 seconds ago       Up 4 seconds        0.0.0.0:8001->8001/tcp, 10000/tcp, 0.0.0.0:8080->80/tcp   01_front_proxy_envoy_1
```

## We Succeeded!!!

You should see something like this if you successfully called HTTPBin through Envoy:

```
**************    About to call httpbin via envoy front proxy    **************

Press enter to continue...
Note: Unnecessary use of -X or --request, GET is already inferred.
*   Trying ::1...
* TCP_NODELAY set
* Connected to localhost (::1) port 8080 (#0)
> GET /anything HTTP/1.1
> Host: localhost:8080
> User-Agent: curl/7.61.0
> Accept: */*
> 
< HTTP/1.1 200 OK
< server: envoy
< date: Tue, 01 Sep 2020 18:33:59 GMT
< content-type: application/json
< content-length: 353
< access-control-allow-origin: *
< access-control-allow-credentials: true
< x-envoy-upstream-service-time: 4
< 
{
  "args": {}, 
  "data": "", 
  "files": {}, 
  "form": {}, 
  "headers": {
    "Accept": "*/*", 
    "Content-Length": "0", 
    "Host": "localhost:8080", 
    "User-Agent": "curl/7.61.0", 
    "X-Envoy-Expected-Rq-Timeout-Ms": "15000"
  }, 
  "json": null, 
  "method": "GET", 
  "origin": "172.30.0.3", 
  "url": "http://localhost:8080/anything"
}
* Connection #0 to host localhost left intact
```

# Congratulations

Congratulations, you have successully stood up your first Envoy instance and configured it to forward traffic! This is the simplest possible Envoy configuration :)  We don't have any security yet or any other features that Envoy is famous for. We will get to that in future articles. Feel free to use [postman](https://www.postman.com/) to explore other request that you can send. Additionally, don't forget to explore Envoy's admin console by pointing your web browser to [http://localhost:8001](http://localhost:8001)