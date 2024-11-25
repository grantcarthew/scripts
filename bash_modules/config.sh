#!/usr/bin/env bash

function get_config_path() {
    config_path="${HOME}/.config/bin_config"
    if [[ ! -f ${config_path} ]]; then
      echo "The ${config_path} file is missing."
      echo "Please run 'set-config' to create it."
      exit 1
    fi
    printf "%s" "${config_path}"
}

function get_config_github_repo_path() {
    jq -r '.github_repo_path' "$(get_config_path)"
}

function get_config_first_name() {
    jq -r '.first_name' "$(get_config_path)"
}

function get_config_last_name() {
    jq -r '.last_name' "$(get_config_path)"
}

function get_config_email_prefix() {
    jq -r '.email_prefix' "$(get_config_path)"
}
