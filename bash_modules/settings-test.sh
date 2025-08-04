#!/usr/bin/env bash

# Automated Test Script for settings.sh
# ------------------------------------
# This script runs a non-interactive, assertion-based test suite
# for all public functions of the settings.sh module.

# Environment setup
set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

# Source the modules we need
source "${SCRIPT_DIR}/terminal.sh"
source "${SCRIPT_DIR}/settings.sh"

# --- Test Setup ---
# Override settings_get_path to use a temporary file for testing
export TEST_SETTINGS_FILE="/tmp/settings-test-settings.conf"
function settings_get_path() {
  echo "${TEST_SETTINGS_FILE}"
}
export -f settings_get_path

# Create a temporary defaults file for testing
DEFAULTS_FILE=$(mktemp)
cat > "${DEFAULTS_FILE}" <<EOF
AI_MODEL_PRO="vertexai:gemini-2.5-pro"
AI_MODEL_FLASH="vertexai:gemini-2.5-flash"
EOF

# Override settings_get_defaults_path to use the temporary defaults file
function settings_get_defaults_path() {
  echo "${DEFAULTS_FILE}"
}
export -f settings_get_defaults_path


TESTS_PASSED=0
TESTS_FAILED=0

# Clean up test file on exit
function cleanup() {
  # shellcheck disable=SC2317
  rm -f "${TEST_SETTINGS_FILE}" "${DEFAULTS_FILE}"
}
trap cleanup EXIT

# --- Assertion Functions ---
function assert_equals() {
  local expected="${1}"
  local actual="${2}"
  local message="${3}"

  if [[ "${expected}" == "${actual}" ]]; then
    log_success "${message}"
    ((TESTS_PASSED++))
  else
    log_failure "${message}"
    log_error "  Expected: '${expected}'"
    log_error "  Got:      '${actual}'"
    ((TESTS_FAILED++))
  fi
}

function assert_equals_base64() {
  local expected="${1}"
  local actual="${2}"
  local message="${3}"

  local expected_base64
  if [[ "$(uname)" == "Darwin" ]]; then
    expected_base64=$(printf "%s" "${expected}" | base64)
  else
    expected_base64=$(printf "%s" "${expected}" | base64 -w 0)
  fi

  local actual_base64
  if [[ "$(uname)" == "Darwin" ]]; then
    actual_base64=$(printf "%s" "${actual}" | base64)
  else
    actual_base64=$(printf "%s" "${actual}" | base64 -w 0)
  fi

  if [[ "${expected_base64}" == "${actual_base64}" ]]; then
    log_success "${message}"
    ((TESTS_PASSED++))
  else
    log_failure "${message}"
    log_error "  Expected: '${expected}'"
    log_error "  Got:      '${actual}'"
    log_error "  Expected (base64): '${expected_base64}'"
    log_error "  Got      (base64): '${actual_base64}'"
    ((TESTS_FAILED++))
  fi
}

function assert_empty() {
  local actual="${1}"
  local message="${2}"

  if [[ -z "${actual}" ]]; then
    log_success "${message}"
    ((TESTS_PASSED++))
  else
    log_failure "${message}"
    log_error "  Expected empty, but got: '${actual}'"
    ((TESTS_FAILED++))
  fi
}

# --- Main Test Execution ---
log_heading "Running settings.sh Automated Tests"
rm -f "${TEST_SETTINGS_FILE}" # Start with a clean file

# Test 1: Retrieves a value from the defaults file
AI_PRO=$(settings_get "AI_MODEL_PRO")
assert_equals_base64 "vertexai:gemini-2.5-pro" "${AI_PRO}" "Should retrieve 'vertexai:gemini-2.5-pro' from defaults"

# Test 2: Writes a retrieved default to the user settings
if [[ "$(uname)" == "Darwin" ]]; then
    expected_encoded_default=$(printf "%s" "vertexai:gemini-2.5-pro" | base64)
else
    expected_encoded_default=$(printf "%s" "vertexai:gemini-2.5-pro" | base64 -w 0)
fi
actual_encoded_default=$(grep "AI_MODEL_PRO" "${TEST_SETTINGS_FILE}")
assert_equals "AI_MODEL_PRO=${expected_encoded_default}" "${actual_encoded_default}" "Should write the retrieved default value to the user settings file, base64 encoded"

# Test 3: Sets and gets a new value
settings_set "EDITOR" "vscode"
EDITOR=$(settings_get "EDITOR")
assert_equals_base64 "vscode" "${EDITOR}" "Should set a new key 'EDITOR' to 'vscode' and retrieve it"

# Test 4: Updates an existing value
settings_set "EDITOR" "neovim"
EDITOR=$(settings_get "EDITOR")
assert_equals_base64 "neovim" "${EDITOR}" "Should update the value of 'EDITOR' to 'neovim'"

