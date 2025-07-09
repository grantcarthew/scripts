# Script Templates

This directory contains script templates.

## Bash Run Commands

Use the following on a new installation of Linux to replace everything in the ~/.bashrc file with the content of the [bashrc](bashrc) file in this repository.

```bash
bash <(curl -s "https://raw.githubusercontent.com/grantcarthew/scripts/main/templates/install-bashrc")
```

## AI Command Helper

The following example can be added to the ~/.bashrc file to use the Gemini CLI as a command helper.

After adding it you can type any command question into the terminal and press CTRL+L.

Gemini CLI will return a valid Bash command.

```bash
read -r -d '' __prompt <<'EOF'
# Role: Bash Command Expert

- Provide only Bash commands for Bash v5.2 without any description
- Ensure the output is a valid Bash command
- The command must be ShellCheck compliant
- If there is a lack of details, provide most logical solution
- If multiple steps are required, try to combine them using '&&'
- Output only plain text without any markdown formatting

## Request

EOF

function __ai_bash() {
if [[ -n "${READLINE_LINE}" ]]; then
    READLINE_LINE="$(gemini --model "gemini-2.5-flash" --prompt "${__prompt}${READLINE_LINE}")"
    READLINE_POINT="${#READLINE_LINE}"
fi
}
bind -x '"\C-l": __ai_bash'
```

_Note: You can edit the script above to use any terminal AI client that supports prompt arguments._
