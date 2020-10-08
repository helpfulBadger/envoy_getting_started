# Getting Started with Envoy & Open Policy Agent --- 06 ---
## JWS Signature Validation with Envoy

This is the 6th Envoy & Open Policy Agent Getting Started Guides. Each guide is intended to explore a single feature and walk through a simple implementation. Each guide builds on the concepts explored in the previous guide with the end goal of building a very powerful authorization service by the end of the series. 

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

## Introduction

One of the HTTP filters available is the JSON Web Token filter. It is lines 14 - 27 highlighted below. You an specify any number of `providers`. For each provider the developer specifies the desired validation rules. In our case we have 3 tokens that we will be validating. For each we specify:
* The issuers and audiences that must be present. Just like with Open Policy Agent audiences, the requirement is that the specified audience is matches one of the audiences in the array. 
* The `from_headers` property tells Envoy where to find the JWS
* The `forward` property specifies if the token should be forwarded to the protected API or if the header should be removed before forwarding. If the JWS tokens can be misused by the protected API then they should be removed. 
* The `local_jwks` propery allows you to specify the JSON web keyset in the configuration. Another option is to retrieve them from an HTTP endpoint that hosts the key set. 

The configuration below shows the properties we just described on lines 22, 25 and 26.

``` yaml
static_resources:
  listeners:
    - address:
      ...
      filter_chains:
          - filters:
            - name: envoy.filters.network.http_connection_manager
              typed_config:
                "@type": type.googleapis.com/envoy.extensions.filters.network.http_connection_manager.v3.HttpConnectionManager
                ...
                route_config:
                ...
                http_filters:
                  - name: envoy.filters.http.jwt_authn
                    typed_config:
                      "@type": "type.googleapis.com/envoy.extensions.filters.http.jwt_authn.v3.JwtAuthentication"
                      providers:
                        workforce_provider:
                          issuer: workforceIdentity.example.com
                          audiences:
                          - apigateway.example.com
>                          from_headers:
                          - name: "actor-token"
                            value_prefix: ""
>                          forward: true
>                          local_jwks:
                            inline_string: "..."
```

<br>

The section highlighted below is the rules section. It defines under what conditions to look for and validate a JWS. The match section defines what prefixes to look for. The slash will look for JWS tokens on every URI path. We can specify quite a few rules to determine how many and which tokens we require and under what circumstances. The <span style="color:blue">[Official JWT Auth documentation](https://www.envoyproxy.io/docs/envoy/latest/api-v2/config/filter/http/jwt_authn/v2alpha/config.proto)</span> specifies several other options on how to craft logic using and, or and any operations as well as other locations where JWS tokens can be located. There isn't as much control over what response to return to clients in the case of a failed authentication. OPA lets the developer change chose the HTTP Status code, include messages in the response body add headers etc. Envoy's built in feature simply returns an HTTP 401 Unauthorized response. 

<br>

``` yaml
                        consumer_provider:
                          ...
                        gateway_provider:
                          ...
>                      rules:
                        - match:
                            prefix: /
                          requires:
                            requires_all:
                              requirements:
                                - provider_name: workforce_provider
                                - provider_name: consumer_provider
                                - provider_name: gateway_provider
                  - name: envoy.filters.http.router
                    typed_config: {}
  clusters:
  ...
admin:
...
```

To see this capability in action, simply run the `demonstrate_envoy_jws_validation.sh` script. The output is similar to the completed solution from the previous lesson. The script also dumps the Envoy logs to show the information that you have available to trouble shoot issues. Below is a screen shot of the log statements that show Envoy extracting the tokens, performing the validation and logging the result. 

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/06_envoy_jws_log.png" /><br>

# Conclusion

In this getting started example, we successfully validated 3 different JWS tokens in a single request and had flexibility to chose where the tokens were pulled from, how many tokens were required and under what conditions those tokens were needed. In our next getting started guide, we will use Open Policy Agent and our identity tokens to make some more sophisticated authorization decisions. 
