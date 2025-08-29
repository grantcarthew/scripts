#!/usr/bin/env bash

# Environment setup
set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
MODULES_DIR="$(cd "${SCRIPT_DIR}/.." || exit 1; pwd)/bash_modules"
source "${MODULES_DIR}/terminal.sh"

function print_usage() {
  cat <<EOF
Usage: $(basename "$0")

Tests all functions of the terminal.sh module with visual output.
All outputs are sent to stderr so they don't interfere with any redirection.

Optional arguments:
  -h, --help        Show this help message and exit
EOF
}

if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
  print_usage
  exit 0
fi

# Helper function to describe and demonstrate a function
function test_function() {
  local func_name="$1"
  local description="$2"
  shift 2

  # Use custom styling for test function heading to make them stand out
  printf "\n ${BOLD}${CYAN}▶ TEST: %s${NORMAL}\n" "${func_name}" >&2
  length=$(tput cols)
  printf "${BOLD}${BLUE}%*s${NORMAL}\n" "${length}" '' | tr ' ' "#" >&2
  log_message "Description: ${description}"
  log_message "Output:"
  log_newline

  # Execute the function with all remaining parameters
  "$@"

  log_newline
  log_message "Press Enter to continue..."
  read -r
}

log_title "TERMINAL MODULE TEST SUITE"
log_message "This test script demonstrates all functions available in the terminal.sh module."
log_message "Press Enter after each test to proceed to the next one."
log_newline
read -r

# Test line drawing functions
test_function "log_line" "Draws a line with specified character and length (Default: 80)" \
  log_line

test_function "log_line (custom)" "Draws a line with custom character and length of 40" \
  log_line "*" 40

test_function "log_fullline" "Draws a line that fills the terminal width" \
  log_fullline

test_function "log_fullline (custom)" "Draws a full-width line with custom character" \
  log_fullline "*"

# Test heading functions
test_function "log_title" "Displays a title with a full width double line below" \
  log_title "This is a Main Title"

test_function "log_title (empty)" "Handles empty title gracefully" \
  log_title

test_function "log_heading" "Displays a heading with a single line below" \
  log_heading "This is a Heading"

test_function "log_heading (empty)" "Handles empty heading gracefully" \
  log_heading

test_function "log_subheading" "Displays a subheading with line matching text length" \
  log_subheading "This is a Subheading"

test_function "log_subheading (empty)" "Handles empty subheading gracefully" \
  log_subheading

test_function "log_sectionheading" "Displays a yellow section heading" \
  log_sectionheading "This is a Section Heading in Yellow"

test_function "log_sectionheading (empty)" "Handles empty section heading gracefully" \
  log_sectionheading

# Test basic message functions
test_function "log_message" "Displays a normal message" \
  log_message "This is a regular message without any formatting."

test_function "log_message (empty)" "Handles empty message gracefully" \
  log_message

test_function "log_messagewithdate" "Displays a message with timestamp" \
  log_messagewithdate "This message includes an ISO-8601 timestamp."

test_function "log_messagewithdate (empty)" "Handles empty message gracefully" \
  log_messagewithdate

test_function "log_newline" "Inserts an empty line" \
  log_message "Text before newline" \
  log_newline \
  log_message "Text after newline"

# Test line update functions
export -f log_sameline
export -f log_newline
test_function "log_sameline" "Updates text on the same line" \
  bash -c 'for i in {1..5}; do log_sameline "Processing item $i..."; sleep 1; done; log_newline'

test_function "log_sameline (empty)" "Handles empty message gracefully" \
  log_sameline

export -f log_clearline
export -f log_message
test_function "log_clearline" "Clears the current line" \
  bash -c 'log_sameline "This line will be cleared in 4 seconds..."; sleep 4; log_clearline; log_message "Line was cleared!"'

# Test status message functions
test_function "log_warning" "Displays a warning message in yellow" \
  log_warning "This is a warning message."

test_function "log_warning (empty)" "Handles empty warning gracefully" \
  log_warning

test_function "log_error" "Displays an error message in red" \
  log_error "This is an error message."

test_function "log_error (empty)" "Handles empty error message gracefully" \
  log_error

test_function "log_success" "Displays a success message with checkmark" \
  log_success "Operation completed successfully!"

test_function "log_success (empty)" "Handles empty success message gracefully" \
  log_success

test_function "log_failure" "Displays a failure message with X mark" \
  log_failure "Operation failed!"

test_function "log_failure (empty)" "Handles empty failure message gracefully" \
  log_failure

# Test data display functions
test_function "log_json" "Formats and displays JSON data" \
  log_json '{"name":"John","age":30,"city":"New York"}'

test_function "log_json (no data)" "Handles missing JSON data gracefully" \
  log_json

# Test file contents display
# Create a temporary file for testing
TEMP_FILE="$(mktemp)"
echo "This is a test file content" > "${TEMP_FILE}"
echo "with multiple lines" >> "${TEMP_FILE}"

test_function "log_filecontents" "Displays the contents of a file" \
  log_filecontents "${TEMP_FILE}"
rm "${TEMP_FILE}"

test_function "log_filecontents (nonexistent)" "Shows warning for nonexistent file" \
  log_filecontents "/path/to/nonexistent/file"

test_function "log_filecontents (missing argument)" "Shows usage message when missing file path" \
  log_filecontents

# Create a temporary environment without jq to test dependency check
test_function "log_json (no jq)" "Shows error when jq is not available" \
  bash -c 'function command() { if [[ $2 == "jq" ]]; then return 1; fi; }; export -f command; source "'"${MODULES_DIR}"'/terminal.sh"; log_json "{}"'

# Test progress indicator functions
export -f log_percent
test_function "log_percent" "Shows a percentage progress indicator" \
  bash -c 'for i in {1..10}; do log_percent $i 10; sleep 0.5; done; log_newline'

test_function "log_percent (invalid input)" "Shows error message for non-numeric input" \
  log_percent "abc" 10

test_function "log_percent (zero divisor)" "Shows error message for division by zero" \
  log_percent 5 0

export -f log_progressbar
test_function "log_progressbar" "Shows a progress bar indicator" \
  bash -c 'for i in {0..20}; do log_progressbar $i 20 40; sleep 0.2; done; log_newline'

test_function "log_progressbar (missing args)" "Shows error message for missing arguments" \
  log_progressbar

test_function "log_progressbar (invalid input)" "Shows error message for non-numeric input" \
  log_progressbar "abc" 10

test_function "log_progressbar (zero divisor)" "Shows error message for division by zero" \
  log_progressbar 5 0

# Test process monitoring functions
export -f log_spinner
export -f log_success
export -f log_error
test_function "log_spinner" "Shows a spinner while a process runs" \
  bash -c 'sleep 5 & log_spinner $! "Processing data"; log_success "Process complete"'

test_function "log_spinner (no PID)" "Shows error for missing PID" \
  log_spinner

test_function "log_spinner (invalid PID)" "Shows error for invalid PID" \
  log_spinner 999999

test_function "log_wait" "Shows a spinner while waiting for specified seconds" \
  log_wait "Waiting for process to complete" 5

test_function "log_wait (invalid seconds)" "Shows error for non-numeric seconds" \
  log_wait "Testing invalid seconds" "abc"

# Test completion function
test_function "log_done" "Shows a completion message with success mark" \
  log_done

log_title "TEST COMPLETE"
log_message "All terminal.sh functions have been demonstrated."
