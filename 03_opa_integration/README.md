# Getting Started with Envoy & Open Policy Agent --- 03 ---
# Integrating Open Policy Agent with Envoy

This is the 3rd Envoy & Open Policy Agent Getting Started Guides. Each guide is intended to explore a single feature and walk through a simple implementation. Each guide builds on the concepts explored in the previous guide to build a very powerful authorization services by the end of the series. 

Here is a list of the Getting Started Guides that are currently available.

## Getting Started Guides

1. [Using Envoy as a Front Proxy](../01_front_proxy/README.md) --- Learn how to set up Envoy as a front proxy with docker
1. [Adding Observability Tools](../02_front_proxy_kibana/README.md) --- Learn how to add ElasticSearch and Kibana to your Envoy front proxy environment
1. [Plugging Open Policy Agent into Envoy](../03_opa_integration/README.md) --- Learn how to use Open Policy Agent with Envoy for more powerful authorization rules
1. [Using the Open Policy Agent CLI](../04_opa_cli/README.md) --- Learn how to use Open Policy Agent Command Line Interface
1. [JWS Signature Validation with OPA](../05_opa_validate_jws/README.md) --- Learn how to validate JWS signatures with Open Policy Agent
1. [JWS Signature Validation with Envoy](../06_envoy_validate_jws/README.md) --- Learn how to validate JWS signatures natively with Envoy
1. [Putting It All Together with Composite Authorization](../07_opa_validate_method_uri/README.md) --- Learn how to Implement Application Specific Authorization Rules
1. [Configuring Envoy Logs Taps and Traces](../08_log_taps_traces/README.md) --- Learn how to configure Envoy's access logs taps for capturing full requests & responses and traces
1. [Sign / Verify HTTP Requests](../envoy_opa_9_sign_verify.md") --- Learn how to use Envoy & OPA to sign and validate HTTP Requests

## Envoy's External Authorization API

Envoy has the capability to call out to an external authorization service. There are 2 protocols supported. The authorization service can be either a RESTful API endpoint or using Envoy's new gRPC protocol. Envoy sends all of the request details to the authorization service including the method, URI, parameters, headers, and request body. The authorization service simply needs to return 200 OK to permit the request to go through. 

In this example we will be using a pre-built Open Policy Agent container that already understands Envoy's authorization protocol. 

## Open Policy Agent Overview

The Open Policy Agent site describes it very succinctly 

The [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) is an open source, general-purpose policy engine. OPA provides a declarative language that let’s you specify policy as code and APIs to offload policy decision-making from your software. OPA to enforce policies in microservices, Kubernetes, CI/CD pipelines, API gateways, or nearly any other software.

OPA focuses exclusively on making policy decisions and not on policy enforcement. OPA pairs with Envoy for policy enforcement. OPA can run as:
* A standalone service accessible via an API
* A library that can be compiled into your code

It has an extremely flexible programming model:

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/Policy_Authoring.png" /><br>

Additionally, the company behind OPA, Styra, offers control plane products to author policies and manage a fleet of OPA instances.

OPA decouples policy decision-making from policy enforcement. When your software needs to make policy decisions it queries OPA and supplies structured data (e.g., JSON) as input. OPA accepts arbitrary structured data as input.

OPA generates policy decisions by evaluating the query input against policies and data. OPA expresses policies in a language called Rego. OPA has exploded in popularity and has become a Cloud Native Computing Foundation incubating project. Typical use cases are deciding:
* Which users can access which resources
* Which subnets egress traffic is allowed
* Which clusters a workload can be deployed to
* Which registries binaries can be downloaded from
* Which OS capabilities a container can execute with
* The time of day the system can be accessed

Policy decisions are not limited to simple yes/no or allow/deny answers. Policies can generate any arbitrary structured data as output.

This getting started example is based on [this OPA tutorial](https://www.openpolicyagent.org/docs/latest/envoy-authorization/) using docker-compose instead of Kubernetes.


# Solution Overview

In this getting started example we take the super simple envoy environment we created in getting started episode 1 and add the simplest possible authorization rule using Open Policy Agent.

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/Envoy-front%20proxy-OPA_GS3.svg" /><br>

## Docker Compose 

This is the same docker compose file as our initial getting started example with a few modifications. At line 15 in our docker-compose file, we added a reference to our Open Policy Agent container. This is a special verison of the Open Policy Agent containers on dockerhub. This version is designed to integrate with Envoy and has an API exposed the complies with Envoy's gRPC specification. There are also some other things to take notice of:

* Debug level logging is set on line 21
* The gRPC service for Envoy is configured on line 23
* The logs are sent to the console for a log aggregation solution to pickup (or not) on line 24

{{< gist helpfulBadger 8405aa13b6f33100edd8f2ec2ae97a79 >}}

## Envoy Config Changes

There are a few things that we need to add to the envoy configuration to enable external authorization:
* We added an external authorization configuration at line 24.
* failure_mode_allow on line 26 determines whether envoy fails open or closed when the authorization service fails.
* with_request_body determines if the request body is sent to the authorization service.
* max_request_bytes determines how large of a request body Envoy will permit.
* allow_partial_message determines if a partial body is sent or not when a buffer maximum is reached.
* The grpc_service object on line 30 specifies how to reach the Open Policy Agent endpoint to make an authorization decision.

``` yaml
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
                  - name: envoy.filters.http.ext_authz
                    typed_config:
                      "@type": type.googleapis.com/envoy.extensions.filters.http.ext_authz.v3.ExtAuthz
                      failure_mode_allow: false
                      with_request_body:
                        max_request_bytes: 4096
                        allow_partial_message: false
                      grpc_service:
                        google_grpc:
                          target_uri: opa:9191
                          stat_prefix: ext_authz
                        timeout: 0.5s
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


## Rego: OPA's Policy Language

There are a lot of other examples of how to write Rego policies on other sites. This walkthrough of Rego is targeted specifically to using it to make Envoy decisions:
* The package statement on the first line determines where the policy is located in OPA. When a policy decision is requested, the package name is used as the prefix used to locate the named decision.
* The import statement on line 3 navigates the heavily nested data structure that Envoy sends us and gives us a shorter alias to refer to a particular section of the input.
* On line 5 we have a rule named `allow` and we set it's default value to and object that Envoy is expecting. 
    * The allowed property determines if the request is permitted to go through or not.
    * The headers property allows us to set headers on either the forwarded request (if approved) or on the rejected request (if denied)
    * The body property can be used to communicate error message details to the requestor. It has no affect on requests approved for forwarding
    * The http_status property can be set on any rejected requests to any value as desired
* The next section starting at line 12 specifies the logic for approving the request to move forward
    * On line 12 the allow rule is set to the value of the response variable that we define in the body of the rule
    * Line 13 is the only condition we have defined for approval of the request. The request method simply needs to be a POST.
    * If true then we set the response to the values on lines 15 and 16. 

``` rego
package envoy.authz

import input.attributes.request.http as http_request

default allow = {
  "allowed": false,
  "headers": {"x-ext-auth-allow": "no"},
  "body": "Unauthorized Request\n\n",
  "http_status": 403
}

allow = response {
  http_request.method == "POST"
  response := {
      "allowed": true,
      "headers": {"X-Auth-User": "1234"}
  }
}
```


## Input data sent from Envoy

Now we dive into the details of the input data structure sent from Envoy. 
* Line 3 is an object that describes the IP address and Port that the request is going to
* Line 16 is the request object itself. The un-marshalled body is present along with:
    * request headers
    * hostname where the original request was sent
    * a unique request ID assigned by Envoy
    * request method
    * unparsed path
    * protocol 
    * request size
* Line 43 is a object that describes the IP address and port where the request originated
* Line 56 is where Envoy has already done some work for us to parse the request body (if it was configured to be forwarded)
* Line 60 and 63 are the parsed path and query parameters respectively
* Finally, line 71 let's us know whether we have the complete request body or not

``` json
{
  "attributes": {
    "destination": {
      "address": {
        "Address": {
          "SocketAddress": {
            "PortSpecifier": {
              "PortValue": 80
            },
            "address": "192.168.192.4"
          }
        }
      }
    },
    "metadata_context": {},
    "request": {
      "http": {
        "body": "{\"Body-Key-1\":\"value1\", \"Body-Key-2\":\"value2\"}",
        "headers": {
          ":authority": "localhost:8080",
          ":method": "POST",
          ":path": "/anything?param1=value&param2=value2",
          "accept": "*/*",
          "content-length": "46",
          "content-type": "application/json",
          "user-agent": "curl/7.61.0",
          "x-envoy-auth-partial-body": "false",
          "x-forwarded-proto": "http",
          "x-request-id": "09ad417b-b9c2-4e2a-be94-eb2175b8d650"
        },
        "host": "localhost:8080",
        "id": "5588042583835649046",
        "method": "POST",
        "path": "/anything?param1=value&param2=value2",
        "protocol": "HTTP/1.1",
        "size": 46
      },
      "time": {
        "nanos": 445143000,
        "seconds": 1599009510
      }
    },
    "source": {
      "address": {
        "Address": {
          "SocketAddress": {
            "PortSpecifier": {
              "PortValue": 43024
            },
            "address": "192.168.192.1"
          }
        }
      }
    }
  },
  "parsed_body": {
    "Body-Key-1": "value1",
    "Body-Key-2": "value2"
  },
  "parsed_path": [
    "anything"
  ],
  "parsed_query": {
    "param1": [
      "value1"
    ],
    "param2": [
      "value2"
    ]
  },
  "truncated_body": false
}
```


## Reviewing the Request Flow in Envoy's Logs

In debug mode, we have a lot of rich information that Envoy logs for us to help us determine what may be going wrong as we develop our system. 
* Line 1 shows our request first coming in 
* The next several lines show us the request headers
* Line 12 let's us know that envoy is buffering the request until it reaches the buffer limit that we set
* Line 15 and 16 show us that Envoy forwarded the request to our authorization service and got an approval to forward the request
* The remainder of the logs show envoy forwarding the request to its destination and then back to the calling client

```
[2020-09-02 01:18:30.444][17][debug][conn_handler] [source/server/connection_handler_impl.cc:372] [C0] new connection
[2020-09-02 01:18:30.445][17][debug][http] [source/common/http/conn_manager_impl.cc:268] [C0] new stream
[2020-09-02 01:18:30.445][17][debug][http] [source/common/http/conn_manager_impl.cc:781] [C0][S5588042583835649046] request headers complete (end_stream=false):
':authority', 'localhost:8080'
':path', '/anything?param1=value&param2=value2'
':method', 'POST'
'user-agent', 'curl/7.61.0'
'accept', '*/*'
'content-type', 'application/json'
'content-length', '46'

[2020-09-02 01:18:30.446][17][debug][filter] [source/extensions/filters/http/ext_authz/ext_authz.cc:89] [C0][S5588042583835649046] ext_authz filter is buffering the request
[2020-09-02 01:18:30.446][17][debug][http] [source/common/http/conn_manager_impl.cc:1991] [C0][S5588042583835649046] setting buffer limit to 4096
[2020-09-02 01:18:30.446][17][debug][http] [source/common/http/conn_manager_impl.cc:1333] [C0][S5588042583835649046] request end stream
[2020-09-02 01:18:30.446][17][debug][filter] [source/extensions/filters/http/ext_authz/ext_authz.cc:108] [C0][S5588042583835649046] ext_authz filter finished buffering the request since stream is ended
[2020-09-02 01:18:30.453][17][debug][grpc] [source/common/grpc/google_async_client_impl.cc:340] Finish with grpc-status code 0
[2020-09-02 01:18:30.453][17][debug][grpc] [source/common/grpc/google_async_client_impl.cc:203] notifyRemoteClose 0 
[2020-09-02 01:18:30.453][17][debug][router] [source/common/router/router.cc:477] [C0][S5588042583835649046] cluster 'service' match for URL '/anything?param1=value&param2=value2'
[2020-09-02 01:18:30.453][17][debug][router] [source/common/router/router.cc:634] [C0][S5588042583835649046] router decoding headers:
':authority', 'localhost:8080'
':path', '/anything?param1=value&param2=value2'
':method', 'POST'
':scheme', 'http'
'user-agent', 'curl/7.61.0'
'accept', '*/*'
'content-type', 'application/json'
'content-length', '46'
'x-forwarded-proto', 'http'
'x-request-id', '09ad417b-b9c2-4e2a-be94-eb2175b8d650'
'x-auth-user', '1234'
'x-envoy-expected-rq-timeout-ms', '15000'

[2020-09-02 01:18:30.453][17][debug][pool] [source/common/http/conn_pool_base.cc:337] queueing request due to no available connections
[2020-09-02 01:18:30.453][17][debug][pool] [source/common/http/conn_pool_base.cc:47] creating a new connection
[2020-09-02 01:18:30.453][17][debug][client] [source/common/http/codec_client.cc:34] [C1] connecting
[2020-09-02 01:18:30.453][17][debug][connection] [source/common/network/connection_impl.cc:727] [C1] connecting to 192.168.192.3:80
[2020-09-02 01:18:30.454][17][debug][connection] [source/common/network/connection_impl.cc:736] [C1] connection in progress
[2020-09-02 01:18:30.454][17][debug][grpc] [source/common/grpc/google_async_client_impl.cc:382] Stream cleanup with 0 in-flight tags
[2020-09-02 01:18:30.454][17][debug][grpc] [source/common/grpc/google_async_client_impl.cc:371] Deferred delete
[2020-09-02 01:18:30.454][17][debug][grpc] [source/common/grpc/google_async_client_impl.cc:146] GoogleAsyncStreamImpl destruct
[2020-09-02 01:18:30.454][17][debug][connection] [source/common/network/connection_impl.cc:592] [C1] connected
[2020-09-02 01:18:30.454][17][debug][client] [source/common/http/codec_client.cc:72] [C1] connected
[2020-09-02 01:18:30.454][17][debug][pool] [source/common/http/conn_pool_base.cc:143] [C1] attaching to next request
[2020-09-02 01:18:30.454][17][debug][pool] [source/common/http/conn_pool_base.cc:68] [C1] creating stream
[2020-09-02 01:18:30.454][17][debug][router] [source/common/router/upstream_request.cc:317] [C0][S5588042583835649046] pool ready
[2020-09-02 01:18:30.458][17][debug][router] [source/common/router/router.cc:1149] [C0][S5588042583835649046] upstream headers complete: end_stream=false
[2020-09-02 01:18:30.459][17][debug][http] [source/common/http/conn_manager_impl.cc:1706] [C0][S5588042583835649046] encoding headers via codec (end_stream=false):
':status', '200'
'server', 'envoy'
'date', 'Wed, 02 Sep 2020 01:18:30 GMT'
'content-type', 'application/json'
'content-length', '615'
'access-control-allow-origin', '*'
'access-control-allow-credentials', 'true'
'x-envoy-upstream-service-time', '4'

[2020-09-02 01:18:30.459][17][debug][client] [source/common/http/codec_client.cc:104] [C1] response complete
[2020-09-02 01:18:30.459][17][debug][pool] [source/common/http/http1/conn_pool.cc:48] [C1] response complete
[2020-09-02 01:18:30.459][17][debug][pool] [source/common/http/conn_pool_base.cc:93] [C1] destroying stream: 0 remaining
[2020-09-02 01:18:30.459][17][debug][grpc] [source/common/grpc/google_async_client_impl.cc:95] Client teardown, resetting streams
[2020-09-02 01:18:30.461][17][debug][connection] [source/common/network/connection_impl.cc:558] [C0] remote close
[2020-09-02 01:18:30.461][17][debug][connection] [source/common/network/connection_impl.cc:200] [C0] closing socket: 0
[2020-09-02 01:18:30.461][17][debug][conn_handler] [source/server/connection_handler_impl.cc:86] [C0] adding to cleanup list
[2020-09-02 01:18:32.460][17][debug][connection] [source/common/network/connection_impl.cc:558] [C1] remote close
[2020-09-02 01:18:32.460][17][debug][connection] [source/common/network/connection_impl.cc:200] [C1] closing socket: 0
[2020-09-02 01:18:32.461][17][debug][client] [source/common/http/codec_client.cc:91] [C1] disconnect. resetting 0 pending requests
[2020-09-02 01:18:32.461][17][debug][pool] [source/common/http/conn_pool_base.cc:265] [C1] client disconnected, failure reason: 
[2020-09-02 01:18:33.423][7][debug][main] [source/server/server.cc:177] flushing stats
[2020-09-02 01
```


## Reviewing OPA's Decision Log

The open policy agent decision logs include the input that we just reviewed and some other information that we can use for debugging, troubleshoot or audit logging. The interesting parts that we haven't reviewed yet:
* The decision ID on line 2 can be matched against other OPA log entries related to this decision
* Line 75 has the labels that show which Envoy instance the request came from
* Line 80 is an object that contains the performance metrics for the decision
* Line 88 shows the response that OPA sent back to Envoy

``` json
{
  "decision_id": "3b381d21-318a-4277-a7d6-bd43916629ff",
  "input": {
    "attributes": {
      "destination": {
        "address": {
          "Address": {
            "SocketAddress": {
              "PortSpecifier": {
                "PortValue": 80
              },
              "address": "192.168.192.4"
            }
          }
        }
      },
      "metadata_context": {},
      "request": {
        "http": {
          "body": "{\"Body-Key-1\":\"value1\", \"Body-Key-2\":\"value2\"}",
          "headers": {
            ":authority": "localhost:8080",
            ":method": "POST",
            ":path": "/anything?param1=value&param2=value2",
            "accept": "*/*",
            "content-length": "46",
            "content-type": "application/json",
            "user-agent": "curl/7.61.0",
            "x-envoy-auth-partial-body": "false",
            "x-forwarded-proto": "http",
            "x-request-id": "09ad417b-b9c2-4e2a-be94-eb2175b8d650"
          },
          "host": "localhost:8080",
          "id": "5588042583835649046",
          "method": "POST",
          "path": "/anything?param1=value&param2=value2",
          "protocol": "HTTP/1.1",
          "size": 46
        },
        "time": {
          "nanos": 445143000,
          "seconds": 1599009510
        }
      },
      "source": {
        "address": {
          "Address": {
            "SocketAddress": {
              "PortSpecifier": {
                "PortValue": 43024
              },
              "address": "192.168.192.1"
            }
          }
        }
      }
    },
    "parsed_body": {
      "Body-Key-1": "value1",
      "Body-Key-2": "value2"
    },
    "parsed_path": [
      "anything"
    ],
    "parsed_query": {
      "param1": [
        "value1"
      ],
      "param2": [
        "value2"
      ]
    },
    "truncated_body": false
  },
  "labels": {
    "id": "02178b0c-eda6-4d93-a361-61ad3108c6a5",
    "version": "0.23.0-envoy"
  },
  "level": "info",
  "metrics": {
    "timer_rego_query_compile_ns": 108100,
    "timer_rego_query_eval_ns": 60700,
    "timer_server_handler_ns": 1992100
  },
  "msg": "Decision Log",
  "path": "envoy/authz/allow",
  "requested_by": "",
  "result": {
    "allowed": true,
    "headers": {
      "X-Auth-User": "1234"
    }
  },
  "time": "2020-09-02T01:18:30Z",
  "timestamp": "2020-09-02T01:18:30.451572Z",
  "type": "openpolicyagent.org/decision_logs"
}
```


# Taking this solution for a spin

Now that we know what we are looking at, we can run this example by executing the script `./demonstrate_opa_integration.sh`

1. The script starts the envoy front proxy, HTTPBIN and Open Policy Agent
1. Next it shows the docker container status to make sure everything is up and running. 
1. Curl is used to issue a request that should get approved, forwarded to HTTPBin and the display the results
1. The opa decision logs are then shown to let you explore the information available for development debugging and troubleshooting
1. To make sure we show both outcomes the next request should fail our simple authorization rule check.
1. The decision logs are shown again
1. Finally the example is brought down and cleaned up. 

In the next getting started guide we will explore Open Policy Agent's command line interface and unit testing support.