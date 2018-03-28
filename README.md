# docker-nipapd
Docker stack-ready images for nipapd

## nipapd

### Configuration

| Variable         | Description                           | Default   |
+------------------+---------------------------------------+-----------+
| `LISTEN_ADDRESS` | address on which nipapd should listen | `0.0.0.0` |
| `LISTEN_PORT`    | port on which nipapd should listen    | `1337`    |
| `SYSLOG`         | true / false enable syslog?           | `false`   |
| `DB_HOST`        | host where database is running        | -         |
| `DB_PORT`        | port of database                      | `5432`    |
| `DB_NAME`        | name of database                      | -         |
| `DB_USERNAME`    | username to authenticate to database  | -         |
| `DB_PASSWORD`    | password to authenticate to database  | -         |
| `DB_SSLMODE`     | require ssl?                          | `disable` |
| `NIPAP_USERNAME` | name of account to create             | -         |
| `NIPAP_PASSWORD` | password of account to create         | -         |

#### Secret support

`DB_USERNAME`, `DB_PASSWORD`, `NIPAP_USERNAME` and `NIPAP_PASSWORD` all have a
corresponding `var_FILE` environment variable that can be used to retrieve the
desired contents from a file, rather than directly passing it via the docker
command line.

For use with docker secrets, one could use
`NIPAP_PASSWORD_FILE=/run/secrets/nipap-pw` for example.

#### Initialization script support

Every executable file in `/nipap/docker-init.d/` will be executed to allow further
customization of the container during startup. Beware that these are executed on
every container start, so they should be idempotent.

If your script must run only once, you should use a marker file within a persisted
volume like `/etc/nipap/`.

### Persistence

`/etc/nipap/` is exposed via docker volume by default. As it contains both the
configuration data and the account database.

Beware that changes to the configuration are overwritten during container
startup. Also, while additional users can be created, the user account supplied
via `NIPAP_USERNAME` will always be created or updated with the current password.
