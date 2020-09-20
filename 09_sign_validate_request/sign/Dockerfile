FROM openpolicyagent/opa:0.23.0-envoy

COPY ./policy.rego /config/policy.rego
RUN chmod go+r /config/policy.rego
#CMD /usr/local/bin/envoy -c /etc/front-envoy.yaml --service-cluster front-proxy
