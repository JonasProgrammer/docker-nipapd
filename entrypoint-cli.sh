#!/bin/sh

set -e

vars="NIPAP_USERNAME NIPAP_PASSWORD"

for var in $vars; do
  eval val="\$$var"
  eval val_file="\$${var}_FILE"
  if [ -z "$val" -a -n "$val_file" ]; then
    export "$var"=$(cat "$val_file")
  fi
done

envtpl --allow-missing /etc/skel/.nipaprc -o /root/.nipaprc
chmod 600 /root/.nipaprc

exec "$@"
