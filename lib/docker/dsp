#!/usr/bin/env bash

usage() {
    echo 'Usage: dsp'
    echo
    echo 'Runs the "docker system prune --all" command to remove all containers and images'
    echo 'Does not force the removal and will ask for confirmation'
    echo
    echo 'Optional arguments:'
    echo '  -h, --help             Show this help message and exit'
}

if [[ $# -gt 0 ]]; then
    usage
    exit 1
fi

docker system prune --all