FROM envoyproxy/envoy:v1.15-latest

RUN apt-get update && apt-get -q install -y \
    curl

COPY ./service1-envoy-jaeger.yaml /etc/envoy/service1-envoy-jaeger.yaml
RUN chmod go+r /etc/envoy/service1-envoy-jaeger.yaml
CMD /usr/local/bin/envoy -c /etc/envoy/service1-envoy-jaeger.yaml --service-cluster service1-proxy