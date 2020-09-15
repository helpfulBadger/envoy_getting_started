
# Getting Started with Envoy & Open Policy Agent --- 08 ---
## Learn how to configure Envoy's access logs, taps for capturing full requests & responses and traces for capturing end to end flow

This is the 8th Envoy & Open Policy Agent Getting Started Guide. Each guide is intended to explore a single feature and walk through a simple implementation. Each guide builds on the concepts explored in the previous guide with the end goal of building a very powerful authorization service by the end of the series. 

## Introduction

In this example we are going to use both a Front Proxy deployment and a service mesh deployment to centralize log configuration, capture full requests and responses with taps and to inject trace information. Logs and taps can be done transparently without the knowledge nor cooperation from our applications. However, for traces there cooperation from our app is required to forward the trace headers to the next link in the chain. 

The diagram below shows what we will be building. 

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/09/Envoy-front%20proxy-gs_08_logs_taps_traces.svg" /><br>

The Envoy instances throughout our network will be streaming logs, taps and traces on behalf of the applications involved in the request flow.

## Let's Start with Configuring Our Logs

Envoy gives you the ability configure what it logs as a request goes though the proxy. Envoy's web site has documentation for <span style="color:blue">[access log configuration](https://www.envoyproxy.io/docs/envoy/latest/configuration/observability/access_log/usage#configuration)</span>. There are a few things to be aware of:
* Each request / response header must be individually configured to make it to the logs. I haven't found a log-all-headers capability. This is can be a good thing because sensitive information doesn't get logged without a conscious decision to log it. On the other side of the coin, if you are using multiple trace providers, then you will miss trace headers from these other solutions until:
    1. You are even aware that they are in use
    1. You update the configuration for every node
    1. There is no ability to run analytics from the time they started being used. You will only be able to go back to the time you became aware of these new headers and updated your configurations. 
* The property name `match_config` that we use in this article is entering deprecation when Envoy 1.16 comes out. I'll will update this post to the new property name once 1.16 is released.
* We will be using Elastic Common Schema in this example to the extent that we can with Envoy 1.15's configuration limitations.
* Also coming with Envoy 1.16 will be nested JSON support. Once released I'll update the example to switch from the dot notation used here to nested JSON. 

