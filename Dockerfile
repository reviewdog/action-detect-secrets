FROM python:3.11.4-alpine

ENV REVIEWDOG_VERSION=v0.17.0

RUN set -eux \
    apk --update add git \
    && wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION} \
    && pip install detect-secrets[word_list] \
    && rm -rf /var/cache/apk/*

COPY baseline2rdf.py /usr/local/bin/baseline2rdf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
