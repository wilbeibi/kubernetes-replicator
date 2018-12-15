FROM golang:1.11-alpine as build

RUN apk add --no-cache git build-base && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories && \
    apk add --no-cache upx

ADD . /src
ENV GO111MODULE=on
RUN cd /src && CGO_ENABLED=0 GOOS=linux go build -o replicator .

FROM scratch
MAINTAINER Hongyi Shen <wilbeibi@gmail.com>

COPY --from=build /src/replicator /replicator
CMD ["/replicator"]