FROM python:3-stretch

RUN apt-get update \
 && apt-get install -y --no-install-recommends \
    bash-completion python3-docutils man \
 && pip --no-input install envtpl \
 && rm -rf /var/lib/apt/lists/*

COPY nipap/nipap-cli /nipap
COPY entrypoint-cli.sh /nipap/entrypoint.sh
COPY nipaprc-cli /nipap/nipaprc
WORKDIR /nipap
RUN pip --no-input install -r requirements.txt \
 && python setup.py install

ENV NIPAP_PORT 1337

ENTRYPOINT ["/nipap/entrypoint.sh"]
CMD ["bash"]