# Test 5: Returns an empty string for a non-existent key
NON_EXISTENT=$(settings_get "A_KEY_THAT_DOES_NOT_EXIST")
assert_empty "${NON_EXISTENT}" "Should return an empty string for a key that does not exist"

# Test 6: Deletes a key successfully
settings_delete "EDITOR"
EDITOR=$(settings_get "EDITOR")
assert_empty "${EDITOR}" "Should delete the key 'EDITOR' successfully"

# Test 7: Lists all key-value pairs
settings_set "USER_NAME" "test-user"
LIST_OUTPUT=$(settings_list)
EXPECTED_LIST=$(printf 'AI_MODEL_PRO="vertexai:gemini-2.5-pro"
USER_NAME="test-user"')
assert_equals_base64 "$(echo "${EXPECTED_LIST}" | sort)" "$(echo "${LIST_OUTPUT}" | sort)" "Should list all key-value pairs correctly decoded and sorted"

# Test 8: Correctly handles values with special characters
SPECIAL_CHARS_VALUE=$'hello "world" & a/path/here with spaces and !@#$%^&*()_+-=[]{} \\|;:",<.>/?~'
settings_set "SPECIAL" "${SPECIAL_CHARS_VALUE}"
SPECIAL_RESULT=$(settings_get "SPECIAL")
assert_equals_base64 "${SPECIAL_CHARS_VALUE}" "${SPECIAL_RESULT}" "Should correctly handle a value with a wide range of special characters"

# Test 9: Correctly handles values with equals signs
EQUALS_VALUE="foo=bar"
settings_set "EQUALS_TEST" "${EQUALS_VALUE}"
EQUALS_RESULT=$(settings_get "EQUALS_TEST")
assert_equals_base64 "${EQUALS_VALUE}" "${EQUALS_RESULT}" "Should correctly handle a value containing an equals sign"

# Test 10: Deleting a non-existent key does not affect other keys
rm -f "${TEST_SETTINGS_FILE}" # Clean file
settings_set "KEY_A" "VALUE_A"
settings_set "KEY_B" "VALUE_B"
settings_delete "KEY_C" # This key doesn't exist
RESULT_A=$(settings_get "KEY_A")
RESULT_B=$(settings_get "KEY_B")
assert_equals_base64 "VALUE_A" "${RESULT_A}" "Deleting a non-existent key should not affect other keys (A)"
assert_equals_base64 "VALUE_B" "${RESULT_B}" "Deleting a non-existent key should not affect other keys (B)"
LINE_COUNT=$(wc -l < "${TEST_SETTINGS_FILE}")
assert_equals "2" "${LINE_COUNT}" "Should be exactly 2 lines in the settings file"


# Test 11: Listing from an empty file returns nothing
rm -f "${TEST_SETTINGS_FILE}" # Create a fresh empty file
touch "${TEST_SETTINGS_FILE}"
LIST_EMPTY_OUTPUT=$(settings_list)
assert_empty "${LIST_EMPTY_OUTPUT}" "Listing from an empty file should return nothing"

# Test 12: Correctly handles values with newline characters
NEWLINE_VALUE=$(printf "line1\nline2\nline3")
settings_set "NEWLINE_TEST" "${NEWLINE_VALUE}"
NEWLINE_RESULT=$(settings_get "NEWLINE_TEST")
assert_equals_base64 "${NEWLINE_VALUE}" "${NEWLINE_RESULT}" "Should correctly handle a value containing newline characters"

# Test 13: Correctly handles intentionally quoted values
QUOTED_VALUE='"this is a quoted string"'
settings_set "QUOTED_TEST" "${QUOTED_VALUE}"
QUOTED_RESULT=$(settings_get "QUOTED_TEST")
assert_equals_base64 "${QUOTED_VALUE}" "${QUOTED_RESULT}" "Should correctly handle a value that is intentionally quoted"

# Test 14: Correctly handles values with leading/trailing whitespace
WHITESPACE_VALUE='  leading and trailing spaces  '
settings_set "WHITESPACE" "${WHITESPACE_VALUE}"
WHITESPACE_RESULT=$(settings_get "WHITESPACE")
assert_equals_base64 "${WHITESPACE_VALUE}" "${WHITESPACE_RESULT}" "Should correctly handle values with leading/trailing whitespace"


# --- Test Summary ---
log_heading "Test Summary"
if [[ ${TESTS_FAILED} -eq 0 ]]; then
  log_success "All ${TESTS_PASSED} tests passed!"
  exit 0
else
  log_failure "${TESTS_FAILED} out of $((TESTS_PASSED + TESTS_FAILED)) tests failed."
  exit 1
fi
