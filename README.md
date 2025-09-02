# Scripts <!-- omit in toc -->

My scripts for all kinds of automation and workflows.

- [Dependencies](#dependencies)
  - [Core Tools](#core-tools)
  - [Cloud \& Services](#cloud--services)
  - [Infrastructure Tools](#infrastructure-tools)
- [Installation](#installation)
  - [One-Liner](#one-liner)
  - [Manual Installation](#manual-installation)
    - [Task 1 - Install Git](#task-1---install-git)
    - [Task 2 - Clone](#task-2---clone)
    - [Task 3 - PATH](#task-3---path)
    - [Task 4 - Libraries](#task-4---libraries)
- [AI Prompts Collection](#ai-prompts-collection)
  - [Quick Access](#quick-access)
- [AI Enhanced Tools](#ai-enhanced-tools)

## Dependencies

Most of these scripts have been written to run on Unix-like systems (Linux, macOS).

The following dependencies are used throughout this repository.

You may not need them all if you are only interested in a few scripts.

### Core Tools

- [aichat](https://github.com/sigoden/aichat): CLI tool for interacting with AI models (used in changelog generation)
- [bash](https://www.gnu.org/software/bash/): Unix shell and command language
- [curl](https://curl.se/): Command-line tool for transferring data with URLs
- [entr](https://github.com/eradman/entr): Run arbitrary commands when files change
- [fd](https://github.com/sharkdp/fd): A simple, fast and user-friendly alternative to 'find'
- [fzf](https://github.com/junegunn/fzf): Command-line fuzzy finder
- [git](https://git-scm.com/): Distributed version control system
- [jq](https://github.com/jqlang/jq): Command-line JSON processor
- [lsd](https://github.com/lsd-rs/lsd): The next gen ls command
- [python](https://www.python.org/): Python interpreter (Python 3 recommended)
- [ripgrep (rg)](https://github.com/BurntSushi/ripgrep): Regex directory search while respecting your gitignore
- [shellcheck](https://github.com/koalaman/shellcheck): Static analysis tool for shell scripts

### Cloud & Services

- [aws](https://aws.amazon.com/cli/): AWS Command Line Interface
- [gcloud](https://cloud.google.com/sdk/gcloud): Google Cloud CLI
- [gh](https://cli.github.com/): GitHub CLI brings GitHub to your terminal
- [kubectl](https://kubernetes.io/docs/reference/kubectl/): Kubernetes command-line tool

### Infrastructure Tools

- [terraform](https://www.terraform.io/): Infrastructure as code tool
- [terraform-docs](https://github.com/terraform-docs/terraform-docs): Generate documentation for Terraform modules
- [tflint](https://github.com/terraform-linters/tflint): Terraform linter
- [trivy](https://github.com/aquasecurity/trivy): Vulnerability scanner for containers and infrastructure as code

## Installation

Compatible with Unix-like systems including Linux and macOS. Many dependencies can be installed via package managers like `apt`, `yum`, `pacman`, `yay`, `brew`, etc.

### One-Liner

```bash
bash <(curl -s https://raw.githubusercontent.com/grantcarthew/scripts/main/install-scripts)
```

The above command will:

- Create a "${HOME}/bin" directory if it doesn't already exist
- Clone this repository into "${HOME}/bin/scripts"
- Add "${HOME}/bin/scripts" to your PATH environment variable

Review the `lib` directory and add to your PATH as desired.

### Manual Installation

Follow these instructions to get the **scripts** ready for execution.

#### Task 1 - Install Git

You'll need [git](https://git-scm.com/docs/git-checkout) to be able to clone this repository.

#### Task 2 - Clone

Open a terminal and run the following commands making changes where you see fit:

```bash
mkdir -p "${HOME}/bin"
cd "${HOME}/bin"
git clone git@github.com:grantcarthew/scripts.git
cd -
```

#### Task 3 - PATH

Add the **${HOME}/bin/scripts** directory to your PATH environment variable:

```bash
echo 'export PATH="${PATH}:${HOME}/bin/scripts"' >> "${HOME}/.bashrc"
```

#### Task 4 - Libraries

Review the directories in the **lib** directory and add any you want to your bashrc.

This example is for the terraform scripts:

```bash
echo 'export PATH="${PATH}:${HOME}/bin/scripts/lib/terraform"' >> "${HOME}/.bashrc"
```

## AI Prompts Collection

The [`ai/`](ai/) directory contains a comprehensive collection of AI prompts, roles, and templates:

- **[AI Roles](ai/roles/)**: Domain-specific expert personas for cloud, development, and analysis
- **[Commands](ai/commands/)**: Quick task-oriented prompts for immediate use
- **[Metaprompts](ai/metaprompts/)**: Advanced templates for creating other prompts
- **[Templates](ai/templates/)**: Customizable frameworks for resumes and cover letters

### Quick Access

Use these scripts to work with AI prompts:

- `get-airole [filter]`: Copy role prompts to clipboard
- `new-airole [filter]`: Save role prompts to ROLE.md file

## AI Enhanced Tools

- [get-airole](get-airole): AI Role Prompt Fetcher - copies prompts from the collection to clipboard
- [get-aiscripts](get-aiscripts): Lists all AI-enhanced scripts in the repository
- [get-clihelp](get-clihelp): Get CLI command help
- [get-definition](get-definition): Get word definition with options
- [new-aiproject](new-aiproject): New AI Project Generator
- [new-airole](new-airole): AI Role Document Creator - saves prompts directly to ROLE.md
- [gcm](lib/git/gcm): Git Commit Generator
- [gdr](lib/git/gdr): Git Diff --staged Review
- [gig](lib/git/gig): Git Ignore Generator (.gitignore)
- [tpr](lib/terraform/tpr): Terraform Plan Review
- [ucl](lib/git/ucl): Update Change Log
