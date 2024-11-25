#!/usr/bin/env bash

usage() {
    echo 'Usage: dcl'
    echo
    echo 'Displays the list of Docker containers including both running and stopped containers'
    echo
    echo 'Optional arguments:'
    echo '  -h, --help             Show this help message and exit'
}

if [[ $# -gt 0 ]]; then
    usage
    exit 1
fi

docker container list --all
