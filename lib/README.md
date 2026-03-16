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

## Small Script Pattern

See the `bash-small` template in `scripts/templates/` for the official template and examples.
