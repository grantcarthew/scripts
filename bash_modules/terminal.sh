#!/usr/bin/env bash

# Log Functions for Bash Scripts
# -------------------------------
# The log_* functions in this script all send output to stderr (>&2).
# This allows the script to log messages without interfering with the standard output of the script.
# Meaning, if you have a script that is required to return a value,
# you can still use the log functions to log messages without affecting the output of the script.

# Environment setup
BASH_MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

# Import colours if not already done
if [[ -z "${NORMAL}" ]]; then
  if [[ ! -f "${BASH_MODULES_DIR}/colours.sh" ]]; then
    echo "ERROR: colours.sh module not found at ${BASH_MODULES_DIR}" >&2
    return 1
  fi
  source "${BASH_MODULES_DIR}/colours.sh"
fi

export ERASE_LINE='\033[2K'

# Non text
# -----------------------------------------------------------------------------
function log_line() {
  # Usage: log_line [character] [length]
  # Defaults character: '─' (U+2500) length: 80
  local length=80
  local char="─"

  if [[ -n "${1}" ]]; then
    char="${1}"
  fi

  if [[ -n "${2}" ]]; then
    length="${2}"
  fi

  # Create a string of repeated characters (supports multi-byte Unicode)
  local line
  printf -v line '%*s' "${length}" ''
  printf "${BOLD}${MAGENTA}%s${NORMAL}\n" "${line// /${char}}" >&2
}

function log_fullline() {
  # Usage: log_fullline [character]
  # Draws a line that fills the entire terminal width
  # Default character: '─' (U+2500)
  local char="─"
  local length=80  # Default fallback length

  if [[ -n "${1}" ]]; then
    char="${1}"
  fi

  # Check if tput is available and get terminal width
  if command -v tput >/dev/null 2>&1; then
    length=$(tput cols)
  fi

  # Create a string of repeated characters spanning terminal width (supports multi-byte Unicode)
  local line
  printf -v line '%*s' "${length}" ''
  printf "${BOLD}${MAGENTA}%s${NORMAL}\n" "${line// /${char}}" >&2
}

# Text
# -----------------------------------------------------------------------------
function log_title() {
  # Usage: log_title <text>
  # Displays a bold green title with a full-width double line separator

  printf "\n ${BOLD}${GREEN}%s${NORMAL}\n" "$@" >&2
  log_fullline "═"
}

function log_heading() {
  # Usage: log_heading <text>
  # Displays a bold green heading with a single line separator
  printf "\n ${BOLD}${GREEN}%s${NORMAL}\n" "$@" >&2
  log_line "─"
}

