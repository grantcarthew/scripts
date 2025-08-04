#!/usr/bin/env bash

# Key-Value Settings File Management
# ---------------------------------------
# Provides a simple key-value store using a plain text file.
# Values are base64 encoded to handle special characters.
# The user's settings file is located at ~/.config/scripts/settings.conf.
# Default values are sourced from settings-defaults.conf in the same directory as this script.

_SETTINGS_SH_SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

function _settings_ensure_file_exists() {
  local settings_file="${1}"
  local settings_dir
  settings_dir="$(dirname "${settings_file}")"
  if [[ ! -d "${settings_dir}" ]]; then
    mkdir -p "${settings_dir}"
  fi
  if [[ ! -f "${settings_file}" ]]; then
    touch "${settings_file}"
  fi
}

function settings_get_path() {
  printf "%s" "${HOME}/.config/scripts/settings.conf"
}

function settings_get_defaults_path() {
  printf "%s" "${_SETTINGS_SH_SCRIPT_DIR}/settings-defaults.conf"
}

function settings_get() {
  local key="${1}"
  local user_settings_file
  user_settings_file="$(settings_get_path)"
  _settings_ensure_file_exists "${user_settings_file}"

  # Use sed to robustly extract the value after the first '='
  local value
  value=$(sed -n "s/^${key}=//p" "${user_settings_file}")

  if [[ -n "${value}" ]]; then
    if [[ "$(uname)" == "Darwin" ]]; then
      printf "%s" "${value}" | base64 -d
    else
      # Use -w 0 to prevent line wrapping
      printf "%s" "${value}" | base64 --decode
    fi
    return
  fi

  local defaults_settings_file
  defaults_settings_file="$(settings_get_defaults_path)"
  if [[ -f "${defaults_settings_file}" ]]; then
    local default_value
    # In defaults, value is not encoded, but might be quoted
    default_value=$(sed -n "s/^${key}=//p" "${defaults_settings_file}" | sed -e 's/^"//' -e 's/"$//')
    if [[ -n "${default_value}" ]]; then
      # Set it in user's config (which will encode it) and return it
      settings_set "${key}" "${default_value}"
      printf "%s" "${default_value}"
      return
    fi
  fi
  printf ""
}

function settings_set() {
  local key="${1}"
  local value="${2}"
  local settings_file
  settings_file="$(settings_get_path)"
  _settings_ensure_file_exists "${settings_file}"
  local temp_file
  temp_file=$(mktemp)

  local encoded_value
  if [[ "$(uname)" == "Darwin" ]]; then
    encoded_value=$(printf "%s" "${value}" | base64)
  else
    # Use -w 0 to prevent line wrapping
    encoded_value=$(printf "%s" "${value}" | base64 -w 0)
  fi

  # Use grep to remove the old key and append the new one
  grep -v "^${key}=" "${settings_file}" > "${temp_file}"
  printf "%s=%s\n" "${key}" "${encoded_value}" >> "${temp_file}"

  mv "${temp_file}" "${settings_file}"
}

function settings_delete() {
    local key="${1}"
    local settings_file
    settings_file="$(settings_get_path)"

    if [[ ! -f "${settings_file}" ]]; then
        return
    fi

    # Only modify the file if the key actually exists
    if grep -q "^${key}=" "${settings_file}"; then
        local temp_file
        temp_file=$(mktemp)
        # Use grep to filter out the key
        grep -v "^${key}=" "${settings_file}" > "${temp_file}"
        mv "${temp_file}" "${settings_file}"
    fi
}

function settings_list() {
  local settings_file
  settings_file="$(settings_get_path)"
  if [[ ! -f "${settings_file}" ]]; then
    return
  fi

  # Read file line by line robustly
  while IFS= read -r line || [[ -n "$line" ]]; do
      # Skip empty lines or comments
      [[ -z "$line" || "$line" =~ ^# ]] && continue

      # Split key and value at the first '='
      local key="${line%%=*}"
      local value="${line#*=}"

      local decoded_value
      if [[ "$(uname)" == "Darwin" ]]; then
        decoded_value=$(printf "%s" "${value}" | base64 -d)
      else
        decoded_value=$(printf "%s" "${value}" | base64 --decode)
      fi
      printf '%s="%s"\n' "${key}" "${decoded_value}"
  done < "${settings_file}"
}