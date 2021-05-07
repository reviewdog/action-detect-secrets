FROM python:3.9.5-slim-buster

ENV REVIEWDOG_VERSION=v0.11.0

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        wget \
    && wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION} \
    && pip install detect-secrets

COPY baseline2rdf.py /usr/local/bin/baseline2rdf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
