# bin libraries

This directory contains scripts focused on a specific technology groups into child directories.

Pick and choose the libraries you are interested in and add them to your PATH environment variable.

Here is an example of what you could add to your `~/.bashrc` file:

```shell
# Assuming the scripts are stored in ~/bin/scripts
export PATH="${PATH}:${HOME}/bin/scripts"
export PATH="${PATH}:${HOME}/bin/scripts/lib/private"
export PATH="${PATH}:${HOME}/bin/scripts/lib/eos"
export PATH="${PATH}:${HOME}/bin/scripts/lib/docker"
```

## Short Script Pattern

Design approach:

- Use the bash_modules
- Always display the help title
- Exit if the arguments are invalid or help
- Log the command with log_message "❯ {{command}}"

Following are the current patterns used for creating short scripts.

No argument:

```bash
#!/usr/bin/env bash

set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${SCRIPT_DIR}/../../bash_modules/terminal.sh"

log_title "[g]it [f]etch --all --prune"

[[ $# -gt 0 ]] && exit 1

log_message "❯ git fetch --all --prune"
git fetch --all --prune

```

With arguments:

```bash
#!/usr/bin/env bash

set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${SCRIPT_DIR}/../../bash_modules/terminal.sh"

log_title "[g]it [s]tatus [path]"

[[ $# -gt 1 || "${1}" == "-h" || "${1}" == "--help" ]] && exit 1

if [[ -z "${1}" ]]; then
  log_message "❯ git status"
  git status
else
  log_message "❯ git status ${1}"
  git status "${1}"
fi


```
