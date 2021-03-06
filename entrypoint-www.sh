#!/bin/sh

set -e

vars="WWW_USERNAME WWW_PASSWORD NIPAPD_USERNAME NIPAPD_PASSWORD"

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
if [ "$skip_auth" = "0" -a -n "$WWW_USERNAME" -a -n "$WWW_PASSWORD" ]; then
    echo "Creating user '$WWW_USERNAME'"
    /usr/sbin/nipap-passwd add --username $WWW_USERNAME --name "WWW user" --password $WWW_PASSWORD
fi

if [ -d /etc/nipap/docker-init.d ]; then
    for initializer in $(ls /etc/nipap/docker-init.d/); do
        /etc/nipap/docker-initS.d/$initializer
    done
fi


chown -R nipap-www:nipap-www /var/cache/nipap-www

su --preserve-environment -c "exec $@" nipap-www
