# docker-nipapd
Docker stack-ready images for nipapd

## nipapd

### Configuration

| Variable         | Description                           | Default   |
|------------------|---------------------------------------|-----------|
| `LISTEN_ADDRESS` | address on which nipapd should listen | `0.0.0.0` |
| `LISTEN_PORT`    | port on which nipapd should listen    | `1337`    |
| `SYSLOG`         | true / false enable syslog?           | `false`   |
| `DB_HOST`        | host where database is running        | -         |
| `DB_PORT`        | port of database                      | `5432`    |
| `DB_NAME`        | name of database                      | -         |
| `DB_USERNAME`    | username to authenticate to database  | -         |
| `DB_PASSWORD`    | password to authenticate to database  | -         |
| `DB_SSLMODE`     | require ssl?                          | `disable` |
| `AUTH_BACKEND`   | name of auth backend to be used       | `local`   |
| `AUTH_CACHE`     | auth cache timeout in seconds         | `3600`    |
| `NIPAP_USERNAME` | name of account to create (def. auth) | -         |
| `NIPAP_PASSWORD` | password of account (def. auth)       | -         |

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

#### Custom authentication setup

If `AUTH_DEFAULT` is set to `f[alse]`, `0`, `n[o]` or `skip`, the default config
for authentication will not be generated (and `nipap-passwd` will not be executed
by the entrypoint script).

Instead, you have to setup the backend yourself using the following syntax:
`AUTH_BACKEND_x_y` will create `[auth.backends.x]`, if it does not exist and set
the `y` key there to the corresponding value of the variable. Beware that `x` **must
not** contain an underscore!

Variable names ending in `_FILE` will be treated the same way as described in *Secret
support*.

A few examples:
- `AUTH_BACKEND_local_db_path` will set `db_path` in `auth.backends.local`
- `AUTH_BACKEND_remote_ro_group` will set `ro_group` in `auth.backends.remote`
- `AUTH_BACKEND_remote_search_password_FILE` will set `search_password` in
`auth.backends.remote` to the contents of the file
`$AUTH_BACKEND_remote_search_password_FILE`

Also, beware that a `local` auth backend is always required for nipapd to start. Thus
the image also has the following two environment variables set by default:
- `AUTH_BACKEND_local_type` = `SqliteAuth`
- `AUTH_BACKEND_local_db_path` = `/etc/nipap/local_auth.db`
