#!/usr/bin/env bash

# Amazon Web Services Module
# -----------------------------------------------------------------------------
# This Bash script contains AWS helper functions
#

# Environment setup
set -o pipefail

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
