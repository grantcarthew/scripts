#!/usr/bin/env bash

# Environment setup
set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${SCRIPT_DIR}/bash_modules/terminal.sh"

function print_usage() {
  cat <<EOF
Usage: $(basename "$0") [file_filter] [-h]

Copies Grant Carthew's AI Prompts from GitHub into the local clipboard

Repository: https://github.com/grantcarthew/notes/tree/main

Dependencies:
  curl                For fetching GitHub API data
  jq                  For parsing JSON output
  rg                  For regex matching
  pbcopy              For copying content to the clipboard

Optional arguments:
  file_filter        The file name or part thereof
  -h, --help         Show this help message and exit
EOF
}

if [[ $# -gt 1 || "${1}" == "-h" || "${1}" == "--help" ]]; then
  print_usage
  exit 1
fi

log_title "Grant Carthew's GitHub Prompts"
log_heading "Dependency Check"

dependencies=(curl jq rg pbcopy)
for cmd in "${dependencies[@]}"; do
  if ! command -v "${cmd}" >/dev/null; then
    log_error "ERROR: Missing dependency - '${cmd}'"
    exit 1
  fi
done
log_success "Command-line dependencies installed"

log_heading "Fetching Prompts"

repo_url="grantcarthew/notes"
path="Prompts"
api_url="https://api.github.com/repos/${repo_url}/contents/${path}"

log_message "Fetching from: ${api_url}"

# Get prompt file list
file_list=$(curl -s "${api_url}" || {
  log_error "ERROR: Failed to fetch contents from ${api_url}"
  exit 1
})

if [[ "$file_list" == *"API rate limit exceeded"* ]]; then
  log_error "ERROR: GitHub API rate limit exceeded."
  log_error "Please wait a while before trying again or use an authenticated token."
  exit 1
fi

readarray -t files < <(echo "${file_list}" | jq -r '.[] | select(.type == "file") | .name') || exit 1

# Filter files if an argument is provided
if [[ -n "$1" ]]; then
  log_message "Filtering for: ${1}"
  readarray -t files < <(printf '%s\n' "${files[@]}" | rg -i "$1")
fi

log_heading "File Selection"

# Handle cases based on the number of files after filtering
case ${#files[@]} in
0)
  log_error "No files match your filter."
  exit 1
  ;;
1)
  selected_file="${files[0]}"
  log_success "File: ${selected_file}"
  ;;
*)
  # Display files for selection
  log_message "Available files:"
  for i in "${!files[@]}"; do
    log_message "$((i + 1))) ${files[$i]}"
  done

  # Prompt for file selection with error checking
  while true; do
    read -p "Enter the number of the file you want to copy: " choice
    if [[ ${choice} =~ ^[0-9]+$ && ${choice} -ge 1 && ${choice} -le ${#files[@]} ]]; then
      break
    else
      log_warning "Invalid selection. Please enter a number between 1 and ${#files[@]}."
    fi
  done

  selected_file="${files[$((choice - 1))]}"
  log_success "Selected: ${selected_file}"
  ;;
esac

log_heading "Downloading Prompt"

# Copy selected file to clipboard
raw_url="https://raw.githubusercontent.com/${repo_url}/main/${path}/${selected_file}"
log_message "Fetching from: ${raw_url}"
raw_content="$(curl -s "$raw_url")"
log_message "Prompt title: $(echo "${raw_content}" | rg -m 1 '^#')"

# Add initial response
log_message "Adding initial response template"
raw_content+="$(
  cat <<EOT


## Initial Response

Respond only once to this message with "I am an expert in {{subject}}, let's get working!"

EOT
)"

# Send to clipboard
echo "${raw_content}" | pbcopy
log_success "File contents copied to clipboard!"
log_done
