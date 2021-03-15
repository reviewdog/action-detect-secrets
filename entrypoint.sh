#!/bin/sh

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

detect-secrets --version

detect-secrets scan --all-files --force-use-all-plugins \
    | baseline2rdf \
    | reviewdog -f=rdjson \
        -name="${INPUT_NAME:-detect-secrets}" \
        -filter-mode="${INPUT_FILTER_MODE:-added}" \
        -reporter="${INPUT_REPORTER:-github-pr-check}" \
        -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
        -level="${INPUT_LEVEL}" \
