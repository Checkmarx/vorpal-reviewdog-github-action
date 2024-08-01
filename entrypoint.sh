#!/bin/sh
DATETIME="$(date '+%H:%M')"

set -e

if [ -n "${GITHUB_WORKSPACE}" ] ; then
  cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
fi

# Check if Scan Path is Present
if [ -z "$INPUT_SOURCE_PATH" ]; then
    echo "${DATETIME} - ERR input path can't be empty"
    exit 1
else
   INPUT_SOURCE_PATH=$(echo $INPUT_SOURCE_PATH | sed -e 's/^"//' -e 's/"$//')
   INPUT_PATH_PARAM="-s $INPUT_SOURCE_PATH"
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# Scan Vorpal
echo "${DATETIME} - INF : about to scan file $INPUT_SOURCE_PATH"
echo "${DATETIME} - INF : vorpal command $INPUT_PATH_PARAM $RESULTS_FILE_PARAM"
/app/bin/vorpal $INPUT_PATH_PARAM -r result.errorformat

# Reviewdog
echo "${DATETIME} - INF : Reviewdog executing on version $(reviewdog -version)"
cat result.errorformat | reviewdog -efm '%f:%l:%c:%m' \
                                   -name="Vorpal" \
                                   -reporter="${INPUT_REPORTER:-github-pr-check}" \
                                   -filter-mode="${INPUT_FILTER_MODE}" \
                                   -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
                                   -level="${INPUT_LEVEL}" \
                                   ${INPUT_REVIEWDOG_FLAGS}