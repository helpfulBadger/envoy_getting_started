FROM golang:1.15 AS builder

WORKDIR /go/src/

RUN git clone https://github.com/rakyll/hey.git
WORKDIR /go/src/hey
#RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go get -u github.com/rakyll/hey
RUN CGO_ENABLED=0 GOOS=linux  GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/hey_linux
RUN CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/hey_darwin

#======================================#
# Final container 
#======================================#
FROM alpine:3.12

# copy executable
COPY --from=builder /go/bin/hey_linux  /

# Define default command.
#ENTRYPOINT ["/hey_linux"]
ENTRYPOINT ["/bin/sh", "-c", "while sleep 86400; do :; done"]
