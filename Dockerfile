FROM golang:1.14-buster AS builder

# Copy sources
WORKDIR $GOPATH/src/github.com/conservis/hello-world

# Now pull in our code
COPY . .

RUN githash=$(git rev-parse --short HEAD 2>/dev/null) \
    && today=$(date +%Y-%m-%d --utc) \
    && CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build \
    -ldflags "-s -w -X main.commit=${githash} -X main.date=${today}" \
    -o /app

# Copy binary to alpine
FROM alpine:3.11
COPY --from=builder /app /bin/hello-world

USER 2000:2000

ENTRYPOINT ["/bin/hello-world"]
