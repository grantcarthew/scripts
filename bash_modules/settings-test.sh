#!/usr/bin/env bash

# Automated Test Script for settings.sh
# -----------------------------------------------------------------------------
# This script runs a non-interactive, assertion-based test suite
# for all public functions of the settings.sh module.

# Environment setup
set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

source "${SCRIPT_DIR}/terminal.sh"
source "${SCRIPT_DIR}/settings.sh"

# Test setup - override settings paths to use temporary files
export TEST_SETTINGS_FILE="/tmp/settings-test-settings.conf"
function settings_get_path() {
  echo "${TEST_SETTINGS_FILE}"
}
export -f settings_get_path

DEFAULTS_FILE=$(mktemp)
cat > "${DEFAULTS_FILE}" <<EOF
AI_MODEL_PRO="vertexai:gemini-2.5-pro"
AI_MODEL_FLASH="vertexai:gemini-2.5-flash"
EOF

function settings_get_defaults_path() {
  echo "${DEFAULTS_FILE}"
}
export -f settings_get_defaults_path

TESTS_PASSED=0
TESTS_FAILED=0

function cleanup() {
  rm -f "${TEST_SETTINGS_FILE}" "${DEFAULTS_FILE}"
  rm -rf "/tmp/settings-test-nonexistent"
}
trap cleanup EXIT

# Assertion Functions
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

# Main Test Execution
log_heading "Running settings.sh Automated Tests"
rm -f "${TEST_SETTINGS_FILE}"

# Test 1: Retrieves a value from the defaults file
AI_PRO=$(settings_get "AI_MODEL_PRO")
assert_equals "vertexai:gemini-2.5-pro" "${AI_PRO}" "Should retrieve 'vertexai:gemini-2.5-pro' from defaults"

# Test 2: Writes a retrieved default to the user settings
expected_quoted_default='AI_MODEL_PRO="vertexai:gemini-2.5-pro"'
actual_quoted_default=$(rg "AI_MODEL_PRO" "${TEST_SETTINGS_FILE}")
assert_equals "${expected_quoted_default}" "${actual_quoted_default}" "Should write the retrieved default value to the user settings file, properly quoted"

# Test 3: Sets and gets a new value
settings_set "EDITOR" "vscode"
EDITOR=$(settings_get "EDITOR")
assert_equals "vscode" "${EDITOR}" "Should set a new key 'EDITOR' to 'vscode' and retrieve it"

# Test 4: Updates an existing value
settings_set "EDITOR" "neovim"
EDITOR=$(settings_get "EDITOR")
assert_equals "neovim" "${EDITOR}" "Should update the value of 'EDITOR' to 'neovim'"

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
assert_equals "$(echo "${EXPECTED_LIST}" | sort)" "$(echo "${LIST_OUTPUT}" | sort)" "Should list all key-value pairs correctly and sorted"

# Test 8: Correctly handles values with special characters
SPECIAL_CHARS_VALUE=$'hello "world" & a/path/here with spaces and !@#$%^&*()_+-=[]{} \\|;:",<.>/?~'
settings_set "SPECIAL" "${SPECIAL_CHARS_VALUE}"
SPECIAL_RESULT=$(settings_get "SPECIAL")
assert_equals "${SPECIAL_CHARS_VALUE}" "${SPECIAL_RESULT}" "Should correctly handle a value with a wide range of special characters"

# Test 9: Correctly handles values with equals signs
EQUALS_VALUE="foo=bar"
settings_set "EQUALS_TEST" "${EQUALS_VALUE}"
EQUALS_RESULT=$(settings_get "EQUALS_TEST")
assert_equals "${EQUALS_VALUE}" "${EQUALS_RESULT}" "Should correctly handle a value containing an equals sign"

# Test 10: Deleting a non-existent key does not affect other keys
rm -f "${TEST_SETTINGS_FILE}"
settings_set "KEY_A" "VALUE_A"
settings_set "KEY_B" "VALUE_B"
settings_delete "KEY_C"
RESULT_A=$(settings_get "KEY_A")
RESULT_B=$(settings_get "KEY_B")
assert_equals "VALUE_A" "${RESULT_A}" "Deleting a non-existent key should not affect other keys (A)"
assert_equals "VALUE_B" "${RESULT_B}" "Deleting a non-existent key should not affect other keys (B)"
LINE_COUNT=$(wc -l < "${TEST_SETTINGS_FILE}")
assert_equals "2" "${LINE_COUNT}" "Should be exactly 2 lines in the settings file"

