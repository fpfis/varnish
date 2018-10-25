from ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV HTTP_PORT 8081

RUN apt update;\
    apt -y install curl;\
    curl -s https://packagecloud.io/install/repositories/varnishcache/varnish61/script.deb.sh | bash ;\
    apt -y install varnish supervisor ;\
    apt clean ;\
    rm -rf /var/lib/apt/lists/* ;

COPY docker-fpfis/resources/default.vcl /etc/varnish/default.vcl.template 

COPY eac-eyp-vcl/default.vcl /etc/varnish/eyp.vcl

COPY varnish.conf /etc/supervisor/conf.d/

COPY run.sh /root/run.sh

ENTRYPOINT ["/root/run.sh"]
