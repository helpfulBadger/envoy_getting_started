+++
author = "Helpful Badger"
title = "Using Envoy as a Front Proxy"
draft = false
date = 2020-08-31T13:27:14-04:00
description = "Learn how to set up Envoy as a front proxy with docker"
tags = [
    "Envoy",
    "Service Mesh",
]
categories = [
    "cloud",
    "service mesh",
]
images  = ["img/2020/08/mattia-serrani-HgUAqCGN9-o-unsplash.jpg"]
+++

Photo by [Mattia Serrani](https://unsplash.com/@mattserra13?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText) on [Unsplash](https://unsplash.com/?utm_source=unsplash&amp;utm_medium=referral&amp;utm_content=creditCopyText)


# Using Envoy as a Front Proxy

## Overview

[Envoy](https://www.envoyproxy.io/) is an open source edge and service proxy that has become extremely popular as the backbone underneath most of the leading service mesh products (both open source and commercial). This article is intended to demystify it a bit and help people understand how to use it on it's own in a minimalist fashion. 

Envoy is just like any other proxy. It receives requests and forwards them to services that are located behind it. The 2 ways to deploy Envoy are:
1. Front Proxy - In a front proxy deployment Envoy is very similar to NGINX, HAProxy, or an Apache web server. The Envoy server has it's own IP address and is a separate server on the network from the services that it protects. Traffic comes in and get forwarded to a number of different services that are located behind it. Envoy supports a variety of methods for making routing decisions. 
    * One mechanism is to use path based routing to determine the service of interest. For instance a request coming in as: `/service1/some/other/stuff` can use the first uri path element as a routing key. `service1` can be used to route requests to service 1. Additionally, `service2` in `/service2/my/applications/path` can be used to route the request to a set of servers that support service 2. The path can be rewritten as it goes through Envoy to trim off the service routing prefix.
    * Another mechanism is to use Server Name Indication (SNI) which is a TLS extension to determine where to forward a request. Using this technique, `service1.com/some/other/stuff` would use the server name to route to the `service1` services. Additionally, `service2.com/my/applications/path` would use service2.com to route the request to `service2`.
    <img class="special-img-class" src="/img/2020/08/Envoy-front proxy-front-proxy.svg" /><br>
    The diagram above shows the front proxy approach. 

1. Sidecar Proxy - In a sidecar deployment, the Envoy server is located at the same IP address as each service that it protects. The Envoy server when deployed as as sidecar only has a single service instance behind it. The sidecar approach can intercept all inbound traffic and optionally all outbound traffic on behalf of the service instance. [IP Tables](https://en.wikipedia.org/wiki/Iptables) rules are typically used to configure the operating system to capture and redirect this traffic to Envoy. <img class="special-img-class" src="/img/2020/08/Envoy-front proxy-sidecar.svg" /><br>
    The diagram above shows the sidecar approach.

In this article and example project we will start with the simplest possible Envoy deployment. This example just uses docker compose to show how to get Envoy up and running. There will be a number of subsequent articles that expand on this simple approach to demostrate more Envoy capabilies. Open Policy Agent will also be introduced to handle more complex authorization use cases that cannot be handled by Envoy alone. 

The diagram below shows the environment that we are about to build and deploy locally. 

<img class="special-img-class" src="/img/2020/08/Envoy-front proxy-envoy_in_docker.svg" />

## Building an Envoy Front Proxy

The [code for the complete working example](https://github.com/helpfulBadger/envoy_getting_started/tree/master/01_front_proxy) can be found on Github. We will start with the Envoy docker images. The Envoy images are located on [Dockerhub](https://hub.docker.com/r/envoyproxy/envoy/tags). We will use `docker-compose` to build some configurability into our Envoy environment. 

### Dockerfile
{{< gist helpfulBadger 474f08336d221b6756f38fedc02b9740 >}}

The `entrypoint.sh` file is where the magic happens. We will configure environment variables in our docker-compose file to determine which service (`SERVICE_NAME`) Envoy routes to and the port (`SERVICE_PORT`) on that service. Additionally, we specify how much detail is captured in the logs by setting the `DEBUG_LEVEL` environment variable. As you can see from the script below on line 3, we replace those environment variables on the fly in Envoy's configuration file before starting Envoy. 

### entrypoint.sh

{{< gist helpfulBadger 9810fb19874141e18619d0c2426fadde >}}

Since we don't have a configuration file yet, we will cover that next. Envoy is very flexible and powerful. There is an enormous amount of expressiveness that the Envoy API and configuration files support. With this flexibility and power, Envoy configuration files can become quite complicated with a lot layers in the YAML hierarchy. Additionally, each feature has a lot of configuration parameters. The documentation can only cover so much of that functionality with an open source community of volunteers. 

One of the challenges that I have when reading through the documentation and trying to apply it, is that the documentation has a variety of YAML snippets. There are very few places that these YAML snippets are pulled together into a functioning example. There are a few examples in the source code examples directory but they are far from comprehensive. That leaves a lot of tinkering for engineers to figure out how to compose a functional configuration while interpretting sometimes unclear error messages on their way to the promised land. That is the entire reason that I am writting a series of getting started guides. These articles are intended to give folks a known to work starting point for Envoy authorization features and extensions like Open Policy Agent.

The Envoy configuration starts with defining a listener as we can see starting on line 3. The first property is the address and port to accept traffic on (lines 3 through 6). The next property is a filter chain. Filter chains are very powerful and enable configuration for a wide variety of possible behaviors. This filter chain is as simple as it gets. It simply accepts any HTTP traffic with any URI pattern and routes it to the cluster named `service`.

The `http_connection_manager` component does this for us. It's configuration starts on line 9 and extends to line 24. Execution order is determined by the order they are listed in the configuration file. The important part for this discussion begins on line 14 with the `route_config`. This sets up routing requests for any domain (line 18) and any request URI that begins with a slash (line 20) to go to the cluster named `service`. The cluster definitions are in a separate section to make them reusable destination across a variety of rules.

### Envoy Configuration (envoy.yaml)

{{< gist helpfulBadger 6776c186ec8e35b824222f5f57832279 >}}

The cluster definitions begin on line 25. We can see that there is only a single cluster defined. It has the name `service`, uses DNS to find server instances and uses round robin to direct traffic across multiple instances. The hostname is on line 32 and the port is on line 33. As we can see these are the environment variables that we will swap out with the entry.sh script. 

The last section of the configuration file tells Envoy where to listen for admin traffic. The admin gui is a handy little tool that we will not cover in this guide but is definitely worth poking around in to observe what is going on inside an individual Envoy instance. 


### Docker Compose Configuration

Now that we understand the Envoy configuration we can move on to understanding the rest of the simple environment that we are setting up. Line 4 shows the trigger that causes docker to build the Envoy container. Docker will only build the Envoy Dockerfile the first time it sees that an image does not exist. If you want to force rebuilding the Envoy container on subsequent runs add the `--build` parameter to your docker compose command.  We expose Envoy to the host network on lines 6 and 7 and provide the configuration file that we just created on line 9. 

{{< gist helpfulBadger c2abd820fb9d41b65a64d5aeb5bdc38f >}}

The service to route to and port are defined on the environment variables on lines 12 and 13. Notice the name app matches the name of our final service on line 15. We are simply using HTTPBIN to reflect our request back to us. 

## Running and Trying out our Example

The last step to getting our front proxy up is simply running the included script that demonstrates our example. The script explains what it is about to do to ensure you know what are about to see scrolling across your terminal screen. Line 8 starts our environment. Line 14 let's you check to make sure both containers are running before trying to send them a request. 

{{< gist helpfulBadger 99cd40f5e4a0f7c6f52e0f6ab384628d >}}

Line 19 simply calls Envoy with a curl command with the `--verbose` parameter set so that you can see the headers and request details. Then line 25 tears down the whole environment. 

## Containers UP!!!!

If you have successfully started your environment then you should see something like this: 

{{< gist helpfulBadger da12d55bdea21f53d1c21f43b75dde50 >}}

## We Succeeded!!!

You should see something like this if you successfully called HTTPBin through Envoy:

{{< gist helpfulBadger f3462263e846c7d203694cdd7393db2b >}}

# Congratulations

Congratulations, you have successully stood up your first Envoy instance and configured it to forward traffic! This is the simplest possible Envoy configuration :)  We don't have any security yet or any other features that Envoy is famous for. We will get to that in future articles. Feel free to use [postman](https://www.postman.com/) to explore other request that you can send. Additionally, don't forget to explore Envoy's admin console by pointing your web browser to [http://localhost:8001](http://localhost:8001)