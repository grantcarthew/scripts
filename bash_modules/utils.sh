#!/usr/bin/env bash

function to_lower () {
    printf "%s" "${1}" | tr '[:upper:]' '[:lower:]'
}

function to_upper () {
    printf "%s" "${1}" | tr '[:lower:]' '[:upper:]'
}

function join_paths() {
    (IFS=/; echo "$*" | tr -s /)
}

function get_public_ip () {
    curl -s "https://ipinfo.io/ip"
}

function days_between() {
  # Usage: days_between 2000-01-01 "$(date --utc +%F)"
  local start_date
  local end_date
  start_date="$(date -u -d "${1}" +%s)"
  end_date="$(date -u -d "${2}" +%s)"
  local diff="$(( (end_date - start_date) / 86400 ))"
  echo "${diff}"
}
