# docker-nipapd
Docker stack-ready images for nipapd

## nipap-cli

### Configuration

| Variable         | Description                   | Default |
|------------------|-------------------------------|---------|
| `NIPAP_HOST`     | hostname of the nipapd server | -       |
| `NIPAP_PORT`     | port of the nipapd server     | `1337`  |
| `NIPAP_USERNAME` | name of account to use        | -       |
| `NIPAP_PASSWORD` | password of account to use    | -       |

#### Secret support

`NIPAP_USERNAME` and `NIPAP_PASSWORD` all have a corresponding `var_FILE`
environment variable that can be used to retrieve the desired contents from a
file, rather than directly passing it via the docker command line.

For use with docker secrets, one could use
`NIPAP_PASSWORD_FILE=/run/secrets/nipap-pw` for example.
