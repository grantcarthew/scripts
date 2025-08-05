#!/usr/bin/env bash

# Key-Value Settings File Management
# -----------------------------------------------------------------------------
# Provides a simple key-value store using a plain text file.
# Values are stored as quoted strings to handle special characters and newlines.
# The user's settings file is located at ~/.config/scripts/settings.conf.
# Default values are sourced from settings-defaults.conf in the same directory as this script.

SETTINGS_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

# Dependency check
if ! command -v rg >/dev/null 2>&1; then
  echo "ERROR: settings.sh requires RipGrep (rg) but it's not installed" >&2
  echo "Install with: brew install ripgrep" >&2
  return 1 2>/dev/null || exit 1
fi

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
  printf "%s" "${SETTINGS_DIR}/settings-defaults.conf"
}

function settings_get() {
  local key="${1}"
  local user_settings_file
  user_settings_file="$(settings_get_path)"
  _settings_ensure_file_exists "${user_settings_file}"

  # Extract value from user settings file
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
  ' "${user_settings_file}")

  if [[ -n "${value}" ]]; then
    printf "%s" "${value}"
    return
  fi

  # Fall back to defaults file if key not found in user settings
  local defaults_settings_file
  defaults_settings_file="$(settings_get_defaults_path)"
  if [[ -f "${defaults_settings_file}" ]]; then
    local default_value
    default_value=$(awk -F= -v key="${key}" '
      $1 == key {
        val = substr($0, length(key) + 2)
        if (val ~ /^".*"$/) {
          val = substr(val, 2, length(val) - 2)
        }
        print val
        exit
      }
    ' "${defaults_settings_file}")
    if [[ -n "${default_value}" ]]; then
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
  rg -v "^${key}=" "${settings_file}" > "${temp_file}" || true
  printf '%s="%s"\n' "${key}" "${escaped_value}" >> "${temp_file}"
  mv "${temp_file}" "${settings_file}"
}

function settings_delete() {
  local key="${1}"
  local settings_file
  settings_file="$(settings_get_path)"

  if [[ ! -f "${settings_file}" ]]; then
    return
  fi

  # Only modify the file if the key exists
  if rg -q "^${key}=" "${settings_file}"; then
    local temp_file
    temp_file=$(mktemp)
    rg -v "^${key}=" "${settings_file}" > "${temp_file}"
    mv "${temp_file}" "${settings_file}"
  fi
}

function settings_list() {
  local settings_file
  settings_file="$(settings_get_path)"
  if [[ ! -f "${settings_file}" ]]; then
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
  done < "${settings_file}"
}
