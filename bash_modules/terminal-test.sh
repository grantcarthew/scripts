#!/usr/bin/env bash

# Environment setup
set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
MODULES_DIR="$(cd "${SCRIPT_DIR}/.." || exit 1; pwd)/bash_modules"
source "${MODULES_DIR}/terminal.sh"

function print_usage() {
  cat <<EOF
Usage: $(basename "$0") [--with-errors]

Tests all functions of the terminal.sh module with visual output.
All outputs are sent to stderr so they don't interfere with any redirection.

Optional arguments:
  --with-errors     Include tests for error handling cases
  -h, --help        Show this help message and exit
EOF
}

if [[ "${1}" == "-h" || "${1}" == "--help" ]]; then
  print_usage
  exit 0
fi

if [[ "${1}" == "--with-errors" ]]; then
  INCLUDE_ERRORS=true
fi

# Helper function to describe and demonstrate a function
function test_function() {
  local func_name="$1"
  local description="$2"
  shift 2

  log_heading "Testing: ${func_name}"
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
test_function "log_line" "Draws a line with specified character and length (30)" \
  log_line

test_function "log_line (custom)" "Draws a line with custom character and length" \
  log_line "*" 40

# Test headings
test_function "log_title" "Displays a title with a double line below" \
  log_title "This is a Main Title"

test_function "log_heading" "Displays a heading with a single line below" \
  log_heading "This is a Heading"

test_function "log_subheading" "Displays a subheading with line matching text length" \
  log_subheading "This is a Subheading"

test_function "log_sectionheading" "Displays a yellow section heading" \
  log_sectionheading "This is a Section Heading in Yellow"

# Test message functions
test_function "log_message" "Displays a normal message" \
  log_message "This is a regular message without any formatting."

test_function "log_messagewithdate" "Displays a message with timestamp" \
  log_messagewithdate "This message includes an ISO-8601 timestamp."

test_function "log_newline" "Inserts an empty line" \
  log_message "Text before newline" \
  log_newline \
  log_message "Text after newline"

# Test same line updates
export -f log_sameline
export -f log_newline
test_function "log_sameline" "Updates text on the same line" \
  bash -c 'for i in {1..5}; do log_sameline "Processing item $i..."; sleep 1; done; log_newline'

export -f log_clearline
export -f log_message
test_function "log_clearline" "Clears the current line" \
  bash -c 'log_sameline "This line will be cleared in 4 seconds..."; sleep 4; log_clearline; log_message "Line was cleared!"'

test_function "log_warning" "Displays a warning message in yellow" \
  log_warning "This is a warning message."

test_function "log_error" "Displays an error message in red" \
  log_error "This is an error message."

test_function "log_success" "Displays a success message with checkmark" \
  log_success "Operation completed successfully!"

test_function "log_failure" "Displays a failure message with X mark" \
  log_failure "Operation failed!"

# Test JSON display
test_function "log_json" "Formats and displays JSON data" \
  log_json '{"name":"John","age":30,"city":"New York"}'

# Test progress percentage
export -f log_percent
test_function "log_percent" "Shows a percentage progress indicator" \
  bash -c 'for i in {1..10}; do log_percent $i 10; sleep 0.5; done; log_newline'

test_function "log_percent (invalid input)" "Shows error message for non-numeric input" \
  log_percent "abc" 10

test_function "log_percent (zero divisor)" "Shows error message for division by zero" \
  log_percent 5 0

# Test progress bar
export -f log_progressbar
test_function "log_progressbar" "Shows a progress bar indicator" \
  bash -c 'for i in {0..20}; do log_progressbar $i 20 40; sleep 0.2; done; log_newline'

# Test spinner
export -f log_spinner
export -f log_success
test_function "log_spinner" "Shows a spinner while a process runs" \
  bash -c 'sleep 5 & log_spinner $! "Processing data"; log_success "Process complete"'

# Test wait function
test_function "log_wait" "Shows a spinner while waiting for specified seconds" \
  log_wait "Waiting for process to complete" 5

# Test press any key function
test_function "log_pressanykey" "Pauses execution until user presses a key" \
  log_pressanykey "Press any key to proceed to the next test..."

# Test final "done" message
test_function "log_done" "Shows a completion message with success mark" \
  log_done

log_title "TEST COMPLETE"
log_message "All terminal.sh functions have been demonstrated."
