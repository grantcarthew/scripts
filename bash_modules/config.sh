#!/usr/bin/env bash

# Key-Value Config File Management
# -----------------------------------------------------------------------------
# Provides a simple key-value store using a plain text file.
# Values are stored as quoted strings to handle special characters and newlines.
# The user's config file is located at ~/.config/scripts/config.conf.
# Default values are sourced from config-defaults.conf in the same directory as this script.
# Keys are always stored in uppercase for consistency and case-insensitive access.

MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${MODULES_DIR}/utils.sh"

if ! command -v rg >/dev/null 2>&1; then
  echo "ERROR: config.sh requires RipGrep (rg) but it's not installed" >&2
  echo "Install with: brew install ripgrep" >&2
  exit 1
fi

function _config_ensure_file_exists() {
  local config_file="${1}"
  local config_dir
  config_dir="$(dirname "${config_file}")"
  if [[ ! -d "${config_dir}" ]]; then
    mkdir -p "${config_dir}"
  fi
  if [[ ! -f "${config_file}" ]]; then
    touch "${config_file}"
  fi
}

function config_get_path() {
  printf "%s" "${CONFIG_FILE_PATH:-${HOME}/.config/scripts/config.conf}"
}

function config_get_defaults_path() {
  printf "%s" "${CONFIG_DEFAULTS_PATH:-${MODULES_DIR}/config-defaults.conf}"
}

function config_get() {
  local key
  key="$(to_upper "${1}")"
  local user_config_file
  user_config_file="$(config_get_path)"
  _config_ensure_file_exists "${user_config_file}"

  # Extract value from user config file
  local value
  value=$(awk -F= -v key="${key}" '
    $1 == key {
      val = substr($0, length(key) + 2)
      if (val ~ /^".*"$/) {
        val = substr(val, 2, length(val) - 2)
      }
      # Decode in reverse order: special newlines first, then quotes, then backslashes
      gsub(/\\x0A/, "\n", val)  # Decode our special newline sequence
      gsub(/\\"/, "\"", val)
      gsub(/\\\\/, "\\", val)
      print val
      exit
    }
  ' "${user_config_file}")

  if [[ -n "${value}" ]]; then
    printf "%s" "${value}"
    return
  fi

  # Fall back to defaults file if key not found in user config
  local defaults_config_file
  defaults_config_file="$(config_get_defaults_path)"
  if [[ -f "${defaults_config_file}" ]]; then
    local default_value
    default_value=$(awk -F= -v key="${key}" '
      $1 == key {
        val = substr($0, length(key) + 2)
        if (val ~ /^".*"$/) {
          val = substr(val, 2, length(val) - 2)
        }
        # Decode escaped quotes and backslashes from defaults file
        gsub(/\\"/, "\"", val)
        gsub(/\\\\/, "\\", val)
        print val
        exit
      }
    ' "${defaults_config_file}")
    if [[ -n "${default_value}" ]]; then
      config_set "${key}" "${default_value}"
      printf "%s" "${default_value}"
      return
    fi
  fi
  printf ""
}

function config_set() {
  local key
  key="$(to_upper "${1}")"
  local value="${2}"
  local config_file
  config_file="$(config_get_path)"
  _config_ensure_file_exists "${config_file}"

  local temp_file
  temp_file=$(mktemp)

  # Escape quotes and encode newlines for single-line storage
  # Use a special sequence for actual newlines to distinguish from literal \n
  local escaped_value
  escaped_value=$(printf "%s" "${value}" | awk '
    BEGIN { RS = "\n"; ORS = "" }
    {
      gsub(/\\/, "\\\\")   # Escape existing backslashes first
      gsub(/"/, "\\\"")    # Then escape quotes
      if (NR > 1) printf "\\x0A"  # Use \x0A for actual newlines
      printf "%s", $0
    }
  ')

  # Remove existing key and append new value
  rg -v "^${key}=" "${config_file}" > "${temp_file}" || true
  printf '%s="%s"\n' "${key}" "${escaped_value}" >> "${temp_file}"
  mv "${temp_file}" "${config_file}"
}

function config_delete() {
  local key
  key="$(to_upper "${1}")"
  local config_file
  config_file="$(config_get_path)"

  if [[ ! -f "${config_file}" ]]; then
    return
  fi

  # Only modify the file if the key exists
  if rg -q "^${key}=" "${config_file}"; then
    local temp_file
    temp_file=$(mktemp)
    rg -v "^${key}=" "${config_file}" > "${temp_file}"
    mv "${temp_file}" "${config_file}"
  fi
}

function _config_read_and_print() {

  local file_path="${1}"

  if [[ ! -f "${file_path}" ]]; then

    return

  fi



  # Read and decode each key-value pair

  while IFS= read -r line || [[ -n "${line}" ]]; do

    # Skip empty lines or comments

    [[ -z "${line}" || "${line}" =~ ^# ]] && continue



    # Split key and value at the first '=' 

    local key="${line%%=*}"

    local value="${line#*=}"



    # Decode the value for display

    local display_value

    display_value=$(printf "%s" "${value}" | awk '

      {

        if ($0 ~ /^".*"$/) {

          $0 = substr($0, 2, length($0) - 2)

        }

        # Decode in reverse order: special newlines first, then quotes, then backslashes

        gsub(/\\x0A/, "\n")  # Decode our special newline sequence

        gsub(/\\"/, "\"")

        gsub(/\\\\/, "\\")

        print

      }

    ')

    printf '%s="%s"\n' "${key}" "${display_value}"

  done < "${file_path}"

}



function config_list() {

  _config_read_and_print "$(config_get_path)"

}



function config_list_defaults() {

  _config_read_and_print "$(config_get_defaults_path)"

}