function log_subheading() {
  # Usage: log_subheading <text>
  # Displays a bold green subheading with a line matching its length
  printf "\n ${BOLD}${GREEN}%s${NORMAL}\n" "$@" >&2
  local title="$*"
  local length=${#title}
  if [[ ${length} -lt 1 ]]; then
    length=30
  fi
  log_line "─" "$((length + 2))"
}

function log_sectionheading() {
  # Usage: log_sectionheading <text>
  # Displays a bold yellow section heading with a double line separator
  printf "\n ${BOLD}${YELLOW}%s${NORMAL}\n" "$@" >&2
  log_line "═"
}

function log_message() {
  # Usage: log_message <text>
  # Prints a normal message to stderr
  printf "${NORMAL}%s${NORMAL}\n" "$@" >&2
}

function log_messagewithdate() {
  # Usage: log_messagewithdate <text>
  # Prints a message with UTC timestamp prefix
  # Handle the case where date doesn't support --utc flag (macOS)
  local timestamp
  if date --utc +%FT%T >/dev/null 2>&1; then
    timestamp=$(date --utc +%FT%T)
  else
    # macOS alternative
    timestamp=$(date -u +%FT%T)
  fi

  printf "${CYAN}%s: ${NORMAL}%s${NORMAL}\n" "${timestamp}" "$@" >&2
}

function log_newline() {
  # Usage: log_newline
  # Inserts an empty line
  echo "" >&2
}

function log_sameline() {
  # Usage: log_sameline <text>
  # Updates text on the current line, erasing previous content
  printf "\r${ERASE_LINE}${NORMAL}%s${NORMAL}" "$@" >&2
}

function log_clearline() {
  # Usage: log_clearline
  # Clears the current line without printing anything
  # shellcheck disable=SC2059
  printf "\r${ERASE_LINE}" >&2
}

function log_warning() {
  # Usage: log_warning <text>
  # Prints a yellow warning message
  printf "${YELLOW}%s${NORMAL}\n" "$@" >&2
}

function log_error() {
  # Usage: log_error <text>
  # Prints a red error message
  printf "${RED}%s${NORMAL}\n" "$@" >&2
}

function log_success() {
  # Usage: log_success <text>
  # Prints a message with a green checkmark (✔)
  printf " ${GREEN}✔ %b${NORMAL}\n" "$@" >&2
}

function log_failure() {
  # Usage: log_failure <text>
  # Prints a message with a red cross (✖)
  printf " ${RED}✖ %b${NORMAL}\n" "$@" >&2
}

# Object
# -----------------------------------------------------------------------------
function log_json() {
  # Usage: log_json <json_data>
  # Pretty-prints JSON data using jq
  if [[ ${#} -lt 1 ]]; then
    log_warning "WARNING: log_json requires JSON data and there was none"
    return 0
  fi

  if ! command -v jq >/dev/null 2>&1; then
    log_error "ERROR: 'jq' is not installed but required for log_json"
    return 1
  fi
  echo "${1}" | jq '.' >&2
}

function log_filecontents() {
  if [[ $# -lt 1 ]]; then
    log_warning "WARNING: log_filecontents requires a file path which was not provided" >&2
    log_warning "Usage: log_filecontents <file_path>" >&2
    return 0
  fi

  local file_path="${1}"

  if [[ ! -f "${file_path}" ]]; then
    log_warning "WARNING: File '${file_path}' does not exist" >&2
    return 0
  fi

  log_heading "File Contents: '${file_path}'"
  echo "--- start of file ---" >&2
  cat "${file_path}" >&2
  echo "--- end of file ---" >&2
}

# Progress
# -----------------------------------------------------------------------------
function log_percent() {
  # Usage: log_percent <current_number> <total_number>
  # Displays a percentage completion counter
  if [[ ${#} -lt 2 ]]; then
    log_error "ERROR: log_percent requires current and total numbers"
    return 1
  fi

  local current="${1}"
  local total="${2}"

  # Validate inputs are numeric
  if ! [[ "${current}" =~ ^[0-9]+$ ]] || ! [[ "${total}" =~ ^[0-9]+$ ]]; then
    log_error "ERROR: log_percent requires numeric arguments"
    return 1
  fi

  # Avoid division by zero
  if [[ "${total}" -eq 0 ]]; then
    log_error "ERROR: Total cannot be zero"
    return 1
  fi

  # Check for awk dependency
  if ! command -v awk >/dev/null 2>&1; then
    log_error "ERROR: 'awk' is not installed but required for log_percent"
    return 1
  fi

  local percent_complete
  percent_complete=$(awk "BEGIN {printf \"%d\", (${current}/${total})*100}")
  printf "\033[K${CYAN}Processing:${NORMAL} %s%%\r" "${percent_complete}" >&2
}

function log_progressbar() {
  # Usage: log_progressbar <current_number> <total_number> [bar_length]
  # Shows a visual progress bar with percentage
  if [[ ${#} -lt 2 ]]; then
    log_error "ERROR: log_progressbar requires current and total numbers"
    return 1
  fi

  local current="${1}"
  local total="${2}"
  local bar_length="${3:-50}"  # Default bar length of 50

  # Validate inputs are numeric
  if ! [[ "${current}" =~ ^[0-9]+$ ]] || ! [[ "${total}" =~ ^[0-9]+$ ]]; then
    log_error "ERROR: log_progressbar requires numeric arguments"
    return 1
  fi

  # Avoid division by zero
  if [[ "${total}" -eq 0 ]]; then
    log_error "ERROR: Total cannot be zero"
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
  # Usage: log_spinner <pid> [message]
  # Shows an animated spinner while the process with given PID is running
  if [[ ${#} -lt 1 ]]; then
    log_error "ERROR: log_spinner requires a process ID"
    return 1
  fi

  local pid="${1}"  # Process ID to monitor
  local message="${2:-Working...}"
  local spin_chars=("-" "\\" "|" "/")
  local i=0

  # Validate pid exists
  if ! ps -p "${pid}" > /dev/null 2>&1; then
    log_error "ERROR: Process ID '${pid}' not found"
    return 1
  fi

  while ps -p "${pid}" > /dev/null 2>&1; do
    local char="${spin_chars[$i]}"
    printf "\r${ERASE_LINE}${NORMAL}${message} %s" "${char}" >&2
    sleep 0.1
    i=$(( (i+1) % 4 ))
  done

  log_clearline
}

# Delay
# -----------------------------------------------------------------------------
function log_wait() {
  # Usage: log_wait [message] [seconds]
  # Waits for a specified duration, showing a spinner
  local message="${1:-Waiting...}"
  local seconds="${2:-4}"
  local spin_chars=("-" "\\" "|" "/")
  local i=0

  # Validate seconds is a positive integer
  if ! [[ "${seconds}" =~ ^[0-9]+$ ]]; then
    log_error "ERROR: log_wait requires a positive integer for seconds"
    return 1
  fi

  # Run 10 iterations per second (each sleep is 0.1s)
  local iterations=$((seconds * 10))

  for ((j=0; j<iterations; j++)); do
    local char="${spin_chars[$i]}"
    printf "\r${ERASE_LINE}${NORMAL}${message} %s" "${char}" >&2
    sleep 0.1
    i=$(( (i+1) % 4 ))
  done

  log_clearline
}

function log_pressanykey() {
  # Usage: log_pressanykey [message]
  # Prompts the user to press any key to continue
  local message="${1:-Press any key to continue...}"
  printf "${NORMAL}%s" "${message}" >&2
  read -n 1 -s -r
  log_newline
}

# Completion
# -----------------------------------------------------------------------------
function log_done() {
  # Usage: log_done
  # Prints a completion message with a line and success checkmark
  log_fullline
  log_success "Done"
}
