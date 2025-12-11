# Scripts

Personal automation scripts and Bash utilities for Linux/macOS workflows.

## Project Overview

This repository contains a collection of Bash scripts for automation, development workflows, and system administration. It includes reusable Bash modules, technology-specific script libraries (Git, AWS, GCP, Terraform, Kubernetes, etc.), and AI-enhanced developer tools.

Public repository: <https://github.com/grantcarthew/scripts>

## Setup Commands

Installation via one-liner:

```bash
bash <(curl -s https://raw.githubusercontent.com/grantcarthew/scripts/main/install-scripts)
```

Manual installation:

```bash
mkdir -p "${HOME}/bin"
cd "${HOME}/bin"
git clone git@github.com:grantcarthew/scripts.git
echo 'export PATH="${PATH}:${HOME}/bin/scripts"' >> "${HOME}/.bashrc"
```

Add technology-specific libraries to PATH as needed:

```bash
echo 'export PATH="${PATH}:${HOME}/bin/scripts/lib/git"' >> "${HOME}/.bashrc"
echo 'export PATH="${PATH}:${HOME}/bin/scripts/lib/terraform"' >> "${HOME}/.bashrc"
```

## Code Style Guidelines

**Bash Version:** Bash 5.x required

**Shebang:** Always use `#!/usr/bin/env bash`

**ShellCheck Compliance:** All scripts MUST pass ShellCheck validation

- Configuration: `.shellcheckrc` at repository root
- External sources enabled for bash_modules
- Run: `shellcheck <script-name>`

**Variable Substitution:**

- MUST use double-quotes and curly braces: `"${VARIABLE}"`
- When logging variable values, use single quotes around them: `log_message "Output: '${OUTPUT_FILE}'"`

**Test Constructs:**

- Always use double square brackets: `[[ condition ]]`
- Never use single brackets or test command

**Command Substitution:**

- Always use `$()` syntax
- Never use backticks

**Indentation:** 2 spaces (no tabs)

**Functions:**

- Use `function` keyword: `function name() { ... }`
- Avoid single-use functions
- Keep main logic at root level

**Comments:**

- Minimal comments
- Code should be self-documenting
- Use clear variable and function names

**Script Template:**

- Use `templates/bash-template` as the starting point for new scripts
- Includes proper error handling, logging setup, and validation patterns

## Development Workflow

**Branch Management:** Work on `main` branch (personal repository)

**Commit Message Format:** Conventional Commits style

```
type(scope): description

Examples:
feat(git): add new commit message generator
fix(aws): correct IAM policy lookup logic
docs(readme): update installation instructions
chore(config): update shellcheck rules
```

**Before Committing:**

- Run ShellCheck on modified scripts
- Test scripts in target environment
- Ensure executable permissions set: `chmod +x <script>`

**AI-Enhanced Scripts:**

- Many scripts use AI for enhanced functionality (gcm, gdr, ucl, etc.)
- Prompt files stored alongside scripts with `-prompt.md` suffix
- See `ai/` directory for role definitions and metaprompts

## Project Structure

**Key Directories:**

- `bash_modules/`: Reusable Bash function libraries (sourced modules)
  - `terminal.sh`: Most common module with `log_*` output functions
  - `verify.sh`: Input validation functions
  - `utils.sh`: General utility functions
  - `ai.sh`, `aws.sh`, `gcp.sh`, `git.sh`: Technology-specific modules

- `lib/`: Technology-focused executable scripts organized by domain
  - `lib/git/`: Git workflow shortcuts (gcm, gdr, gig, ucl, etc.)
  - `lib/aws/`: AWS CLI utilities
  - `lib/gcp/`: Google Cloud utilities
  - `lib/terraform/`: Terraform workflow tools
  - `lib/gitlab/`: GitLab CI/CD helpers
  - `lib/jira/`: Jira CLI helpers
  - Each subdirectory has README.md with usage info

- `templates/`: Script templates and project scaffolding
  - `bash-template`: Full-featured Bash script template with best practices
  - AI project templates

- `ai/`: AI prompt collection
  - `roles/`: Domain-specific expert personas
  - `commands/`: Task-oriented prompts
  - `metaprompts/`: Templates for creating prompts
  - `templates/`: Resume and cover letter templates

## Testing Instructions

**Unit Tests:**

- Test files named with `-test.sh` suffix in `bash_modules/`
- Run individual tests: `./<module>-test.sh`

**Manual Testing:**

- Test scripts in isolated environments when possible
- Verify output using `log_*` functions from terminal.sh
- Check exit codes for proper error handling

**ShellCheck Validation:**

```bash
# Single file
shellcheck script-name

# All scripts in directory
find . -name "*.sh" -exec shellcheck {} \;

# Git pre-commit check
git diff --name-only --cached | grep '\.sh$' | xargs shellcheck
```

## Bash Modules Usage

Scripts should source required modules from `bash_modules/`:

```bash
SCRIPT_DIR="$(cd "${BASH_SOURCE[0]%/*}" || exit 1; pwd)"
source "${SCRIPT_DIR}/bash_modules/terminal.sh"
```

__Common log__ functions (output to stderr):_*

- `log_title` - Bold green title with double line
- `log_heading` - Bold green heading with line
- `log_message` - Normal message
- `log_warning` - Yellow warning
- `log_error` - Red error
- `log_success` - Green checkmark message
- `log_failure` - Red cross message
- See bash-template for full list

## Dependencies

**Core Tools Required:**

- bash (v5.x)
- git
- curl
- shellcheck

**Optional (based on script usage):**

- ripgrep (rg) - Fast file searching
- fd - Modern file finder
- fzf - Fuzzy finder
- jq - JSON processor
- aichat - AI model CLI interaction
- lsd - Modern ls replacement

**Cloud/Services (optional):**

- aws - AWS CLI
- gcloud - Google Cloud CLI
- gh - GitHub CLI
- kubectl - Kubernetes CLI

See README.md for complete dependency list.

## Security Considerations

- Never commit sensitive tokens or credentials
- Use environment variables for authentication tokens
- Validate all user input using `verify.sh` module functions
- Check file permissions before operations
- Scripts output to stderr via `log_*` functions to avoid interfering with stdout

## Troubleshooting

**"terminal.sh module missing" error:**

- Ensure bash_modules directory is accessible
- Check SCRIPT_DIR is correctly set
- Verify PATH includes repository root

**ShellCheck warnings:**

- Review `.shellcheckrc` for project-specific rules
- External sources enabled for bash_modules
- Use proper quoting and variable expansion

**Permission denied:**

- Set executable: `chmod +x <script-name>`
- Check script ownership and directory permissions

**AI-enhanced scripts not working:**

- Ensure `aichat` is installed and configured
- Check AI model access tokens in environment
- Review corresponding `-prompt.md` files for requirements
