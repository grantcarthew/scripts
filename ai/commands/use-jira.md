---
allowed-tools: Bash(jira:*)
argument-hint: [action] [issue-key|search-query] [additional-args]
description: Jira CLI operations for issue management and project workflows
model: claude-3-5-haiku-20241022
---

# Jira CLI Command Reference

## Actions

`create` `list` `view` `edit` `assign` `comment` `move` `delete` `link` `clone` `watch` `worklog`

## Common Flags

- `-t, --type` Issue type (Bug, Task, Story, Epic)
- `-s, --summary` Issue title/summary
- `-b, --body` Issue description
- `-y, --priority` Priority (High, Medium, Low)
- `-a, --assignee` Assignee (username/email/display name, `x` to unassign)
- `-l, --label` Labels (multiple allowed)
- `-C, --component` Components (multiple allowed)
- `-P, --parent` Parent issue key
- `-p, --project` Override default project
- `--web` Open in browser after action
- `--no-input` Disable interactive prompts
- `--raw` JSON output
- `--plain` Plain table output
- `-T, --template` Load from file (`-` for stdin)

## Command Examples

### Create

```bash
jira issue create  # interactive
jira issue create -tBug -s"Summary" -yHigh -lbug -b"Description"
jira issue create --custom story-points=3 -tStory -s"Title"
echo "Text" | jira issue create -s"Summary" -tTask
```

**Additional:** `--custom key=value` for custom fields

### List

```bash
jira issue list "search text"  # text search
jira issue list -yHigh -s"In Progress" --created month -lbackend
jira issue list -ax  # unassigned issues
jira issue list --watching --history
jira issue list --plain --columns key,assignee,status --paginate 10:50
jira issue list -q"project IS NOT EMPTY"  # raw JQL
jira issue list --csv --raw
```

**Additional:** `-r, --reporter` Reporter filter | `--created/--updated` Date filters (today, week, month, year, yyyy-mm-dd, -10d) | `--no-headers` `--no-truncate` `--columns` `--paginate <from>:<limit>` Plain mode options

### View

```bash
jira issue view ISSUE-1
jira issue view ISSUE-1 --comments 5 --raw --plain
```

### Edit

```bash
jira issue edit ISSUE-1 -s"Summary" -yHigh -lurgent
jira issue edit ISSUE-1 -l-urgent -C-BE --fix-version -v1.0  # remove with minus prefix
echo "Text" | jira issue edit ISSUE-1 --no-input
```

**Additional:** `--skip-notify` Don't notify watchers | `--fix-version` `--affects-version` Release info

### Assign

```bash
jira issue assign ISSUE-1 user@example.com  # or "Name" (exact match)
jira issue assign ISSUE-1 $(jira me)  # self
jira issue assign ISSUE-1 default  # default assignee
jira issue assign ISSUE-1 x  # unassign
```

### Comment

```bash
jira issue comment add ISSUE-1 "Comment text"
jira issue comment add ISSUE-1 $'Multi\nline' --internal
echo "Text" | jira issue comment add ISSUE-1
```

**Additional:** `--internal` Internal comment

### Move (Transition)

```bash
jira issue move ISSUE-1 "In Progress"
jira issue move ISSUE-1 Done --comment "Completed" -a"user@example.com" -RFixed
```

**Additional:** `-R, --resolution` Set resolution

### Delete

```bash
jira issue delete ISSUE-1
jira issue delete ISSUE-1 --cascade  # with subtasks
```

### Link

```bash
jira issue link ISSUE-1 ISSUE-2 Blocks  # or Duplicates, Relates, Causes
```

### Clone

```bash
jira issue clone ISSUE-1 -s"New summary" -yHigh
jira issue clone ISSUE-1 -H"find:replace"  # text replacement
```

**Additional:** `-H, --replace` Replace text (format: `search:replace`)

### Watch

```bash
jira issue watch ISSUE-1 user@example.com  # or $(jira me)
```

### Worklog

```bash
jira issue worklog add ISSUE-1 "2d 1h 30m"  # format: d=days h=hours m=minutes
jira issue worklog add ISSUE-1 "3h" --comment "Work" --started "2024-01-15 09:30:00" --timezone "Australia/Brisbane"
jira issue worklog add ISSUE-1 "2h" --new-estimate "3h"
```

**Additional:** `--started` Datetime (yyyy-mm-dd HH:MM:SS) | `--timezone` IANA timezone | `--new-estimate` Update estimate

## Other Commands

```bash
jira me  # current user
jira open ISSUE-1  # open in browser
jira serverinfo  # server info
jira init  # initialize config
```

Global: `-c, --config` Config path | `--debug` Debug output

## Usage Notes

Analyze chat context to determine appropriate flags. Use `--raw` for JSON, `--plain` for tables, `--csv` for exports, or interactive mode when unclear.
