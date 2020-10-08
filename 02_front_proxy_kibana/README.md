# Getting Started with Envoy & Open Policy Agent --- 02 ---
# Adding Log Aggregation to our Envoy Example

This is the 2nd in a series of getting started guides for using Envoy and Open Policy Agent to authorize API requests. Later on as we start to develop authorization rules it may be handy to have all of the logs aggregated and displayed in one place for your development and troubleshooting activies. In this article we will walk through how to setup the EFK stack to pull your logs together from all of the docker containers in your local development environment. 

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
1. [Sign / Verify HTTP Requests](../envoy_opa_9_sign_verify.md) --- Learn how to use Envoy & OPA to sign and validate HTTP Requests

## Adding EFK containers

We will be using Fluent Bit in this example because it is lite weight and simpler to deal with than Logstash or full fledged FluentD. Below is a Dockerfile with a very basic configuration and no special optimizations. Lines 9 and 30 use the `depend_on` property to cause docker to start elasticSearch first and then the other containers that depend on elasticSearch. 

``` Dockerfile
  fluentbit:
    image: fluent/fluent-bit:1.5.2 
    volumes:
      - ./fluent-bit.conf:/fluent-bit/etc/fluent-bit.conf
    restart: always
    ports:
      - "24224:24224"
      - "24224:24224/udp"
    depends_on:
      - elasticsearch

  # Elasticsearch Docker Images: https://www.docker.elastic.co/
  elasticsearch:
    image: docker.elastic.co/elasticsearch/elasticsearch:7.4.2
    restart: always
    environment:
      - "xpack.security.enabled=false"
      - "discovery.type=single-node"
    ports:
      - "9200:9200"
      - "9300:9300"

  kibana:
    image: docker.elastic.co/kibana/kibana:7.4.2
    restart: always
    environment:
      - ELASTICSEARCH_HOSTS=http://elasticsearch:9200
    ports:
      - 5601:5601
    depends_on:
      - elasticsearch
```

## Wiring our containers into EFK

With the log aggregation containers added to our docker-compose file, we now need to wire them into the other containers in our environment. The Dockerfile below shows a couple of small changes that we needed to make to our compose file from Getting Started Guide #1. We added the property at line 14 below which expresses our dependency on elasticSeach. Additionally, we need to wire standard out and standard error from our containers to fluentBit. This is done through the logging properties on lines 17 and 27. The driver line tells docker which log driver to use and the tag help make it more clear which container is the source of the logs. 

``` Dockerfile
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
    depends_on:
      - fluentbit
      - elasticsearch
    logging:
      driver: fluentd
      options:
        tag: envoy

  app:
    image: kennethreitz/httpbin:latest
    depends_on:
      - fluentbit
      - elasticsearch
    logging:
      driver: fluentd
      options:
        tag: httpbin
```

# Taking things for a spin

The demonstration script spins everything up for us. Just run `./demonstrate_front_proxy.sh` to get things going:
1. It downloads and spins up all of our containers. 
1. Then it waits 30 seconds to give elasticSearch some time to get ready and some time for Kibana to know that elasticSearch is ready. 
1. A curl command sends Envoy a request to make sure the end-to-end flow is working. 
1. If that worked, proceed forward. If not wait a bit longer to make sure elasticSearch and Kibana are both ready.
1. If you are running on Mac OS X then the next step will open a browser and take you to the page to setup your Kibana index. If it doesn't work, simply open your browser and go to `http://localhost:5601/app/kibana#/management/kibana/index_pattern?_g=()` you should see something like this:     <img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/02_Kibana_index_pattern_1.png" /><br>
1. I simply used `log*` as my index and clicked next. Which should bring up a screen to select the timestamp field name. <img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/02_Kibana_index_pattern_2.png" /><br> Select `@timestamp` and click create index. 
1. You should see some field information about your newly created index. <img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/02_Kibana_index_pattern_3.png" /><br>
1. The script then uses the Open command to navigate to the log search interface. If it doesn't work on your operating system then simply navigate to `http://localhost:5601/app/kibana#/discover`. You should see something like this with some log results already coming in.<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/02_Kibana_results_coming_in.png" /><br>
1. If you have an interest, you may want to select the `container_name` and `log` columns to make it easier to read through the debug logs and results of your testing efforts.  <img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/02_Kibana_select_columns.png" /><br>
1. The script sends another request through envoy and you should be able to see the logs coming into EFK. <img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/02_Kibana_z_Envoy_request.png" /><br>
1. The script with then take down the environment. 

In the next getting started guide, we will add in Open Policy Agent and begin experimenting with a simple authorization rule. 
