FROM envoyproxy/envoy:v1.15-latest

COPY entrypoint.sh /
RUN chmod 500 /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
