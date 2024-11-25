# bin

My home binary files and scripts for Bash and Linux

## Dependencies

The following dependencies are used throughout this repository.

You may not need them all if you are only interested in a few scripts.

- [jq](https://github.com/jqlang/jq)
- [entr](https://github.com/eradman/entr)
- [fd](https://github.com/sharkdp/fd)
- [gh](https://cli.github.com/)
- [ripgrep](https://github.com/BurntSushi/ripgrep)

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

### Task 4 - Optional Scripts

Review the directories in the **lib** directory and add any you want to your bashrc.

This example is for the terraform scripts:

```shell
echo 'export PATH="${PATH}:${HOME}/bin/lib/terraform"' >> "${HOME}/.bashrc"
```