# Test 11: Listing from an empty file returns nothing
rm -f "${TEST_SETTINGS_FILE}"
touch "${TEST_SETTINGS_FILE}"
LIST_EMPTY_OUTPUT=$(settings_list)
assert_empty "${LIST_EMPTY_OUTPUT}" "Listing from an empty file should return nothing"

# Test 12: Correctly handles values with newline characters
NEWLINE_VALUE=$(printf "line1\nline2\nline3")
settings_set "NEWLINE_TEST" "${NEWLINE_VALUE}"
NEWLINE_RESULT=$(settings_get "NEWLINE_TEST")
assert_equals "${NEWLINE_VALUE}" "${NEWLINE_RESULT}" "Should correctly handle a value containing newline characters"

# Test 13: Correctly handles intentionally quoted values
QUOTED_VALUE='"this is a quoted string"'
settings_set "QUOTED_TEST" "${QUOTED_VALUE}"
QUOTED_RESULT=$(settings_get "QUOTED_TEST")
assert_equals "${QUOTED_VALUE}" "${QUOTED_RESULT}" "Should correctly handle a value that is intentionally quoted"

# Test 14: Correctly handles values with leading/trailing whitespace
WHITESPACE_VALUE='  leading and trailing spaces  '
settings_set "WHITESPACE" "${WHITESPACE_VALUE}"
WHITESPACE_RESULT=$(settings_get "WHITESPACE")
assert_equals "${WHITESPACE_VALUE}" "${WHITESPACE_RESULT}" "Should correctly handle values with leading/trailing whitespace"

# Test 15: Handles empty string values
settings_set "EMPTY_VALUE" ""
EMPTY_RESULT=$(settings_get "EMPTY_VALUE")
assert_equals "" "${EMPTY_RESULT}" "Should correctly handle empty string values"

# Test 16: Handles keys with special characters
SPECIAL_KEY="my-key_with.special@chars"
settings_set "${SPECIAL_KEY}" "special_key_value"
SPECIAL_KEY_RESULT=$(settings_get "${SPECIAL_KEY}")
assert_equals "special_key_value" "${SPECIAL_KEY_RESULT}" "Should correctly handle keys with special characters"

# Test 17: Handles very long values
LONG_VALUE=$(printf 'a%.0s' {1..1000})
settings_set "LONG_VALUE" "${LONG_VALUE}"
LONG_RESULT=$(settings_get "LONG_VALUE")
assert_equals "${LONG_VALUE}" "${LONG_RESULT}" "Should correctly handle very long values"

# Test 18: Multiple equals signs in value
MULTI_EQUALS_VALUE="key1=value1=more=data"
settings_set "MULTI_EQUALS" "${MULTI_EQUALS_VALUE}"
MULTI_EQUALS_RESULT=$(settings_get "MULTI_EQUALS")
assert_equals "${MULTI_EQUALS_VALUE}" "${MULTI_EQUALS_RESULT}" "Should correctly handle values with multiple equals signs"

# Test 19: Values that look like comments
COMMENT_VALUE="# this looks like a comment but isn't"
settings_set "COMMENT_TEST" "${COMMENT_VALUE}"
COMMENT_RESULT=$(settings_get "COMMENT_TEST")
assert_equals "${COMMENT_VALUE}" "${COMMENT_RESULT}" "Should correctly handle values that look like comments"

# Test 20: Test settings_get with missing arguments
NO_ARG_RESULT=$(settings_get)
assert_empty "${NO_ARG_RESULT}" "Should return empty string when no key argument is provided"

# Test 21: Test settings_set with missing value argument
rm -f "${TEST_SETTINGS_FILE}"
settings_set "NO_VALUE_KEY"
NO_VALUE_RESULT=$(settings_get "NO_VALUE_KEY")
assert_equals "" "${NO_VALUE_RESULT}" "Should handle missing value argument by setting empty string"

# Test 22: Test settings_delete with missing argument
settings_delete
# Should not crash - verify by setting a value after
settings_set "AFTER_DELETE" "value"
AFTER_DELETE_RESULT=$(settings_get "AFTER_DELETE")
assert_equals "value" "${AFTER_DELETE_RESULT}" "Should handle missing delete argument gracefully"

# Test 23: Handles values with backslashes
BACKSLASH_VALUE="path\\to\\file and \\n not newline"
settings_set "BACKSLASH_TEST" "${BACKSLASH_VALUE}"
BACKSLASH_RESULT=$(settings_get "BACKSLASH_TEST")
assert_equals "${BACKSLASH_VALUE}" "${BACKSLASH_RESULT}" "Should correctly handle values with backslashes"

