#!/bin/bash

function waitLatestJob() {
  jobOutput=$(bq ls -j "$1")
  jobId=$(echo "$jobOutput" | grep RUNNING | head -n 1 | awk '{print $1}')
  now=$(date +"%T")
  if [ -z "$jobId" ]; then
    echo "$now: No job found"
  else
    echo "$now Found new job: $jobId, start waiting..."
    bq wait "$jobId"
    echo "$now Query complete"
    osascript -e 'display notification "Query completed" with title "BigQuery" sound name "Glass"'
  fi
  sleep 0.5
}

echo "Check BigQuery job created by:"
gcloud config list | grep account

while true; do waitLatestJob "$1"; done
