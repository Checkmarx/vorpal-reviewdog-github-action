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
   IFS=','; set -- $INPUT_SOURCE_PATH; unset IFS
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# Create a file to store all the results
all_results_file="all_results.errorformat"
> "$all_results_file"

# Scan Vorpal for each file
for file in "$@";
do
  echo "${DATETIME} - INF : about to scan file $file"
  echo "${DATETIME} - INF : vorpal command -s $file -r result.errorformat"
  /app/bin/vorpal -s "$file" -r result.errorformat

  # Append the results to the all_results_file
  cat result.errorformat >> "$all_results_file"
done

# Reviewdog
echo "${DATETIME} - INF : Reviewdog executing on version $(reviewdog -version)"
cat "$all_results_file" | reviewdog -efm '%f:%l:%c:%m' \
                                   -name="Vorpal" \
                                   -reporter="${INPUT_REPORTER:-github-pr-check}" \
                                   -filter-mode="${INPUT_FILTER_MODE}" \
                                   -fail-on-error="${INPUT_FAIL_ON_ERROR}" \
                                   -level="${INPUT_LEVEL}" \
                                   ${INPUT_REVIEWDOG_FLAGS}