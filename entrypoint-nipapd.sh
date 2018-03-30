#!/bin/sh

set -e

vars="DB_USERNAME DB_PASSWORD NIPAP_USERNAME NIPAP_PASSWORD"

for var in $vars; do
  eval val="\$$var"
  eval val_file="\$${var}_FILE"
  if [ -z "$val" -a -n "$val_file" ]; then
    export "$var"=$(cat "$val_file")
  fi
done

envtpl --allow-missing /nipap/nipap.conf.dist -o /etc/nipap/nipap.conf

case "$AUTH_DEFAULT" in
    f*|n*|0|skip)
        skip_auth=1
        ;;
    *)
        skip_auth=0
        ;;
esac

. /nipap/backend-config-generator.sh >> /etc/nipap/nipap.conf

/usr/sbin/nipap-passwd create-database
if [ "$skip_auth" = "0" -a -n "$NIPAP_USERNAME" -a -n "$NIPAP_PASSWORD" ]; then
    echo "Creating user '$NIPAP_USERNAME'"
    /usr/sbin/nipap-passwd add --username $NIPAP_USERNAME --name "NIPAP user" --password $NIPAP_PASSWORD --trusted
fi

if [ -d /etc/nipap/docker-init.d ]; then
    for initializer in $(ls /etc/nipap/docker-init.d/); do
        /etc/nipap/docker-init.d/$initializer
    done
fi

exec "$@"
