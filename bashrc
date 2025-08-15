# shellcheck disable=SC2148
# This Bash run command file is for sourcing in your .bashrc file
# source "${HOME}/bin/scripts/bashrc"

#-----------------------------------------------------------------
# Key bindings for AI assistance
#-----------------------------------------------------------------
function __get_clihelp() {
    if [[ -n "${READLINE_LINE}" ]]; then
        # Show generating message briefly
        printf "\rGenerating..." >/dev/tty
        READLINE_LINE="$(get-clihelp "${READLINE_LINE}")"
        READLINE_POINT="${#READLINE_LINE}"
        # Clear the generating message
        printf "\r\033[K" >/dev/tty
    fi
}

function __get_definition() {
    if [[ -n "${READLINE_LINE}" ]]; then
        local -r line_content="${READLINE_LINE}"

        # Clear the current command line
        READLINE_LINE=""
        READLINE_POINT=0

        # Print a newline, then run the command, sending all output to the terminal
        {
            printf "\n"
            get-definition "${line_content}"
            printf "\n"
        } >/dev/tty
    fi
}

bind -x '"\C-h": __get_clihelp'
bind -x '"\C-d": __get_definition'
