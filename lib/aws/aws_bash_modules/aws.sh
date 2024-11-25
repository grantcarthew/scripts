#!/usr/bin/env bash

# Function: get_aws_account_info
#
# Purpose: Retrieve AWS account information being Account ID and Account Alias
# The result is returned as a JSON object.
#
# Parameters:
#   None
#
# Usage:
#   if get_aws_account_info; then
#     echo "An error has occured"
#     exit 1
#   fi
function get_aws_account_info() {
    # Retrieve the AWS Account ID
    local account_id
    account_id="$(aws sts get-caller-identity --output json | jq -r '.Account')"
    if [[ -z "${account_id}" ]]; then
        echo "Unable to retrieve AWS Account ID."
        return 1
    fi

    # Retrieve the AWS Account Alias
    local account_alias
    account_alias="$(aws iam list-account-aliases --output json | jq -r '.AccountAliases[0]')"
    if [[ -z "${account_alias}" ]]; then
        echo "No AWS Account Alias found."
        account_alias="None"
    fi

    # Return the Account ID and Alias
    echo "{ \"account_id\": \"${account_id}\", \"account_alias\": \"${account_alias}\" }"
}

