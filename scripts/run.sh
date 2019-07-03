#!/bin/bash
set -e

[ ! -f "${YAML_CONF}" ] && echo "Please define backends in a yaml and include YAML_CONF" && exit 1

jinja2 /scripts/directors.vcl.jinja2 ${YAML_CONF} > /tmp/directors.vcl

cat  /tmp/directors.vcl

# Get our command to run
export CMD=$@

if [ -z "${CMD}" ]; then
  /usr/sbin/varnishd -f /etc/varnish/default.vcl -a 0.0.0.0:${HTTP_PORT} -s malloc,${MAX_MEMORY} -F $@
else
  exec ${CMD}
fi
