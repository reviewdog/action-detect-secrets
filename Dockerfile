FROM python:3.11.4-alpine

ENV REVIEWDOG_VERSION=v0.20.1

RUN  apk --no-cache add git gcc musl-dev 
#musl-dev 
RUN  wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION} 
RUN  pip install detect-secrets[word_list]

COPY baseline2rdf.py /usr/local/bin/baseline2rdf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
