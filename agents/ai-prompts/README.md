# AI Prompts

This directory contains prompt templates for the `ai` script.

## File Format

Each prompt is a markdown file with YAML frontmatter:

```markdown
---
title: Descriptive Title
description: Brief explanation of what this prompt does
input: optional
input_hint: what kind of input is expected
---

Your prompt content here.

${INPUT}
```

## Filename Convention

Format: `<alias>-<title>.md`

- Alias: Short identifier (lowercase, alphanumeric, hyphens)
- Title: Descriptive name (converted to Title Case for display)

Example: `ps-prompt-start.md` creates alias `ps`

## Frontmatter Fields

- `title` (optional): Full descriptive title. Falls back to filename-derived title if missing.
- `description` (optional): Brief explanation shown in `--list` output
- `input` (optional): "required" or "optional" - declares ${INPUT} variable behavior
- `input_hint` (optional): Description of expected input value

## Variable Substitution

Use `${INPUT}` in prompt content for dynamic substitution:

- With `input: required` - User must provide argument or error
- With `input: optional` - Substitutes argument or empty string
- Without `input` field - Script warns if argument provided

## Usage

See `ai --help` for full command reference.

Quick examples:
- `ai` - Interactive fzf selection
- `ai <alias>` - Load prompt by alias
- `ai <alias> "value"` - Load with INPUT substitution
- `ai --list` - Show all prompts
- `ai --new` - Create new prompt
- `ai --doctor` - Validate all prompts

## Management Commands

- `ai --edit <alias>` - Edit prompt in $EDITOR
- `ai --find <keyword>` - Search prompt content
- `ai --doctor` - Validate all prompt files
