#!/usr/bin/env bash

if [[ $# -gt 0 ]]; then
    echo "[g]it [s]status"
    echo "git status"
    exit 1
fi

git status
