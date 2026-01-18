# DR-001: AI Prompt Manager

- Date: 2026-01-18
- Status: Accepted
- Category: tooling/ai

## Problem

The original ai script used a hardcoded approach with inline prompts defined as bash case statements. Each prompt required code changes to add, modify, or remove. This made the tool inflexible and difficult to maintain. There was no way to:

- Add new prompts without editing the script
- See all available prompts at a glance
- Search prompt content
- Validate prompt consistency
- Support variable substitution in prompts
- Provide metadata like descriptions or input requirements

## Decision

Redesign the ai script as a prompt manager that loads prompts from markdown files in agents/ai_prompts/ with YAML frontmatter for metadata.

Key design elements:

File structure:
- Prompt files: agents/ai_prompts/<alias>-<title>.md
- Alias extracted from filename prefix before first hyphen
- Title and metadata in YAML frontmatter
- Prompt content after frontmatter

Frontmatter schema:
- title (string, optional): Full descriptive title, fallback to filename-derived title
- description (string, optional): Brief explanation of prompt purpose
- input (enum, optional): "required" | "optional" | omitted for none
- input_hint (string, optional): Description of expected input value

Variable substitution:
- ${INPUT} placeholder in prompt content
- Replaced with command-line argument
- Empty string if optional and not provided
- Error if required and not provided

Command interface:
- ai [alias] [input] - Load prompt by alias
- ai - Launch fzf for interactive selection
- --list - Show all prompts with metadata
- --edit <alias> - Edit prompt in $EDITOR
- --new - Interactive prompt creation
- --find <keyword> - Search prompt content
- --doctor - Validate all prompts
- --verbose - Detailed operation logging
- --debug - Enable bash tracing

## Why

Separating prompts from code:
- Non-developers can add/edit prompts
- No code changes needed for prompt updates
- Prompts can be version-controlled independently
- Easier to review and maintain prompt library

Frontmatter metadata:
- Self-documenting prompts with title and description
- Input requirements declared upfront
- Validation ensures consistency
- Machine-readable for tooling

FZF integration:
- Fast fuzzy search across all prompts
- Preview pane shows prompt content
- Handles "alias not found" gracefully
- Discoverable - browse all available prompts

Fuzzy matching:
- Typo-tolerant alias lookup
- Suggests similar aliases when exact match fails
- Falls back to fzf if ambiguous

Full bash-template structure:
- Proper error handling with traps
- Terminal.sh logging for consistent output
- Input validation
- Dependency checks
- Follows repository coding standards

## Trade-offs

Accept:
- File I/O overhead for loading prompts (negligible for small files)
- YAML frontmatter parsing with awk (adds complexity)
- Filename convention must be followed for aliases to work
- Multiple files for duplicates require first-match resolution

Gain:
- Zero code changes to add/modify prompts
- Self-service prompt management
- Rich metadata support
- Discoverable via fzf and --list
- Validation prevents errors
- Variable substitution enables reusable templates
- Search functionality finds prompts by content

## Alternatives

Single configuration file (TOML/JSON):
- Pro: All prompts in one place
- Pro: Easier to parse with standard tools
- Con: Merge conflicts when multiple people edit
- Con: Large file becomes unwieldy
- Con: No preview in fzf (would show whole file)
- Rejected: Per-file approach scales better and enables fzf preview

Embedded in script with heredocs:
- Pro: No external files needed
- Pro: Simpler deployment (single file)
- Con: Code changes required for every prompt update
- Con: Harder to discover available prompts
- Con: No metadata structure
- Rejected: This is the original approach we're moving away from

Database storage:
- Pro: Query capabilities
- Pro: Transactional updates
- Con: Requires database setup and management
- Con: Not human-editable without tooling
- Con: Overkill for personal script collection
- Rejected: Markdown files are simpler and git-friendly

Template engine (Jinja, Mustache):
- Pro: Rich templating features (loops, conditionals)
- Pro: Industry-standard approach
- Con: External dependency
- Con: Over-engineered for simple string substitution
- Rejected: ${INPUT} substitution is sufficient

## Structure

Filename format:
- Pattern: <alias>-<title>.md
- Alias: Lowercase alphanumeric with hyphens
- Title: Descriptive, converted to Title Case for display
- Example: ps-prompt-start.md creates alias "ps"

Frontmatter fields:

title:
- Type: string
- Required: No (falls back to filename-derived title)
- Purpose: Display name in listings and success messages

description:
- Type: string
- Required: No
- Purpose: Brief explanation shown in --list output

