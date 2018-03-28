#!/bin/sh

set -x

vars="DB_USERNAME DB_PASSWORD NIPAP_USERNAME NIPAP_PASSWORD"

for var in $vars; do
  eval val="\$$var"
  eval val_file="\$${var}_FILE"
  if [ -z "$val" -a -n "$val_file" ]; then
    export "$var"=$(cat "$val_file")
  fi
done

envtpl --allow-missing /nipap/nipap.conf.dist -o /etc/nipap/nipap.conf

/usr/sbin/nipap-passwd create-database
if [ -n "$NIPAP_USERNAME" -a -n "$NIPAP_PASSWORD" ]; then
    echo "Creating user '$NIPAP_USERNAME'"
    /usr/sbin/nipap-passwd add --username $NIPAP_USERNAME --name "NIPAP user" --password $NIPAP_PASSWORD
fi

if [ -d /etc/nipap/docker-init.d ]; then
    for initializer in $(ls /etc/nipap/docker-init.d/); do
        /etc/nipap/docker-init.d/$initializer
    done
fi

exec /usr/sbin/nipapd --debug --foreground --auto-install-db --auto-upgrade-db --no-pid-file
