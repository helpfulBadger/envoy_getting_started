FROM openpolicyagent/opa:0.23.0-envoy

COPY ./policy.rego /config/policy.rego

WORKDIR /app
ENTRYPOINT ["./opa_envoy_linux_amd64"]