input:
- Type: enum
- Values: "required", "optional"
- Required: No (omit if prompt doesn't use ${INPUT})
- Purpose: Declares variable substitution behavior

input_hint:
- Type: string
- Required: No
- Purpose: Describes expected input value for user guidance

Prompt content:
- Everything after frontmatter closing "---"
- Plain text or markdown
- ${INPUT} placeholder for variable substitution

## Usage Examples

Basic prompt without input:
```bash
ai one
# Copies "one-one-thing.md" content to clipboard
```

Optional input prompt:
```bash
ai ps
# ${INPUT} becomes empty string

ai ps "focus on authentication"
# ${INPUT} replaced with "focus on authentication"
```

Required input prompt:
```bash
ai refactor
# Error: INPUT required. Expected: file path or component name

ai refactor "src/main.go"
# ${INPUT} replaced with "src/main.go"
```

Interactive selection:
```bash
ai
# Launches fzf with all prompts
# Preview shows file content
# Select and Enter to copy to clipboard
```

List all prompts:
```bash
ai --list
# Shows table: Alias | Title | Input | Description
```

Create new prompt:
```bash
ai --new
# Interactive prompts for:
# - Alias (validated format, checks for duplicates)
# - Title (required)
# - Description (optional)
# - Input type (required/optional/none)
# - Input hint (if input is required or optional)
# Creates file and optionally opens in $EDITOR
```

## Validation

Filename requirements:
- Must match pattern: ^[a-z0-9-]+-[a-z0-9-]+\.md$
- Must have at least one hyphen separating alias from title
- Lowercase only

Alias extraction:
- Take everything before first hyphen
- Must be unique (warning if duplicate)

Frontmatter parsing:
- Optional - file without frontmatter uses filename-derived title
- If present, must start with "---" on line 1
- Fields parsed: title, description, input, input_hint

INPUT consistency checks:
- Warning if ${INPUT} in content but no input field
- Warning if input field present but no ${INPUT} in content

File integrity:
- Error if file is empty
- Error if filename format invalid

## Execution Flow

Loading prompt by alias:
1. Find files matching <alias>-*.md in agents/ai_prompts/
2. If no exact match, try fuzzy matching (substring)
3. If fuzzy match is unique, use it with confirmation
4. If still no match, launch fzf with error header
5. Parse frontmatter for metadata
6. Extract prompt content after frontmatter
7. Check input requirements vs provided argument
8. Substitute ${INPUT} with argument or empty string
9. Copy to clipboard via send_to_clipboard()
10. Echo content to stdout
11. Display success message with title

Interactive selection (no arguments):
1. Build list of all prompts with alias and title
2. Launch fzf with preview showing file content
3. User selects prompt
4. Follow steps 5-11 from above

Creating new prompt (--new):
1. Prompt for alias with validation
2. Check alias doesn't already exist
3. Prompt for title (required)
4. Prompt for description (optional)
5. Prompt for input type with default "none"
6. If input is required/optional, prompt for hint
7. Generate filename from alias and title
8. Create file with frontmatter and template content
9. Ask if user wants to edit now

Validation (--doctor):
1. Find all .md files in agents/ai_prompts/
2. For each file:
   - Check filename format
   - Extract and validate alias
   - Check for duplicate aliases
   - Verify title exists or can be derived
   - Verify file is not empty
   - Check INPUT/input field consistency
3. Report warnings and errors
4. Exit 0 if only warnings, exit 1 if any errors

## Implementation Notes

Use full bash-template structure:
- Source bash_modules/terminal.sh for logging
- Source bash_modules/desktop.sh for clipboard
- Proper error handling with Ctrl-C trap
- Set -o pipefail for command chaining

Dependencies:
- fzf: Interactive fuzzy finder
- ripgrep (rg): Content search for --find
- xclip/pbcopy/xsel/wl-copy: Clipboard access
- $EDITOR: For --edit (defaults to vim)

Frontmatter parsing uses awk:
- No external YAML parser needed
- Simple field extraction sufficient
- Handles missing frontmatter gracefully

Path resolution:
- SCRIPT_DIR derived from BASH_SOURCE
- PROMPTS_DIR: ${SCRIPT_DIR}/agents/ai_prompts
- All file operations use absolute paths

Fuzzy matching algorithm:
- Substring matching on alias
- If single match, suggest with confirmation
- If multiple matches, show list
- If no matches, fall back to fzf

## Updates

- 2026-01-18: Initial design and implementation
