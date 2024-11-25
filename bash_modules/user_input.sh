#!/usr/bin/env bash

# Get the directory of the script file
BASH_MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

# Import colours if not already done
if [[ -z "${NORMAL}" ]]; then
  source "${BASH_MODULES_DIR}/colours.sh"
fi

# Function: ask_yes_no_question
#
# Purpose: Asks the user a yes/no question and returns a status based on the response.
# This function displays a prompt to the user and waits for input. It accepts
# variations of 'yes' or 'no' (e.g., 'y', 'Y', 'yes', 'Yes', etc.).
# If the user inputs a 'yes' variation, the function returns 0 (success).
# For any other input, it returns 1 (failure).
#
# Parameters:
#   $1 - The question to be asked to the user.
#
# Usage:
#   question="Your question here?"
#   if ask_yes_no_question "${question}"; then
#     echo "User answered yes."
#   else
#     echo "User answered no."
#   fi
#
# Supports: Bash 3.2.57
function ask_yes_no_question() {
  read -rp "${1} (y/n) " response
  case "${response}" in
    [yY]|[yY][eE][sS])
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

# Function: numbered_choice_menu
#
# Purpose: Gets user input for a selection from a numbered menu.
# It reads the user's choice, validates it against the menu items,
# and returns the selected item.
#
# Parameters:
#   menu_items - A nameref to an array containing menu items.
#
# Usage:
#   user_choice=$(numbered_choice_menu array_name)
#
# Note: The array is passed by reference.
# The function uses the CYAN and NORMAL variables for color formatting.
#
# Supports: Bash 3.2.57
function numbered_choice_menu() {
  local menu_items_ref="${1}"
  local choice
  local i=0

  eval "local menu_size=\${#${menu_items_ref}[@]}"
  # shellcheck disable=SC2154
  while [ "${i}" -lt "${menu_size}" ]; do
    eval "local item=\${${menu_items_ref}[$i]}"
    echo "[${CYAN}$((i + 1))${NORMAL}] ${item}" >&2
    ((i++))
  done

  while true; do
    read -rp "Enter your choice (${CYAN}1-$menu_size${NORMAL}): " choice
    if [[ "${choice}" =~ ^[0-9]+$ ]] && (( choice >= 1 && choice <= menu_size )); then
      eval "echo \${${menu_items_ref}[$((choice - 1))]}"
      break
    else
      echo "Invalid selection. Please try again." >&2
    fi
  done
}
