#!/usr/bin/env bash

set -o pipefail

SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${SCRIPT_DIR}/../../bash_modules/terminal.sh"

dependencies=(terraform jq fd rg entr tflint trivy)
for cmd in "${dependencies[@]}"; do
  if ! command -v "${cmd}" >/dev/null; then
    log_error "ERROR: Missing dependency - '${cmd}'"
    exit 1
  fi
done

TFPLAN_DIR="${SCRIPT_DIR}/.tfplan"

if [[ ! -d "${TFPLAN_DIR}" ]]; then
  mkdir -p "${TFPLAN_DIR}"
fi

function log_tf_title() {
  log_title "${1}"
  tf_version="$(terraform version -json | jq -r '.terraform_version')"
  log_message "Terraform Version: ${tf_version}"
}

function new_tf_plan_file() {
  echo "${TFPLAN_DIR}/$(date +%Y-%m-%d-%H%M%S).tfplan"
}

function get_latest_tf_plan_file() {
  fd "." "${TFPLAN_DIR}" --type f --extension tfplan | tail -n 1
}
