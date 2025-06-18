#!/usr/bin/env bash

# Environment setup
BASH_MODULES_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"

# Import colours if not already done
if ! command -v log_line >/dev/null; then
    source "${BASH_MODULES_DIR}/terminal.sh"
fi

function git_get_main_or_master () {
    if git show-ref --verify --quiet "refs/heads/main"; then
        printf "main"
        elif git show-ref --verify --quiet "refs/heads/master"; then
        printf "master"
    else
        log_error "ERROR: main and master branch don't exist"
        exit 1
    fi
}

function git_checkout_main () {
    if git show-ref --verify --quiet "refs/heads/main"; then
        git checkout main --quiet
        elif git show-ref --verify --quiet "refs/heads/master"; then
        git checkout master --quiet
    else
        log_error "ERROR: main and master branch don't exist"
        exit 1
    fi
}

function git_checkout_branch () {
    if [[ -z "${1}" ]]; then
        echo "ERROR: Missing branch name"
        exit 1
    fi
    # Check if the branch exists
    if git show-ref --verify --quiet "refs/heads/${1}"; then
        # The branch exists, so just check it out
        git checkout "${1}"
    else
        # The branch does not exist, so create and check it out
        git checkout -b "${1}"
    fi
}

function git_checkout_pull_status () {
    if [[ $(git branch) == *'main'* ]]; then
        git checkout main --quiet
    else
        git checkout master --quiet
    fi
    git pull
    git status --short
}

function git_diff () {
    git --no-pager diff -B -M -C
}

function github_list_repos_by_branch () {
    if [[ -z "${1}" ]]; then
        echo "ERROR: Missing branch name" >&2
        exit 1
    fi

    # Get total number of repositories
    log_heading "Getting Repo List by Branch: ${1}"
    local total_repos
    local count=0

    total_repos="$(gh repo list orgname --no-archived --limit 1000 --json nameWithOwner -q '.[].nameWithOwner' | wc -l)"
    gh repo list orgname --no-archived --limit 1000 --json nameWithOwner -q '.[].nameWithOwner' | sort | while read -r repo; do
        if gh api "repos/${repo}/branches/${1}" --silent &>/dev/null; then
            printf "%s\n" "${repo}"
        fi
        ((count++))
        log_percent "${count}" "${total_repos}"
    done
}

function git_test_on_branch () {
    if [[ -z "${1}" ]]; then
        echo "ERROR: Missing branch name" >&2
        exit 1
    fi

    if [[ "$(git symbolic-ref --short HEAD)" == "${1}" ]]; then
        printf "%s\n" true
        return
    fi
    printf "%s\n" false
}

function git_test_branch_exists () {
    if [[ -z "${1}" ]]; then
        echo "ERROR: Missing branch name" >&2
        exit 1
    fi
    if git show-ref --verify --quiet "refs/heads/${1}"; then
        printf "%s\n" true
        return
    fi
    printf "%s\n" false
}


function git_update_main_and_branch () {
    if [[ -z "${1}" ]]; then
        echo "ERROR: Missing branch name"
        exit 1
    fi
    # Check if the branch exists
    main_branch_name="$(git_get_main_or_master)"
    branch_name="${1}"
    git checkout "${main_branch_name}" --quiet
    git pull origin "${main_branch_name}"
    git_checkout_branch "${branch_name}"
    git pull origin "${branch_name}"
    git merge main --ff --no-verify -m "Merging ${main_branch_name} updates into ${branch_name}"
}

