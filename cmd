#!/usr/bin/env bash
# Queries my command notes from GitHub

usage() {
    cat <<-EOF
Usage: cmd [filter]

Queries my command notes from GitHub

Optional arguments:
  filter                 String filter for the page
  -h, --help             Show this help message and exit
EOF
}

if [[ "${1}" == '-h' || "${1}" == '--help' || $# -gt 1 ]]; then
    usage
    exit 1
fi

url='https://raw.githubusercontent.com/grantcarthew/notes/main/Commands.md'
if [[ -n "${1}" ]]; then
  curl -s "${url}" | rg -i "${1}"
else
  curl -s "${url}"
fi
