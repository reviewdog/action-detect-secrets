FROM python:3.11.0-slim-buster

ENV REVIEWDOG_VERSION=v0.14.1

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        gcc \
        git \
        wget \
    && wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION} \
    && pip install detect-secrets[word_list]

COPY baseline2rdf.py /usr/local/bin/baseline2rdf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
