---
allowed-tools: Bash(get-jiraissue:*), Bash(get-jiraissuecomment:*), Bash(add-jiraissuecomment:*), Bash(get-jiracurrentuser:*), Bash(open-jiraissue:*), Bash(set-jiraissueassignee:*), Bash(move-jiraissue:*), Bash(new-jiraissue:*), Bash(remove-jiraissue:*), Bash(set-jirateammembers:*)
argument-hint: [action] [issue-key] [additional-args]
description: Comprehensive Jira issue management with smart action detection
---

# Jira Issue Manager

Manage Jira issues: $ARGUMENTS

## Smart Action Detection

Based on arguments provided, automatically determine the best action:

### Issue Operations

- **view [issue-key]** - Display issue details and comments
- **comment [issue-key] [comment-text]** - Add comment to issue
- **assign [issue-key] [assignee]** - Assign issue to user
- **move [issue-key] [target-status]** - Change issue status
- **open [issue-key]** - Open issue in browser

### Issue Management

- **create [project] [summary] [description]** - Create new issue
- **delete [issue-key]** - Remove issue (with confirmation)

### User Operations

- **whoami** - Show current user information
- **team** - Manage team members

## Intelligent Defaults

If only issue key provided (e.g., `PROJ-123`):

1. Show issue summary and current status
2. Display recent comments
3. Show assignee and priority
4. Suggest common next actions

## Available Scripts

The following Jira CLI scripts are available:

| Script                  | Purpose            | Usage                  |
| ----------------------- | ------------------ | ---------------------- |
| `get-jiraissue`         | View issue details | Automatic when viewing |
| `get-jiraissuecomment`  | Get issue comments | Included in issue view |
| `add-jiraissuecomment`  | Add comment        | Used for commenting    |
| `get-jiracurrentuser`   | Current user info  | Used for whoami        |
| `open-jiraissue`        | Open in browser    | Used for open action   |
| `set-jiraissueassignee` | Assign issue       | Used for assign action |
| `move-jiraissue`        | Change status      | Used for move action   |
| `new-jiraissue`         | Create issue       | Used for create action |
| `remove-jiraissue`      | Delete issue       | Used for delete action |
| `set-jirateammembers`   | Manage team        | Used for team action   |

## Usage Examples

```bash
# Quick issue view
/jira PROJ-123

# Add comment
/jira comment PROJ-123 "Updated implementation"

# Assign issue
/jira assign PROJ-123 john.doe

# Move to in-progress
/jira move PROJ-123 "In Progress"

# Create new issue
/jira create MYPROJ "Bug fix needed" "Detailed description here"

# Open in browser
/jira open PROJ-123

# Check current user
/jira whoami
```

Focus on the most relevant information and suggest actionable next steps.
