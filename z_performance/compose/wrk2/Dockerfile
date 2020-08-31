FROM ubuntu:18.04
RUN apt-get update --assume-yes
RUN apt-get install apt-utils --assume-yes
RUN apt-get install openssl --assume-yes
COPY ./wrk2_linux /
ENTRYPOINT ["/bin/bash", "-c", "while sleep 86400; do :; done"]
