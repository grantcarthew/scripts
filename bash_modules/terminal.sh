#!/usr/bin/env bash

# Log Functions for Bash Scripts
# -------------------------------
# The log_* functions in this script all send output to stderr (>&2).
# This allows the script to log messages without interfering with the standard output of the script.
# Meaning, if you have a script that is required to return a value,
# you can still use the log functions to log messages without affecting the output of the script.

# Get the directory of the script file
BASH_MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

# Import colours if not already done
if [[ -z "${NORMAL}" ]]; then
  source "${BASH_MODULES_DIR}/colours.sh"
fi

export ERASE_LINE='\033[2K'

function is_gitlab_ci() {
  # Check if running in a GitLab CI environment
  if [[ -n "${CI_JOB_TOKEN}" ]]; then
    return 0
  else
    return 1
  fi
}

function log_line() {
  # Usage: log_line <character> <length>
  # Defaults character: '-' length: 80
  local length=80
  local char="-"
  if [[ -n "${1}" ]]; then
    char="${1}"
  fi
  if [[ -n "${2}" ]]; then
    length="${2}"
  fi
  # Create a string of repeated characters more safely
  printf "${BOLD}${MAGENTA}%*s${NORMAL}\n" "${length}" | tr " " "${char}" >&2
}

function log_title() {
  printf "\n ${BOLD}${GREEN}%s${NORMAL}\n" "$@" >&2
  log_line "="
}

function log_heading() {
  printf "\n ${BOLD}${GREEN}%s${NORMAL}\n" "$@" >&2
  log_line "-"
}

function log_subheading() {
  printf "\n ${BOLD}${GREEN}%s${NORMAL}\n" "$@" >&2
  local title="$*"
  local length=${#title}
  log_line "-" "${length}"
}

function log_sectionheading() {
  printf "\n ${BOLD}${YELLOW}%s${NORMAL}\n" "$@" >&2
  log_line "="
}

function log_message() {
  printf "${NORMAL}%s${NORMAL}\n" "$@" >&2
}

function log_messagewithdate() {
  printf "${CYAN}%s: ${NORMAL}%s${NORMAL}\n" "$(date --utc +%FT%T)" "$@" >&2
}

function log_newline() {
  echo "" >&2
}

function log_sameline() {
  printf "\r${ERASE_LINE}${NORMAL}%s${NORMAL}" "$@" >&2
}

function log_clearline() {
  # shellcheck disable=SC2059
  printf "\r${ERASE_LINE}" >&2
}

function log_warning() {
  printf "${YELLOW}%s${NORMAL}\n" "$@" >&2
}

function log_error() {
  printf "${RED}%s${NORMAL}\n" "$@" >&2
}

function log_success() {
  printf " ${GREEN}✔ %b${NORMAL}\n" "$@" >&2
}

function log_failure() {
  printf " ${RED}✖ %b${NORMAL}\n" "$@" >&2
}

function log_json() {
  if ! command -v jq >/dev/null 2>&1; then
    log_error "Error: 'jq' is not installed but required for log_json"
    return 1
  fi
  echo "${1}" | jq '.' >&2
}

function log_percent() {
  if [[ $# -lt 2 ]]; then
    log_error "Usage: log_percent <current_number> <total_number>"
    return 1
  fi

  local current="${1}"
  local total="${2}"
  
  # Validate inputs are numeric
  if ! [[ "${current}" =~ ^[0-9]+$ ]] || ! [[ "${total}" =~ ^[0-9]+$ ]]; then
    log_error "Error: log_percent requires numeric arguments"
    return 1
  fi
  
  # Avoid division by zero
  if [[ "${total}" -eq 0 ]]; then
    log_error "Error: Total cannot be zero"
    return 1
  fi
  
  # Check for awk dependency
  if ! command -v awk >/dev/null 2>&1; then
    log_error "Error: 'awk' is not installed but required for log_percent"
    return 1
  fi
  
  local percent_complete
  percent_complete=$(awk "BEGIN {printf \"%d\", (${current}/${total})*100}")
  printf "\033[K${CYAN}Processing:${NORMAL} %s%%\r" "${percent_complete}" >&2
}

function log_progressbar() {
  if [[ $# -lt 2 ]]; then
    log_error "Usage: log_progressbar <current_number> <total_number> [bar_length]"
    return 1
  fi

  local current="${1}"
  local total="${2}"
  local bar_length="${3:-50}"  # Default bar length of 50
  
  # Validate inputs are numeric
  if ! [[ "${current}" =~ ^[0-9]+$ ]] || ! [[ "${total}" =~ ^[0-9]+$ ]]; then
    log_error "Error: log_progressbar requires numeric arguments"
    return 1
  fi
  
  # Avoid division by zero
  if [[ "${total}" -eq 0 ]]; then
    log_error "Error: Total cannot be zero"
    return 1
  fi
  
  local percent_complete=$((current * 100 / total))
  local completed_length=$((current * bar_length / total))
  local remaining_length=$((bar_length - completed_length))
  
  # Build progress bar
  local progress_bar="["
  for ((i=0; i<completed_length; i++)); do
    progress_bar+="="
  done
  
  if [[ "${completed_length}" -lt "${bar_length}" ]]; then
    progress_bar+=">"
    remaining_length=$((remaining_length - 1))
    
    for ((i=0; i<remaining_length; i++)); do
      progress_bar+=" "
    done
  fi
  
  progress_bar+="] ${percent_complete}%"
  
  printf "\r${ERASE_LINE}${CYAN}Progress:${NORMAL} %s" "${progress_bar}" >&2
}

function log_spinner() {
  local pid=$1  # Process ID to monitor
  local message="${2:-Working...}"
  local spin_chars=("-" "\\" "|" "/")
  local i=0
  
  while ps -p "${pid}" > /dev/null 2>&1; do
    local char="${spin_chars[$i]}"
    printf "\r${ERASE_LINE}${NORMAL}${message} %s" "${char}" >&2
    sleep 0.1
    i=$(( (i+1) % 4 ))
  done
  
  log_clearline
}

function log_done() {
  log_line
  log_success "Done"
}
