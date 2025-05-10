#!/usr/bin/env bash

# Get the directory of the script file
BASH_MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

# Import colours if not already done
if [[ -z "${NORMAL}" ]]; then
  source "${BASH_MODULES_DIR}/colours.sh"
fi

export ERASE_LINE='\033[2K'

function log_line() {
  # Usage: log_line <character> <length>
  # Defaults character: '-' length: 80
  local length=80
  local char="-"
  if [[ -n $1 ]]; then
    char="$1"
  fi
  if [[ -n $2 ]]; then
    length="$2"
  fi
  # shellcheck disable=SC2312
  printf "${BOLD}${MAGENTA}${char}%.0s${NORMAL}" $(seq 1 "${length}") >&2
  echo >&2
}

function log_title() {
  printf "\n ${BOLD}${GREEN}%s${NORMAL}\n" "$@" >&2
  log_line "="
}

function log_heading() {
  printf "\n ${GREEN}${GREEN}%s${NORMAL}\n" "$@" >&2
  log_line "-"
}

function log_subheading() {
  printf "\n ${GREEN}${GREEN}%s${NORMAL}\n" "$@" >&2
  local title="$*"
  local length=${#title}
  log_line "-" "${length}"
}

function log_message() {
  printf "${NORMAL}%s${NORMAL}\n" "$@" >&2
}

function log_message_with_date() {
  printf "${CYAN}%s: ${NORMAL}%s${NORMAL}\n" "$(date --utc +%FT%T)" "$@" >&2
}

function log_same_line() {
  printf "\r${ERASE_LINE}${NORMAL}%s${NORMAL}" "$@" >&2

}

function log_json() {
  echo "${1}" | jq '.' >&2
}

function log_newline() {
  echo "" >&2
}

function log_warning() {
  printf "${YELLOW}%s${NORMAL}\n" "$@" >&2
}

function log_error() {
  printf "${RED}%s${NORMAL}\n" "$@" >&2
}

function log_success() {
    printf " ${GREEN}✔ %b${NORMAL}\n" "${@}" >&2
}

function log_failure() {
    printf " ${RED}✖ %b${NORMAL}\n" "${@}" >&2
}

function log_percent() {
  if [[ $# -lt 2 ]]; then
    printf "Usage: log_percent <current_number> <total_number>\n" >&2
    return;
  fi

  local current="${1}"
  local total="${2}"
  local percent_complete
  percent_complete=$(awk "BEGIN {printf \"%d\", (${current}/${total})*100}")
  # echo -ne "Processing: ${percent_complete}%\r" >&2
  printf "\033[K${CYAN}Processing:${NORMAL} %s%%\r" "${percent_complete}" >&2
}

function log_sameline() {
  printf "${NORMAL}%s${NORMAL}\r" "$@" >&2
}

function log_clearline() {
  # shellcheck disable=SC2059
  printf "\r${ERASE_LINE}" >&2
}

function log_done() {
  log_line
  log_success "Done"
}