#!/usr/bin/env bash

function open_url() {
  local url="${1}"
  if [[ "$(uname -a)" == *"WSL2"* ]]; then
    # shellcheck disable=SC2034
    cmdOut=$(cmd.exe /c start "${url}" 2>&1)
    return
  fi
  if command -v firefox >/dev/null; then
    firefox "${url}"
    return
  fi
  if command -v xdg-open >/dev/null; then
    xdg-open "${url}"
    return
  fi
  if command -v x-www-browser >/dev/null; then
    x-www-browser "${url}"
    return
  fi
  if command -v gnome-open >/dev/null; then
    gnome-open "${url}"
    return
  fi
  if command -v open >/dev/null; then
    open "${url}"
    return
  fi
  echo "Could not detect any web browser to open the URL!"
}

function send_to_clipboard() {
  local text="${1}"
  if command -v xclip >/dev/null; then
    echo "${text}" | xclip -selection clipboard
    return 0
  fi
  if command -v pbcopy >/dev/null; then
    echo "${text}" | pbcopy
    return 0
  fi
  if command -v xsel >/dev/null; then
    echo "${text}" | xsel --clipboard --input
    return 0
  fi
  if command -v wl-copy >/dev/null; then
    echo "${text}" | wl-copy
    return 0
  fi
  return 1
}