#### WARNING!
#### This assumes that the d7 module was previously compiled. Check the .drone.yml
from ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
ENV HTTP_PORT 8081

RUN apt update;\
    apt -y install curl;\
    curl -s https://packagecloud.io/install/repositories/varnishcache/varnish41/script.deb.sh | bash ;\
    apt -y install varnish supervisor ;\
    apt clean ;\
    rm -rf /var/lib/apt/lists/* ;

#COPY docker-fpfis/resources/default.vcl /etc/varnish/default.vcl.template 

COPY libvmod-drupal7/.libs/libvmod_drupal7.so /usr/lib/varnish/vmods/libvmod_drupal7.so
COPY libvmod-drupal7/.libs/libvmod_drupal7.lai /usr/lib/varnish/vmods/libvmod_drupal7.la
RUN ldconfig -n /usr/lib/varnish/vmods 

#COPY eac-eyp-vcl/default.vcl /etc/varnish/eyp.vcl

COPY varnish.conf /etc/supervisor/conf.d/

COPY run.sh /root/run.sh

ENTRYPOINT ["/root/run.sh"]