# Test 24: Handles tab characters
TAB_VALUE=$(printf "line1\tcolumn2\tcolumn3")
settings_set "TAB_TEST" "${TAB_VALUE}"
TAB_RESULT=$(settings_get "TAB_TEST")
assert_equals "${TAB_VALUE}" "${TAB_RESULT}" "Should correctly handle values with tab characters"

# Test 25: Defaults file with unquoted values
UNQUOTED_DEFAULTS=$(mktemp)
cat > "${UNQUOTED_DEFAULTS}" <<EOF
UNQUOTED_KEY=unquoted_value
QUOTED_DEFAULT="quoted_value"
EOF
function settings_get_defaults_path() {
  echo "${UNQUOTED_DEFAULTS}"
}
export -f settings_get_defaults_path
rm -f "${TEST_SETTINGS_FILE}"
UNQUOTED_DEFAULT_RESULT=$(settings_get "UNQUOTED_KEY")
assert_equals "unquoted_value" "${UNQUOTED_DEFAULT_RESULT}" "Should handle unquoted values in defaults file"
QUOTED_DEFAULT_RESULT=$(settings_get "QUOTED_DEFAULT")
assert_equals "quoted_value" "${QUOTED_DEFAULT_RESULT}" "Should handle quoted values in defaults file"
rm -f "${UNQUOTED_DEFAULTS}"

# Test 26: Settings file permissions (when directory doesn't exist)
NONEXISTENT_DIR="/tmp/settings-test-nonexistent"
rm -rf "${NONEXISTENT_DIR}"
export TEST_SETTINGS_FILE="${NONEXISTENT_DIR}/settings.conf"
function settings_get_path() {
  echo "${TEST_SETTINGS_FILE}"
}
export -f settings_get_path
settings_set "PERMISSION_TEST" "value"
PERMISSION_RESULT=$(settings_get "PERMISSION_TEST")
assert_equals "value" "${PERMISSION_RESULT}" "Should create directory and file when they don't exist"
rm -rf "${NONEXISTENT_DIR}"

# Reset to original test file
export TEST_SETTINGS_FILE="/tmp/settings-test-settings.conf"
function settings_get_path() {
  echo "${TEST_SETTINGS_FILE}"
}
export -f settings_get_path

# Test 27: Settings list handles comments in file
rm -f "${TEST_SETTINGS_FILE}"
cat > "${TEST_SETTINGS_FILE}" <<EOF
# This is a comment
KEY1="value1"
# Another comment
KEY2="value2"

# Empty line above and below

KEY3="value3"
EOF
LIST_WITH_COMMENTS=$(settings_list)
EXPECTED_WITH_COMMENTS=$(printf 'KEY1="value1"\nKEY2="value2"\nKEY3="value3"')
assert_equals "$(echo "${EXPECTED_WITH_COMMENTS}" | sort)" "$(echo "${LIST_WITH_COMMENTS}" | sort)" "Should ignore comments and empty lines when listing"

# Test 28: Unicode and international characters
UNICODE_VALUE="Héllo Wörld 🌍 测试 العربية עברית"
settings_set "UNICODE_TEST" "${UNICODE_VALUE}"
UNICODE_RESULT=$(settings_get "UNICODE_TEST")
assert_equals "${UNICODE_VALUE}" "${UNICODE_RESULT}" "Should correctly handle Unicode and international characters"

# Test 29: Value overwriting preserves file integrity
rm -f "${TEST_SETTINGS_FILE}"
settings_set "KEY1" "value1"
settings_set "KEY2" "value2"
settings_set "KEY3" "value3"
settings_set "KEY2" "new_value2"  # Overwrite middle key
FINAL_LIST=$(settings_list)
EXPECTED_FINAL=$(printf 'KEY1="value1"\nKEY2="new_value2"\nKEY3="value3"')
assert_equals "$(echo "${EXPECTED_FINAL}" | sort)" "$(echo "${FINAL_LIST}" | sort)" "Should maintain file integrity when overwriting values"
FINAL_LINE_COUNT=$(wc -l < "${TEST_SETTINGS_FILE}")
assert_equals "3" "${FINAL_LINE_COUNT}" "Should have exactly 3 lines after overwriting"


# Test Summary
log_heading "Test Summary"
if [[ ${TESTS_FAILED} -eq 0 ]]; then
  log_success "All ${TESTS_PASSED} tests passed!"
  exit 0
else
  log_failure "${TESTS_FAILED} out of $((TESTS_PASSED + TESTS_FAILED)) tests failed."
  exit 1
fi
