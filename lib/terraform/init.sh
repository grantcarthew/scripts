#!/usr/bin/env bash

set -o pipefail

SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${SCRIPT_DIR}/../../bash_modules/terminal.sh"
source "${SCRIPT_DIR}/../../bash_modules/ai.sh"

function ctrlc_trap() {
  log_newline
  log_warning "Script interrupted. Exiting."
  exit 130
}
trap ctrlc_trap SIGINT

dependencies=(terraform jq fd rg entr tflint trivy terraform-docs)
missing_dependencies=()
for cmd in "${dependencies[@]}"; do
  if ! command -v "${cmd}" >/dev/null; then
    missing_dependencies+=("${cmd}")
  fi
done

if [[ "${#missing_dependencies[@]}" -gt 0 ]]; then
  log_error "ERROR: Missing dependencies:"
  for dep in "${missing_dependencies[@]}"; do
    log_error "  - ${dep}"
  done
  exit 1
fi

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
  echo "${TFPLAN_DIR}/$(date +%Y-%m-%d-%H%M%S)-$(basename "${PWD}").tfplan"
}

function get_latest_tf_plan_file() {
  fd "." "${TFPLAN_DIR}" --type f --extension tfplan | tail -n 1
}
