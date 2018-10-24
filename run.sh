#!/bin/sh
set -e

# Get our command to run
export CMD=$@

if [ -z "${CMD}" ]; then
  # As root, let daemon handle the rest
  supervisord -nc /etc/supervisor/supervisord.conf
else
  # TODO : us ref_dir's permissions to use it's UID
  exec ${CMD}
fi
