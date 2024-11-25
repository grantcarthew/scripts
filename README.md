# Scripts

My scripts for all kinds of automation and workflows.

## Dependencies

Most of these scripts have been written to run on Linux.

The following dependencies are used throughout this repository.

You may not need them all if you are only interested in a few scripts.

- [entr](https://github.com/eradman/entr): Run arbitrary commands when files change
- [fd](https://github.com/sharkdp/fd): A simple, fast and user-friendly alternative to 'find'
- [gh](https://cli.github.com/): GitHub CLI brings GitHub to your terminal
- [jq](https://github.com/jqlang/jq): Command-line JSON processor
- [ripgrep](https://github.com/BurntSushi/ripgrep): Regex directory search while respecting your gitignore

## Installation

Follow these instructions to get the **bin** scripts ready to be executed.

### Task 1 - Install Git

You'll need [git](https://git-scm.com/docs/git-checkout) to be able to clone this repository.

### Task 2 - Clone

Open a terminal and run the following commands making changes where you see fit:

```shell
cd "${HOME}"
git clone git@github.com:grantcarthew/bash-bin.git bin
cd bin
```

### Task 3 - PATH

Add the **bin** directory to your PATH environment variable:

```shell
echo 'export PATH="${PATH}:${HOME}/bin"' >> "${HOME}/.bashrc"
```

### Task 4 - Libraries

Review the directories in the **lib** directory and add any you want to your bashrc.

This example is for the terraform scripts:

```shell
echo 'export PATH="${PATH}:${HOME}/bin/lib/terraform"' >> "${HOME}/.bashrc"
```