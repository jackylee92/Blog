FROM golang:1.13.5

MAINTAINER jackylee92@139.com

ADD tarsp /usr/local/bin
RUN set -ex \
    && chmod u+x /usr/local/bin/tarsp \
    && mkdir -p /local/Package \
    && cp /usr/local/go/bin/go /bin/ \
    && ln -s /go/src /local/Code \
    && mkdir -p /etc/dev \
