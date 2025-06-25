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
- Log the command with log_subheading "command: ???"
- Use log_line at the end

Following are the current patterns used for creating short scripts.

No argument:

```bash
#!/usr/bin/env bash

set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${SCRIPT_DIR}/../../bash_modules/terminal.sh"

log_title "[g]it [s]tatus"

[[ "${#}" -gt 0 ]] && exit 1

log_subheading "command: git status"
git status
log_line
```

With arguments:

```bash
#!/usr/bin/env bash

set -o pipefail
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${SCRIPT_DIR}/../../bash_modules/terminal.sh"

log_title "[g]it [d]iff [file-path]"

[[ "${#}" -gt 1 || "${1}" == "-h" || "${1}" == "--help" ]] && exit 1

if [[ "${#}" -gt 0 ]]; then
    log_subheading "command: git diff ${1}"
    git diff "${1}"
else
    log_subheading "command: git diff"
    git diff
fi
log_line
```
