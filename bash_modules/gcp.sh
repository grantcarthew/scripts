#!/usr/bin/env bash

# Google Cloud Platform Module
# -----------------------------------------------------------------------------
# This Bash script contains GCP helper functions
#

# Environment setup
set -o pipefail

function is_gcloud_authenticated() {
  local output
  output="$(gcloud auth list 2>&1)"
  
  if [[ "${output}" == *"No credentialed accounts"* ]]; then
    echo "No credentialed accounts found." >&2
    return 1
  fi
  
  echo "Credentialed accounts found." >&2
  return 0
}
