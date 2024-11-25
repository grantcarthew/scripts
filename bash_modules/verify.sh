#!/usr/bin/env bash

# Verify Assertion Module
# -----------------------------------------------------------------------------
# This Bash script contains simple assertion functions and comparison
# functions to help validate script inputs and other variables.
#
# Sections:
#  - AWS Assertions
#  - Filesystem Assertions
#  - JSON Assertions
#  - Script Assertions
#  - Type Assertions

# Environment setup
set -o pipefail

# AWS Assertions
# -----------------------------------------------------------------------------

function is_aws_account_id {
    # is_aws_account_id <string>
    local account_id="${1}"

    if [[ "${account_id}" =~ ^[0-9]{12}$ ]]; then
        echo "AWS Account ID is valid: '${account_id}'"
        return 0
    else
        echo "AWS Account ID is invalid: '${account_id}'"
        return 1
    fi
}

function is_aws_environment_alias {
    # is_aws_environment_alias <string>
    local alias="${1}"
    local aws_environment_list=("dev" "syst" "uat" "preprod" "prod")

    if [[ " ${aws_environment_list[*]} " =~ ${alias} ]]; then
        echo "AWS environment alias is valid: '${alias}'"
        return 0
    else
        echo "AWS environment alias is not valid: '${alias}'"
        return 1
    fi
}

# Dependency validation
# -----------------------------------------------------------------------------

function dependency_check() {
    # dependency_check command command command
    for cmd in "$@"; do
        if ! command -v "${cmd}" >/dev/null 2>&1; then
            echo "Error: ${cmd} is not installed" >&2
            exit 1
        fi
    done
}

function environment_variable_check() {
    # environment_variable_check ENV_NAME ENV_NAME ENV_NAME
    for envar in "$@"; do
        if [[ -z "${!envar}" ]]; then
            echo "Error: ${envar} environment variable is not set" >&2
            exit 1
        fi
    done
}

function file_check() {
    # environment_variable_check path path
    for envar in "$@"; do
        if ! [[ -f "${envar}" ]]; then
            echo "Error: ${envar} file is missing" >&2
            exit 1
        fi
    done
}

function dir_check() {
    # environment_variable_check path path
    for envar in "$@"; do
        if [[ -d "${envar}" ]]; then
            echo "Error: ${envar} directory is missing" >&2
            exit 1
        fi
    done
}

# Filesystem Assertions
# -----------------------------------------------------------------------------

function is_path() {
    # is_path <path>
    local path="${1}"

    if realpath -ms "${path}" &>/dev/null; then
        echo "Path is valid: '${path}'"
        return 0
    else
        echo "Path is invalid: '${path}'"
        return 1
    fi
}

function directory_exists {
    # directory_exists <path>
    local path="${1}"

    if [[ -d "${path}" ]]; then
        echo "Directory exists: '${path}'"
        return 0
    else
        echo "Directory does not exist or is invalid: '${path}'"
        return 1
    fi
}

function file_exists {
    # file_exists <path>
    local path="${1}"

    if [[ -f "${path}" ]]; then
        echo "File exists: '${path}'"
        return 0
    else
        echo "File does not exist or is invalid: '${path}'"
        return 1
    fi
}

# JSON Assertions
# -----------------------------------------------------------------------------

function is_json() {
    # is_json <string>
    local json="${1}"

    if echo "${json}" | jq empty >/dev/null 2>&1; then
        echo "Valid JSON string"
        return 0
    else
        echo "Invalid JSON string"
        return 1
    fi
}

function compare_json() {
    # compare_json <json-string> <json-string>
    local json1="${1}"
    local json2="${2}"

    if jq --exit-status --null-input --argjson value "${json1}" --argjson data "${json2}" '$value == $data' >/dev/null 2>&1; then
        echo "The two JSON objects are identical"
        return 0
    else
        echo "The two JSON objects are different"
        return 1
    fi
}

function compare_json_structure() {
    # compare_json_structure <json-string> <json-string>
    local json1="${1}"
    local json2="${2}"

    local structure1
    local structure2

    structure1=$(echo "${json1}" | jq 'def recursively_null:
    if type == "object" then
        with_entries( .value |= recursively_null )
    elif type == "array" then
        map( recursively_null )
    else
        null
    end;
    . |= recursively_null')
    structure2=$(echo "${json2}" | jq 'def recursively_null:
    if type == "object" then
        with_entries( .value |= recursively_null )
    elif type == "array" then
        map( recursively_null )
    else
        null
    end;
    . |= recursively_null')

    if [[ "${structure1}" == "${structure2}" ]]; then
        echo "The two JSON objects have the same structure"
        return 0
    else
        echo "The two JSON objects have different structures"
        return 1
    fi
}

# Script Assertions
# -----------------------------------------------------------------------------

function is_bash_script() {
    # is_bash_script <file-path>
    local file="${1}"

    if head --lines=1 "${file}" | grep -Pq '^#!.*bash'; then
        echo "File is a Bash script: '${file}'"
        return 0
    else
        echo "File is not a Bash script: '${file}'"
        return 1
    fi
}

# Type Assertions
# -----------------------------------------------------------------------------

function is_not_empty {
    # is_not_empty <string> [name]
    local arg="${1}"

    if [[ -n "${arg}" ]]; then
        echo "Is not empty: '${arg}'"
        return 0
    else
        echo "Variable is empty"
        return 1
    fi
}

function is_github_repository() {
    # is_github_repository <owner/repository>
    local owner_repo="${1}"
    local owner_repo_regex="^[a-zA-Z]+/([a-zA-Z0-9.-]+)$"

    if [[ "${owner_repo}" =~ ${owner_repo_regex} ]]; then
        echo "Repository is valid: '${owner_repo}'"
        return 0
    else
        echo "Repository is invalid: '${owner_repo}'"
        return 1
    fi
}

function is_url() {
    # is_url <string>
    local url="${1}"
    local url_regex="^https:\/\/[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)*(:[0-9]+)?(\/.*)?$"

    if [[ "${url}" =~ ${url_regex} ]]; then
        echo "URL is valid: '${url}'"
        return 0
    else
        echo "URL is invalid: '${url}'"
        return 1
    fi
}

function is_ipv4_address() {
    local ip="${1}"
    local IFS=.
    # shellcheck disable=SC2206
    local -a octets=(${ip})

    # Check format (4 octets separated by '.')
    if [[ "${ip}" =~ ^[0-9]+(\.[0-9]+){3}$ ]]; then
        # Check each octet value
        for octet in "${octets[@]}"; do
            if (( octet < 0 || octet > 255 )); then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

function is_semver() {
    local version=${1}
    local regex='^[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z-]+)?(\+[0-9A-Za-z-]+)?$'

    if [[ ${version} =~ ${regex} ]]; then
        return 0
    fi
    return 1
}

function is_iso8601_date {
    local date_string="${1}"
    local regex='^([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2}):([0-9]{2})Z$'

    if [[ "${date_string}" =~ ${regex} ]]; then
        return 0
    fi
    return 1
}