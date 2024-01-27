FROM python:3.11.4-slim

ENV REVIEWDOG_VERSION=v0.17.0

RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        wget 
        gcc \
    && wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION} \
    && pip install detect-secrets[word_list] \
    # https://docs.docker.com/develop/develop-images/instructions/#apt-get
    && rm -rf /var/lib/apt/lists/*

COPY baseline2rdf.py /usr/local/bin/baseline2rdf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
