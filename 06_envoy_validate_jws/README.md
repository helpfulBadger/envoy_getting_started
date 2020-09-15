# Getting Started with Envoy & Open Policy Agent --- 06 ---
## JWS Signature Validation with Envoy

This is the 6th Envoy & Open Policy Agent Getting Started Guide. Each guide is intended to explore a single feature and walk through a simple implementation. Each guide builds on the concepts explored in the previous guide with the end goal of building a very powerful authorization service by the end of the series. 

## Introduction

One of the HTTP filters available is the JSON Web Token filter. It is color coded in red below. You an specify any number of `providers`. For each provider the developer specifies the desired validation rules. In our case we have 3 tokens that we will be validating. For each we specify:
* The issuers and audiences that must be present. Just like with Open Policy Agent audiences, the requirement is that the specified audience is matches one of the audiences in the array. 
* The `from_headers` property tells Envoy where to find the JWS
* The `forward` property specifies if the token should be forwarded to the protected API or if the header should be removed before forwarding. If the JWS tokens can be misused by the protected API then they should be removed. 
* The `local_jwks` propery allows you to specify the JSON web keyset in the configuration. Another option is to retrieve them from an HTTP endpoint that hosts the key set. 

The configuration below shows the properties we just described in the color red.

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
#                          forward: true
>                          local_jwks:
                            inline_string: "{\"keys\":[{\"use\":\"sig\",\"kty\":\"EC\",\"kid\":\"APIGW-ES256\",\"crv\":\"P-256\",\"alg\":\"ES256\",\"x\":\"g3uF5OZrWsU6yKJhv0FQxhALlmNbw6_Wa9_exT3-eNA\",\"y\":\"lJbCP1oz0vDs6Dxd_3my5Ga5fLSXRDzQVbTTlt9pr98\"},{\"use\":\"sig\",\"kty\":\"EC\",\"kid\":\"custIDP-ES256\",\"crv\":\"P-256\",\"alg\":\"ES256\",\"x\":\"HmVjNgoTIECfvja3E7WZX2H1OzXtvDhD5_SSMXGYxZU\",\"y\":\"ugCW-AoKaSyNqIbyNUgRWMJ8WY6s2W78YI2LdVVTGcY\"},{\"use\":\"sig\",\"kty\":\"EC\",\"kid\":\"workforceIDP-ES256\",\"crv\":\"P-256\",\"alg\":\"ES256\",\"x\":\"_Vg3wsKsY9XH5E5aPn2SLUTUljgum2TXnDY7m73p2Ek\",\"y\":\"rSbvTXUdPnFpJq5zqgRLMMAQP8bJ7UcggP1ERkEibGI\"},{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"APIGW-RS256\",\"alg\":\"RS256\",\"n\":\"thiAsWa8crD-RhGbAewoYjyWpgZpaFKHWqzqAM2iCJ94eQnSwFJJcFayOklSfKK8tUUYulG7FQijpdBLVzbilPtpYK8HjHoLZBLrvNPbEvwlMCVMDX5ttyn1lJV-6momFwuV6EJFnPMXJQU3KTX_QeFejiamxmYQsakyWxxDtTWJ1XAlvtIX3k0osQbFrLbF5SGIwAk9UBFlm2B_3M0lbqu6w8eOxgSc3z-Owd6maYu2Q43MZv-opjObHNfcc60o90iOO9pY5_qSkJt7Slf2cuKU6eOUjsoSCOgValKngogup_itt7LJkrt-ugFiwUITEt6V6MY1MHEw1RgM75N_iQ\",\"e\":\"AQAB\"},{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"custIDP-RS256\",\"alg\":\"RS256\",\"n\":\"z6AtZ3MpSZ1dd-AFyfxk5stjIrbLa8GLSq0GPqZ5RciZIkv-ad-phosgPSDvG1Nx4pcZcENrXAdMA6v6FjRvdGT0EH9CU2vXTu5kCmGP1vV1WfzFdL3K-mswnEaT6-9bO4-m6SEmR3J3YV5QwFVvxIVJqFSmLIggl1PVCM0pXCYb6vkcacg24E-vh6J28LdZmQFqmWHrF7mOL59oz1Gx8ePOr4WnqhP991DeIpzgiofGAS7QQSiNQoKvtizITk3-kcpjWmdw0Zh32xmhsUCu4NKn8DjY2dJ2-WwcL3KK__E0WBJt3I97Nr-m88BSEVl3-P--fsRiEgIP1Co2ulGMbQ\",\"e\":\"AQAB\"},{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"workforceIDP-RS256\",\"alg\":\"RS256\",\"n\":\"ucjZ1pagZuXL4GkFXzG7llZbhPUkl1GzG2vyE0YC3NCvgf2WS67KRH6ck_iMHsWraaPdEcbB8t6ftr0qEXC1ciwVc656Q4V4L_-pxWcD1XMfdiZoViaKyMlq1QzB55XgzM1g7cvgg6_rCmTEmTo3-LUvFd7HxpdHdkYz0U_EUmEB8amz3NxR3LaB-STyxnlsRDrIKmYqDNaPqArdn44INwkGeuJUir0ojw5gdbbazT1NIsuJb2y0zHXuu9ESnyKB8N40ydYe2ECxkdynOQaHt8tCKWhh3F32VwOOuZx34RuVSA_bQraGrduVBd05fEdsPUxq38f1-Z7I5YuokqE_Dw\",\"e\":\"AQAB\"}]}"
                        consumer_provider:
                          issuer: customerIdentity.example.com
                          audiences:
                          - apigateway.example.com
                          from_headers:
                          - name: "subject-token"
                            value_prefix: ""
                          forward: true
                          local_jwks:
                            inline_string: "{\"keys\":[{\"use\":\"sig\",\"kty\":\"EC\",\"kid\":\"APIGW-ES256\",\"crv\":\"P-256\",\"alg\":\"ES256\",\"x\":\"g3uF5OZrWsU6yKJhv0FQxhALlmNbw6_Wa9_exT3-eNA\",\"y\":\"lJbCP1oz0vDs6Dxd_3my5Ga5fLSXRDzQVbTTlt9pr98\"},{\"use\":\"sig\",\"kty\":\"EC\",\"kid\":\"custIDP-ES256\",\"crv\":\"P-256\",\"alg\":\"ES256\",\"x\":\"HmVjNgoTIECfvja3E7WZX2H1OzXtvDhD5_SSMXGYxZU\",\"y\":\"ugCW-AoKaSyNqIbyNUgRWMJ8WY6s2W78YI2LdVVTGcY\"},{\"use\":\"sig\",\"kty\":\"EC\",\"kid\":\"workforceIDP-ES256\",\"crv\":\"P-256\",\"alg\":\"ES256\",\"x\":\"_Vg3wsKsY9XH5E5aPn2SLUTUljgum2TXnDY7m73p2Ek\",\"y\":\"rSbvTXUdPnFpJq5zqgRLMMAQP8bJ7UcggP1ERkEibGI\"},{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"APIGW-RS256\",\"alg\":\"RS256\",\"n\":\"thiAsWa8crD-RhGbAewoYjyWpgZpaFKHWqzqAM2iCJ94eQnSwFJJcFayOklSfKK8tUUYulG7FQijpdBLVzbilPtpYK8HjHoLZBLrvNPbEvwlMCVMDX5ttyn1lJV-6momFwuV6EJFnPMXJQU3KTX_QeFejiamxmYQsakyWxxDtTWJ1XAlvtIX3k0osQbFrLbF5SGIwAk9UBFlm2B_3M0lbqu6w8eOxgSc3z-Owd6maYu2Q43MZv-opjObHNfcc60o90iOO9pY5_qSkJt7Slf2cuKU6eOUjsoSCOgValKngogup_itt7LJkrt-ugFiwUITEt6V6MY1MHEw1RgM75N_iQ\",\"e\":\"AQAB\"},{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"custIDP-RS256\",\"alg\":\"RS256\",\"n\":\"z6AtZ3MpSZ1dd-AFyfxk5stjIrbLa8GLSq0GPqZ5RciZIkv-ad-phosgPSDvG1Nx4pcZcENrXAdMA6v6FjRvdGT0EH9CU2vXTu5kCmGP1vV1WfzFdL3K-mswnEaT6-9bO4-m6SEmR3J3YV5QwFVvxIVJqFSmLIggl1PVCM0pXCYb6vkcacg24E-vh6J28LdZmQFqmWHrF7mOL59oz1Gx8ePOr4WnqhP991DeIpzgiofGAS7QQSiNQoKvtizITk3-kcpjWmdw0Zh32xmhsUCu4NKn8DjY2dJ2-WwcL3KK__E0WBJt3I97Nr-m88BSEVl3-P--fsRiEgIP1Co2ulGMbQ\",\"e\":\"AQAB\"},{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"workforceIDP-RS256\",\"alg\":\"RS256\",\"n\":\"ucjZ1pagZuXL4GkFXzG7llZbhPUkl1GzG2vyE0YC3NCvgf2WS67KRH6ck_iMHsWraaPdEcbB8t6ftr0qEXC1ciwVc656Q4V4L_-pxWcD1XMfdiZoViaKyMlq1QzB55XgzM1g7cvgg6_rCmTEmTo3-LUvFd7HxpdHdkYz0U_EUmEB8amz3NxR3LaB-STyxnlsRDrIKmYqDNaPqArdn44INwkGeuJUir0ojw5gdbbazT1NIsuJb2y0zHXuu9ESnyKB8N40ydYe2ECxkdynOQaHt8tCKWhh3F32VwOOuZx34RuVSA_bQraGrduVBd05fEdsPUxq38f1-Z7I5YuokqE_Dw\",\"e\":\"AQAB\"}]}"
                        gateway_provider:
                          issuer: apigateway.example.com
                          audiences:
                          - apigateway.example.com
                          from_headers:
                          - name: "app-token"
                            value_prefix: ""
                          forward: true
                          local_jwks:
                            inline_string: "{\"keys\":[{\"use\":\"sig\",\"kty\":\"EC\",\"kid\":\"APIGW-ES256\",\"crv\":\"P-256\",\"alg\":\"ES256\",\"x\":\"g3uF5OZrWsU6yKJhv0FQxhALlmNbw6_Wa9_exT3-eNA\",\"y\":\"lJbCP1oz0vDs6Dxd_3my5Ga5fLSXRDzQVbTTlt9pr98\"},{\"use\":\"sig\",\"kty\":\"EC\",\"kid\":\"custIDP-ES256\",\"crv\":\"P-256\",\"alg\":\"ES256\",\"x\":\"HmVjNgoTIECfvja3E7WZX2H1OzXtvDhD5_SSMXGYxZU\",\"y\":\"ugCW-AoKaSyNqIbyNUgRWMJ8WY6s2W78YI2LdVVTGcY\"},{\"use\":\"sig\",\"kty\":\"EC\",\"kid\":\"workforceIDP-ES256\",\"crv\":\"P-256\",\"alg\":\"ES256\",\"x\":\"_Vg3wsKsY9XH5E5aPn2SLUTUljgum2TXnDY7m73p2Ek\",\"y\":\"rSbvTXUdPnFpJq5zqgRLMMAQP8bJ7UcggP1ERkEibGI\"},{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"APIGW-RS256\",\"alg\":\"RS256\",\"n\":\"thiAsWa8crD-RhGbAewoYjyWpgZpaFKHWqzqAM2iCJ94eQnSwFJJcFayOklSfKK8tUUYulG7FQijpdBLVzbilPtpYK8HjHoLZBLrvNPbEvwlMCVMDX5ttyn1lJV-6momFwuV6EJFnPMXJQU3KTX_QeFejiamxmYQsakyWxxDtTWJ1XAlvtIX3k0osQbFrLbF5SGIwAk9UBFlm2B_3M0lbqu6w8eOxgSc3z-Owd6maYu2Q43MZv-opjObHNfcc60o90iOO9pY5_qSkJt7Slf2cuKU6eOUjsoSCOgValKngogup_itt7LJkrt-ugFiwUITEt6V6MY1MHEw1RgM75N_iQ\",\"e\":\"AQAB\"},{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"custIDP-RS256\",\"alg\":\"RS256\",\"n\":\"z6AtZ3MpSZ1dd-AFyfxk5stjIrbLa8GLSq0GPqZ5RciZIkv-ad-phosgPSDvG1Nx4pcZcENrXAdMA6v6FjRvdGT0EH9CU2vXTu5kCmGP1vV1WfzFdL3K-mswnEaT6-9bO4-m6SEmR3J3YV5QwFVvxIVJqFSmLIggl1PVCM0pXCYb6vkcacg24E-vh6J28LdZmQFqmWHrF7mOL59oz1Gx8ePOr4WnqhP991DeIpzgiofGAS7QQSiNQoKvtizITk3-kcpjWmdw0Zh32xmhsUCu4NKn8DjY2dJ2-WwcL3KK__E0WBJt3I97Nr-m88BSEVl3-P--fsRiEgIP1Co2ulGMbQ\",\"e\":\"AQAB\"},{\"use\":\"sig\",\"kty\":\"RSA\",\"kid\":\"workforceIDP-RS256\",\"alg\":\"RS256\",\"n\":\"ucjZ1pagZuXL4GkFXzG7llZbhPUkl1GzG2vyE0YC3NCvgf2WS67KRH6ck_iMHsWraaPdEcbB8t6ftr0qEXC1ciwVc656Q4V4L_-pxWcD1XMfdiZoViaKyMlq1QzB55XgzM1g7cvgg6_rCmTEmTo3-LUvFd7HxpdHdkYz0U_EUmEB8amz3NxR3LaB-STyxnlsRDrIKmYqDNaPqArdn44INwkGeuJUir0ojw5gdbbazT1NIsuJb2y0zHXuu9ESnyKB8N40ydYe2ECxkdynOQaHt8tCKWhh3F32VwOOuZx34RuVSA_bQraGrduVBd05fEdsPUxq38f1-Z7I5YuokqE_Dw\",\"e\":\"AQAB\"}]}"
                      rules:
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

