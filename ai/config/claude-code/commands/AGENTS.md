# AGENTS.md

## About This Directory

This directory contains custom Claude Code slash commands - reusable Markdown files that Claude Code can execute as commands. These commands extend Claude's capabilities with project-specific and personal automation.

Reference: https://docs.claude.com/en/docs/claude-code/slash-commands

## Command Structure

### File Organization

- **Location**: `~/.claude/commands/` (personal commands) or `.claude/commands/` (project commands)
- **Format**: Markdown files with `.md` extension
- **Naming**: Command name matches filename (e.g., `optimize.md` creates `/optimize` command)
- **Namespacing**: Subdirectories organize commands but don't affect command names

### Command Types

- **Personal Commands**: Available across all projects (`~/.claude/commands/`)
- **Project Commands**: Repository-specific commands (`.claude/commands/`)
- **MCP Commands**: Dynamic commands from Model Context Protocol servers (`/mcp__<server>__<command>`)

## Command Features

### Arguments

- `$ARGUMENTS` - Captures all arguments passed to command
- `$1`, `$2`, etc. - Individual positional arguments
- Example: `/fix-issue 123 high` where `$1=123`, `$2=high`

### Frontmatter Options

```yaml
---
allowed-tools: Bash(git add:*), Bash(git status:*)
argument-hint: [issue-number] [priority]
description: Fix issue with given priority
model: claude-3-5-haiku-20241022
disable-model-invocation: false
---
```

### Special Features

- **Bash Execution**: Use `!` prefix to run commands (e.g., `!git status`)
- **File References**: Use `@` prefix for file inclusion (e.g., `@src/utils/helpers.js`)
- **Thinking Mode**: Include extended thinking keywords for deeper analysis

## Available Commands

Current commands in this directory:

- `bash-review.md` - Code review focused on bash scripts
- `fetch.md` - Web content fetching and analysis
- `glab.md` - GitLab CLI operations
- `jira.md` - Jira issue management
- `kagi.md` - Kagi search integration
- `project.md` - Project-specific operations
- `step.md` - Step-by-step task breakdown
- `wiz.md` - Wizard-style guided operations

## Usage Examples

### Basic Command

```bash
/optimize src/main.js
```

### With Multiple Arguments

```bash
/review-pr 456 high alice
```

### List Available Commands

```bash
/help
```

## Best Practices

### Command Design

- MUST format the command files using the CommonMark specification
- Keep commands focused on specific tasks
- Use clear, descriptive names
- Include helpful argument hints in frontmatter
- Provide meaningful descriptions
- Be concise

### Security

- Be explicit about allowed tools in frontmatter
- Avoid exposing sensitive information
- Use specific bash command permissions (e.g., `Bash(git status:*)`)

### Organization

- Use consistent naming conventions
- Document command purpose and usage

## SlashCommand Tool Integration

Commands in this directory are automatically available to Claude via the SlashCommand tool:

- Commands appear in Claude's context with metadata
- Claude can invoke commands programmatically when appropriate
- Character budget limit prevents context overflow (default: 15,000 characters)

### Permissions

- Use `/permissions` to control SlashCommand tool access
- Specific command permissions: `SlashCommand:/command-name:*`
- Disable specific commands with `disable-model-invocation: true`

## Creating New Commands

1. Create a new `.md` file in this directory
2. Add frontmatter if needed for tools/permissions
3. Write the command prompt using argument placeholders
4. Test with Claude Code
5. Update this documentation if adding significant new functionality
6. Update this AGENTS.md file

## Troubleshooting

- Commands not appearing: Check file permissions and markdown syntax
- Permission errors: Review `allowed-tools` frontmatter
- Context overflow: Consider `disable-model-invocation: true` for less-used commands
- Argument issues: Verify argument placeholder syntax (`$1`, `$2`, `$ARGUMENTS`)
