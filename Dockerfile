#### WARNING!
#### This assumes that the d7 module was previously compiled. Check the .drone.yml
from ubuntu

ENV DEBIAN_FRONTEND noninteractive
ENV VCL_PORT 8086
ENV MAX_MEMORY 512M

RUN apt update;\
    apt -y install curl;\
    apt -y install varnish varnish-modules supervisor ;\
    apt clean ;\
    rm -rf /var/lib/apt/lists/* ;

#COPY docker-fpfis/resources/default.vcl /etc/varnish/default.vcl.template 

COPY libvmod-drupal7/src/.libs/libvmod_drupal7.so /usr/lib/x86_64-linux-gnu/varnish/vmods/libvmod_drupal7.so
COPY libvmod-drupal7/src/.libs/libvmod_drupal7.lai /usr/lib/x86_64-linux-gnu/varnish/vmods/libvmod_drupal7.la
RUN ldconfig -n /usr/lib/x86_64-linux-gnu/varnish/vmods/ 

#COPY eac-eyp-vcl/default.vcl /etc/varnish/eyp.vcl

COPY varnish.conf /etc/supervisor/conf.d/

COPY run.sh /root/run.sh

ENTRYPOINT ["/root/run.sh"]
