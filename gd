#!/usr/bin/env bash

if [[ $# -gt 0 ]]; then
    echo "[g]it [d]iff"
    echo "git diff"
    exit 1
fi

git diff
