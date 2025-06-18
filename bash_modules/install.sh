#!/usr/bin/env bash

# Environment setup
set -o pipefail
BASH_MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${BASH_MODULES_DIR}/terminal.sh"
source "${BASH_MODULES_DIR}/utils.sh"

export bin_dir="${HOME}/bin"

assert_bin_dir() {
    mkdir -p "${bin_dir}"
}

install_assert() {
    log_heading "assert.sh"
    log_message "Source: https://github.com/lehmannro/assert.sh"
    local target="${bin_dir}/assert.sh"

    log_message "Checking install status"
    if [[ -x "${target}" ]]; then
        log_message "Already installed, nothing to do"
    else
        log_message "Installing assert.sh"
        wget -qO "${target}" https://raw.github.com/lehmannro/assert.sh/v1.1/assert.sh
        chmod +x "${target}"
        log_message "done"
    fi
}

function dependency_check {
    # Define an associative array for mapping string arguments to function names
    declare -A install_list=(["assert"]="install_assert" ["name_a"]="function_a" ["name_b"]="function_b")

    for arg in "$@"; do
        arg_lower=$(to_lower "${arg}")

        if [[ -n "${install_list[${arg_lower}]}" ]]; then
            # Call the function associated with the argument
            "${install_list[${arg_lower}]}"
        else
            # Print an error message
            echo
            log_error "Invalid argument: ${arg}."
            echo
            echo "Valid arguments are:"
            for key in "${!install_list[@]}"; do
                echo " - ${key}"
            done
            exit 1
        fi
    done
}
