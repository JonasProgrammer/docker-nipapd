FROM python:2-stretch

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    libpq-dev \
    postgresql-client \
    libsqlite3-dev \
 && pip --no-input install envtpl \
 && rm -rf /var/lib/apt/lists/* \
 && echo '#!/bin/sh' >/usr/bin/rst2man \
 && echo 'touch $2' >>/usr/bin/rst2man \
 && chmod +x          /usr/bin/rst2man

COPY nipap/nipap /nipap
COPY entrypoint-nipapd.sh /nipap/entrypoint.sh
WORKDIR /nipap
RUN pip --no-input install -r requirements.txt \
 && python setup.py install

EXPOSE 1337
VOLUME /etc/nipap
ENV LISTEN_ADDRESS=0.0.0.0 LISTEN_PORT=1337 SYSLOG=false DB_PORT=5432 DB_SSLMODE=disable

ENTRYPOINT ["/nipap/entrypoint.sh"]