The section in orange above is the rules section. It defines under what conditions to look for and validate a JWS. The match section defines what prefixes to look for. The slash will look for JWS tokens on every URI path. We can specify quite a few rules to determine how many and which tokens we require and under what circumstances. The <span style="color:blue">[Official JWT Auth documentation](https://www.envoyproxy.io/docs/envoy/latest/api-v2/config/filter/http/jwt_authn/v2alpha/config.proto)</span> specifies several other options on how to craft logic using and, or and any operations as well as other locations where JWS tokens can be located. There isn't as much control over what response to return to clients in the case of a failed authentication. OPA lets the developer change chose the HTTP Status code, include messages in the response body add headers etc. Envoy's built in feature simply returns an HTTP 401 Unauthorized response. 

To see this capability in action, simply run the `demonstrate_envoy_jws_validation.sh` script. The output is similar to the completed solution from the previous lesson. The script also dumps the Envoy logs to show the information that you have available to trouble shoot issues. Below is a screen shot of the log statements that show Envoy extracting the tokens, performing the validation and logging the result. 

<img class="special-img-class" src="https://helpfulbadger.github.io/img/2020/08/06_envoy_jws_log.png" /><br>

# Conclusion

In this getting started example, we successfully validated 3 different JWS tokens in a single request and had flexibility to chose where the tokens were pulled from, how many tokens were required and under what conditions those tokens were needed. In our next getting started guide, we will use Open Policy Agent and our identity tokens to make some more sophisticated authorization decisions. 