Read through this snippet of envoy configuration. The full configuration files for our 3 envoy instances are located here:
* <span style="color:blue">[Front Proxy's Configuration](https://github.com/helpfulBadger/envoy_getting_started/blob/master/08_log_taps_traces/front-envoy-jaeger.yaml#L54-L119)</span>
* <span style="color:blue">[Service 1's Envoy Configuration](https://github.com/helpfulBadger/envoy_getting_started/blob/master/08_log_taps_traces/service1-envoy-jaeger.yaml#L51-L116)</span>
* <span style="color:blue">[Service 2's Envoy Configuration](https://github.com/helpfulBadger/envoy_getting_started/blob/master/08_log_taps_traces/service2-envoy-jaeger.yaml#L51-L116)</span>


Elastic common schema was introduced to make it easier to analyze logs across applications. <span style="color:blue">[This article on the elastic.co web site](https://www.elastic.co/blog/introducing-the-elastic-common-schema)</span> is a good read and explains it in more detail. The <span style="color:blue">[reference for elastic common schema](https://www.elastic.co/guide/en/ecs/current/index.html)</span> provides names for many typical deployment environments, and cloud environments etc. 

Below is the abbreviation envoy.yaml configuration that shows how to specify our logging configuration. The explanation of the configuration follows. 

{% highlight yaml linenos %}
static_resources:
  listeners:
  ...
  - address:
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          generate_request_id: true
          ...
          route_config:
          http_filters:
          ...
>          access_log:
          - name: envoy.access_loggers.file
            typed_config:
>              "@type": type.googleapis.com/envoy.extensions.access_loggers.file.v3.FileAccessLog
>              path: "/dev/stdout"
>              typed_json_format: 
                "@timestamp": "%START_TIME%"
>                client.address: "%DOWNSTREAM_REMOTE_ADDRESS%"
                client.local.address: "%DOWNSTREAM_LOCAL_ADDRESS%"
>                envoy.route.name: "%ROUTE_NAME%"
                envoy.upstream.cluster: "%UPSTREAM_CLUSTER%"
                host.hostname: "%HOSTNAME%"
                http.request.body.bytes: "%BYTES_RECEIVED%"
                http.request.duration: "%DURATION%"
                http.request.headers.accept: "%REQ(ACCEPT)%"
                http.request.headers.authority: "%REQ(:AUTHORITY)%"
>                http.request.headers.id: "%REQ(X-REQUEST-ID)%"
                http.request.headers.x_forwarded_for: "%REQ(X-FORWARDED-FOR)%"
                http.request.headers.x_forwarded_proto: "%REQ(X-FORWARDED-PROTO)%"
                http.request.headers.x_b3_traceid: "%REQ(X-B3-TRACEID)%"
                http.request.headers.x_b3_parentspanid: "%REQ(X-B3-PARENTSPANID)%"
                http.request.headers.x_b3_spanid: "%REQ(X-B3-SPANID)%"
                http.request.headers.x_b3_sampled: "%REQ(X-B3-SAMPLED)%"
                http.request.method: "%REQ(:METHOD)%"
                http.response.body.bytes: "%BYTES_SENT%"
>                service.name: "envoy"
                service.version: "1.16"
                ...
  clusters:
admin:
{% endhighlight %}

The `access_log` configuration section is part of the HTTP Connection Manager Configuration and at the same nesting level as the `route_config` and `http_filters` sections. 
* We use a typed config `type.googleapis.com/envoy.extensions.access_loggers.file.v3.FileAccessLog` in version 3 of the configuration API
* The file path is set to standard out to so that log aggregation can be managed by docker. 
* The `typed_json_format` property is what allows us to create logs in JSON Lines format
* Envoy gives us template strings to insert into the configuration that it will replace with the request specific values at run time. `client.address: "%DOWNSTREAM_REMOTE_ADDRESS%"`. In these examples, we have pretty much used every available template string. The client section of elastic common schema holds everything that we know about the client application that is originating the request. We use dot notation here since nested JSON support is not available in Envoy 1.15
* Elastic Common Schema does not have standard names for everything. So we created a section for unique Envoy properties `envoy.route.name: "%ROUTE_NAME%"`
* The configuration language has macros that enable us to do lookups. In this example we lookup the X-Request-Id header and put it in the http.request.headers.id field `http.request.headers.id: "%REQ(X-REQUEST-ID)%"`
* We can insert static values into the logs for hardcoding labels such as which service the log entry is for etc. `service.name: "envoy"`

## Now Let's Tackle Taps
 
Taps let us capture full requests and responses. More details are for <span style="color:blue">[how the tap feature works](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_filters/tap_filter)</span> is located in the Envoy Documentation. There are 2 ways that we can capture taps:
1. Statically configured with a local filesystem directory as the target for output. Envoy will store the request and response for each request in a separate file. The output directory must be specified with a trailing slash. Otherwise the files will not be written. The good news here is that you don't need log rotate. You can have a separate process scoop up each file, send the data to a log aggregator and then delete the file. 
1. The second method for getting taps is by sending a configuration update to the admin port with a selection criteria and then holding the connection open while waiting for taps to stream in over the network. This would obviously be the preferred approach for a production environment. 

Below is abbreviated structure of our Envoy.yaml config file. The highlighted section is the tap configuration. Taps are simply another available HTTP filter. 
* We have match configuration that allows us to selectively target what we tap and what we don't. 
* The output configuration section is where we specify where the taps should be sent. For the `file_per_tap` sink, remember to add the trailing slash to the path otherwise no files will be written. Additionally, the file path can't be set to standard out due to the expectation that new files will be opened under the subdirectory that is specified. 

``` yaml {linenos=inline,hl_lines=["12-22"],linenostart=1}
static_resources:
  listeners:
  ...
  - address:
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          route_config:
          http_filters:
>          - name: envoy.filters.http.tap
>            typed_config:
>              "@type": type.googleapis.com/envoy.extensions.filters.http.tap.v3.Tap
>              common_config:
>                static_config:
>                  match_config:
>                    any_match: true
>                  output_config:
>                    sinks:
>                      - file_per_tap:
>                          path_prefix: /tmp/any/
          - name: envoy.filters.http.router
            typed_config: {}
          access_log:
          ...
  clusters:
  ...
admin:
...
```

> NOTE: The tap filter is experimental and is currently under active development. There is currently a very limited set of match conditions, output configuration, output sinks, etc. Capabilities will be expanded over time and the configuration structures are likely to change.

## Enabling Traces

The <span style="color:blue">[overview documentation for Envoy's Tracing features](https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/observability/tracing#arch-overview-tracing)</span> succinctly describes Envoy's tracing capabilities very well. So, I have included a snippet here as a lead in to our configuration.

> Distributed tracing allows developers to obtain visualizations of call flows in large service oriented architectures. It can be invaluable in understanding serialization, parallelism, and sources of latency. Envoy supports three features related to system wide tracing:
> * Request ID generation: Envoy will generate UUIDs when needed and populate the x-request-id HTTP header. Applications can forward the x-request-id header for unified logging as well as tracing. The behavior can be configured on per HTTP connection manager basis using an extension.
> * Client trace ID joining: The x-client-trace-id header can be used to join untrusted request IDs to the trusted internal x-request-id.
> * External trace service integration: Envoy supports pluggable external trace visualization providers, that are divided into two subgroups:
>   * External tracers which are part of the Envoy code base, like LightStep, Zipkin or any Zipkin compatible backends (e.g. Jaeger), and Datadog.
>   * External tracers which come as a third party plugin, like Instana.

Tracing options are exploding and as such expect a lot of new capabilities to be added to Envoy. There are a great deal of configuration options already. We are demonstrating the simplest possible tracing solution. Therefore, configuration below leverages the built in support for Zipkin compatible backends (jaegar). 

In lines 11 -19 below, the tracing configuration is standard part of the version 3 connection manager. The tracing property contains a provider. 
* We have set up zipkin as the output format with jaegar as the configured destination. HTTP and gRPC are both supported. The example uses HTTP protocol for transmitting the traces. 
* Our trace configuration refers to a cluster that we have named jaeger. So, we need to add a cluster configuration for it in the clusters section of the configuration file. Lines 28 through 40 points Envoy to our all-in-one jaeger container and port 9411 on that container. 


``` yaml {linenos=inline,hl_lines=["11-19","28-40"],linenostart=1}
static_resources:
  listeners:
  - address:
    ...
    filter_chains:
    - filters:
      - name: envoy.filters.network.http_connection_manager
        typed_config:
          "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
          generate_request_id: true
>          tracing:
>            provider:
>              name: envoy.tracers.zipkin
>              typed_config:
>                "@type": type.googleapis.com/envoy.config.trace.v2.ZipkinConfig
>                collector_cluster: jaeger
>                collector_endpoint: "/api/v2/spans"
>                shared_span_context: false
>                collector_endpoint_version: HTTP_JSON
          codec_type: auto
          route_config:
            ...
          http_filters:
            ...
  clusters:
  - name: service1
    ...
>  - name: jaeger
>    connect_timeout: 1s
>    type: strict_dns
>    lb_policy: round_robin
>    load_assignment:
>      cluster_name: jaeger
>      endpoints:
>      - lb_endpoints:
>        - endpoint:
>            address:
>              socket_address:
>                address: jaeger
>                port_value: 9411
admin:
  ...
```

# Running the Solution

There is a bash script in the `08_log_taps_traces` directory that demonstrates the completed example. Just run `./demonstrate_log_tap_and_trace.sh` The script does the following:
1. It cleans up any left over files from a previous run.
1. Creates temporary directories to hold the taps and log files that we will capture.
1. Starts up 3 envoy instances, 2 services, and jaeger as drawn in our diagram at the top of this article. 
1. Shows the containers running for validation that there were no failures.
1. Sends a request through the Envoy front proxy and onwards through the service mesh.
1. Displays the custom access logs captured by each of the 3 Envoy proxies. 
>  * These logs are captured in JSON Lines format. 
>  * They are run through a tool called [jq](https://github.com/stedolan/jq) (running in a docker container). 
>  * JQ pretty prints each log line and sorts the keys to make it easier to see the data groupings.
>  * Service 1 has 2 log lines since it captures the request as it goes into service 1 and it in turn calls service 2. 
7. Shows the taps captured in all 3 envoy instances. These taps show the full request and response details.
1. The request and response bodies are base64 encoded in the taps in case they are binary. So, the script decodes each body that is available and shows it to the user.
1. It uses the open command to open Jaeger in a web browser. If it doesn't work on your operating system simply navigate to `http://localhost:16686/` on your own.
1. Finally it shuts down the environment. It leaves all of the logs and taps in the `tmp` directory for further inspection. 

## Let's take a look at our traces

**Jaeger Landing Page**

The Jaeger landing page displays a summary of recent traces. It also enables filtering and selection of traces.

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/09/08_jaeger_landing_page.png" /><br>


**Call Graph**

The Jaeger call graph page shows the entire call tree. Ours is pretty simple. It also shows response time details and where this trace fits withing the norms.

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/09/08_jaeger_graph_boxes.png" /><br>

**Trace Details**

The Jaeger trace details page shows all of the tags that were captured at each leg of the request's journey.

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/09/08_jaeger_display_trace.png" /><br>

# Congratulations

We have completed a tour of another Envoy feature. These observability features will come in handy as our system becomes more complex. Additionally, Envoy is a very powerful tool for intercepting our traffic in a legacy environment. This can give all of our legacy applications consistently formatted data across our entire environment. This super-power can be incredibly critical in an environment with a lot of older applications that don't have active development, limited engineering knowledge and obsolete technology stacks. 


