FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
ENV HTTP_PORT 8086
ENV MAX_MEMORY 512M
ENV YAML_CONF /config.yaml
ARG VARNISH_VERSION=6.0

ADD scripts /scripts

RUN /scripts/install.sh

ADD default.vcl /etc/varnish/default.vcl

ENTRYPOINT ["/scripts/run.sh"]
