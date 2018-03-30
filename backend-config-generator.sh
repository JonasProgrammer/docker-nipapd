#!/bin/sh

PREFIX=AUTH_BACKEND_

backend_vars=$(set | sed -nr "s/$PREFIX([^=]+)=.*$/\1/p" | sort)

last_backend=""

for v in $backend_vars; do
    backend=$(echo "$v" | sed -nr 's/^([^_]+).*$/\1/p')
    var=$(echo "$v" | sed -nr 's/^[^_]+_(.*)$/\1/p')

    eval val="\${${PREFIX}${v}}"

    var_file_trim=$(echo "$var" | sed -nr 's/^(.*)_FILE$/\1/p')
    if [ -n "$var_file_trim" ]; then
        var="$var_file_trim"
        val=$(cat "$val")
    fi

    [ "$last_backend" != "$backend" ] && echo "[auth.backends.${backend}]"
    echo "$var = $val"

    last_backend="$backend"
done
