FROM golang:1.22-alpine AS builder

RUN apk add --no-cache bash gcc musl-dev linux-headers git

WORKDIR /go/src/github.com/btbytes/gocardamom
ADD . .
RUN go build -o ./build/server ./cmd/main.go

FROM alpine:3.20

RUN apk update
RUN apk upgrade
RUN apk add --no-cache ca-certificates tzdata

COPY --from=builder /go/src/github.com/btbytes/gocardamom/build/server /usr/bin/server

ENTRYPOINT ["/usr/bin/server"]
