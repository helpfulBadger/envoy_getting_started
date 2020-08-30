# STEP 1 build executable binary
FROM golang:1.15 as builder

COPY ./fastMocks.go $GOPATH/src/fastMocks/
WORKDIR $GOPATH/src/fastMocks/

#build the binary
RUN CGO_ENABLED=0 GOOS=linux  GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/fastMocks_linux
RUN CGO_ENABLED=0 GOOS=darwin GOARCH=amd64 go build -a -installsuffix cgo -o /go/bin/fastMocks_darwin

# STEP 2 build a small image
# start from scratch
FROM scratch
# Copy our static executable
COPY --from=builder /go/bin/fastMocks_linux /go/bin/fastMocks_linux
COPY --from=builder /go/bin/fastMocks_darwin /go/bin/fastMocks_darwin
COPY mock_api_data.json /go/bin/config/
COPY ./templates/ /go/bin/templates/
WORKDIR /go/bin/

EXPOSE 8000
CMD ["./fastMocks_linux", "-cf", "/go/bin/config/mock_api_data.json"]