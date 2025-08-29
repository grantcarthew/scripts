#!/usr/bin/env bash

# Google Cloud Platform Module
# -----------------------------------------------------------------------------
# This Bash script contains GCP helper functions
#

# Environment setup
set -o pipefail

function is_gcloud_authenticated() {
  if command -v gcloud >/dev/null && \
     gcloud auth print-access-token --quiet &>/dev/null; then
    return 0
  fi
  return 1
}
