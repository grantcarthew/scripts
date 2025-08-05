#!/usr/bin/env bash
# Copies my AI Prompts from GitHub into the local clipboard

# Environment setup
set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${SCRIPT_DIR}/bash_modules/terminal.sh"
source "${SCRIPT_DIR}/bash_modules/desktop.sh"

function print_usage() {
  cat <<EOF
Usage: $(basename "$0") [file_filter] [-h]

Copies Grant Carthew's AI Prompts from GitHub into the local clipboard

Repository: https://github.com/grantcarthew/notes/tree/main

Dependencies:
  curl                For fetching GitHub API data
  jq                  For parsing JSON output
  rg                  For regex matching
  fzf                 For interactive file selection
  OS Dependent:
    - For copying content to the clipboard
    - Linux: xclip or xsel
    - macOS: pbcopy

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

dependencies=(curl jq rg fzf)
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

# Check for GitHub token for authentication
curl_auth_opts=()
if [[ -n "${GITHUB_TOKEN}" ]]; then
  log_message "Using GitHub token for authentication"
  curl_auth_opts=(-H "Authorization: token ${GITHUB_TOKEN}")
fi

file_list=$(curl -s "${curl_auth_opts[@]}" "${api_url}" || {
  log_error "ERROR: Failed to fetch contents from ${api_url}"
  exit 1
})

if [[ "$file_list" == *"API rate limit exceeded"* ]]; then
  log_error "ERROR: GitHub API rate limit exceeded."
  log_error "Please wait a while before trying again or use an authenticated token."
  exit 1
fi

readarray -t files < <(echo "${file_list}" | jq -r '.[] | select(.type == "file" and .name != "README.md") | .name') || exit 1

if [[ -n "$1" ]]; then
  log_message "Filtering for: ${1}"
  readarray -t files < <(printf '%s\n' "${files[@]}" | rg -i "$1")
fi

log_heading "File Selection"

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
  log_message "Select a file using fzf (use arrow keys, type to filter, Enter to select):"
  selected_file=$(printf '%s\n' "${files[@]}" | fzf --height 40% --layout=reverse --border)

  if [[ -z "${selected_file}" ]]; then
    log_error "No file selected. Operation canceled."
    exit 1
  fi

  log_success "Selected: ${selected_file}"
  ;;
esac

log_heading "Downloading Prompt"

raw_url="https://raw.githubusercontent.com/${repo_url}/main/${path}/${selected_file}"
log_message "Fetching from: ${raw_url}"
raw_content="$(curl -s "$raw_url")"

# Check if curl request was successful
if [[ -z "${raw_content}" ]]; then
  log_error "ERROR: Failed to fetch content from ${raw_url}"
  exit 1
fi

log_message "Prompt title: $(echo "${raw_content}" | rg -m 1 '^#')"

log_message "Adding initial response template"
raw_content+="$(
  cat <<EOT


## Initial Response

Respond only once to this message with "I am an expert in {{subject}}, let's get working!"

EOT
)"

# If we are outputting to a terminal, copy to clipboard.
if [[ -t 1 ]]; then
  send_to_clipboard "${raw_content}"
  log_success "File contents copied to clipboard!"
else
  echo -n "${raw_content}"
  log_success "File contents written to stdout!"
fi
log_done
