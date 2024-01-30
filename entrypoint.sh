#!/bin/sh

cd "${GITHUB_WORKSPACE}" || exit 1

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

detect-secrets --version

git config --global --add safe.directory /github/workspace

if [ -n "${INPUT_BASELINE_PATH}" ]; then
    # When .secrets.baseline is provided, the file is only updated and not written to stdout
    detect-secrets scan ${INPUT_DETECT_SECRETS_FLAGS} --baseline ${INPUT_BASELINE_PATH} ${INPUT_WORKDIR}
    mv ${INPUT_BASELINE_PATH} /tmp/.secrets.baseline
else
    detect-secrets scan ${INPUT_DETECT_SECRETS_FLAGS} ${INPUT_WORKDIR} > /tmp/.secrets.baseline
fi

if [ "${INPUT_SKIP_AUDITED}" = "true" ]; then
    SKIP_AUDITED_FLAG="--skip-audited"
fi
if [ "${INPUT_VERBOSE}" = "true" ]; then
    VERBOSE_FLAG="--verbose"
fi

cat /tmp/.secrets.baseline | baseline2rdf ${SKIP_AUDITED_FLAG} ${VERBOSE_FLAG} \
    | reviewdog -f=rdjson \
        -name="${INPUT_NAME:-detect-secrets}" \
        -filter-mode="${INPUT_FILTER_MODE:-added}" \
        -reporter="${INPUT_REPORTER:-github-pr-check}" \
        -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
        -level="${INPUT_LEVEL}" \
        ${INPUT_REVIEWDOG_FLAGS}
