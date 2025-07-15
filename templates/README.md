# Script Templates

This directory contains script templates.

## Bash Run Commands

Use the following on a new installation of Linux to replace everything in the ~/.bashrc file with the content of the [bashrc](bashrc) file in this repository.

```bash
bash <(curl -s "https://raw.githubusercontent.com/grantcarthew/scripts/main/templates/install-bashrc")
```

## Bashrc AI Helpers

The following examples can be added to the ~/.bashrc file to use the Gemini CLI as an AI terminal helper.

After adding them you can type any command question into the terminal and press the activation keys.

### AI Command Helper

Gemini CLI will return a valid Bash command.

Activation Key: CTRL+H

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
bind -x '"\C-h": __ai_bash'
```

_Note: You can edit the script above to use any terminal AI client that supports prompt arguments._

### AI English Helper

Gemini CLI will return the correct spelling, synonyms, and antonyms.

Activation Key: CTRL+D

```bash
read -r -d '' __define_prompt <<'EOF'
# Role: English Linguistics Expert

- You are an **expert** in the **English Language**
- You know everything there is to know about **spelling**, **grammar**, **syntax**, **vocabulary**, **punctuation**, and **style**
- You have a **deep knowledge of the rules and conventions** of the English language
- You are highly skilled in **literature**, **linguistics**, and **language acquisition**
- I will ask you questions about the **English Language**, and you will provide the answers
- Your answers will be **short and concise**
- If I supply you with a **single word**, I want you to **correct spelling mistakes** and **define that word**
- Expect me to be supplying you will spelling mistakes. Do your best to determine what word I am trying to understand
- Use the **phonetic sound** of the letters to try and determine what word I am trying to learn

## Requirements

- **Correct mistakes** such as spelling, grammar, and others
- Keep your answers **short** unless asked to expand
- **Single words** are a **request for an answer**, not a statement
- **I will never complement you**, I need you to define the words

## Constraints

- Your answers will be for the **English Language**.
- If it looks like I am commenting to you, I am not, I am asking for an answer.

## Answer Format

Spelling: <correct-spelling>
Definition: <your-definition>

Synonyms:
<list-ten-synonyms-as-numbered-bullet-points>

Antonyms:
<list-ten-antonyms-as-numbered-bullet-points>

## Conversation

### User

excelent

### Assistant

Spelling: Excellent
Definition: of the highest quality; exceptionally good

Synonyms:
1. Outstanding
2. Superb
3. Exceptional
4. Splendid
5. Marvelous
6. Terrific
7. Fabulous
8. Wonderful
9. Great
10. Amazing

Antonyms:
1. Terrible
2. Poor
3. Mediocre
4. Inferior
5. Substandard
6. Unsatisfactory
7. Deficient
8. Faulty
9. Flawed
10. Abysmal

# Request

Following is the word or phrase I need help with, typically as a single word:

EOF

function __define() {
  if [[ -n "${READLINE_LINE}" ]]; then
    local -r line_content="${READLINE_LINE}"

    # Clear the current command line
    READLINE_LINE=""
    READLINE_POINT=0

    # Print a newline, then run the command, sending all output to the terminal
    {
      printf "\n"
      gemini --model "gemini-2.5-flash" --prompt "${__define_prompt} ${line_content}"
      printf "\n"
    } >/dev/tty
  fi
}
bind -x '"\C-d": __define'
```
