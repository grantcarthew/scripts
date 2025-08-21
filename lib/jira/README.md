# Jira CLI Library

A comprehensive collection of Bash scripts for interacting with Jira using the [jira-cli](https://github.com/ankitpokhrel/jira-cli) tool.

## Prerequisites

-   [jira-cli](https://github.com/ankitpokhrel/jira-cli) - `brew install ankitpokhrel/jira-cli/jira-cli`
-   [fzf](https://github.com/junegunn/fzf) - `brew install fzf`
-   Configured jira-cli with `jira init`

## Core Issue Management

### `get-jiraissue`

View a specific Jira issue or list issues interactively.

```bash
get-jiraissue                    # Interactive list and selection
get-jiraissue GCP-479            # View specific issue
get-jiraissue GCP-479 --comments 5   # View issue with 5 comments
get-jiraissue --list             # List issues only
```

### `new-jiraissue`

Create new Jira issues with interactive prompts or specified values.

```bash
new-jiraissue                              # Interactive mode
new-jiraissue -t Bug -s "Login issue"     # Quick bug creation
new-jiraissue --template bug-template.md  # Use template
```


### `remove-jiraissue`

Delete Jira issues with confirmation prompts.

```bash
remove-jiraissue GCP-479                    # Delete with confirmation
remove-jiraissue GCP-479 --cascade         # Delete with subtasks
remove-jiraissue GCP-479 --force           # Delete without confirmation
```

## State & Assignment Management

### `move-jiraissue`

Transition issues between states with interactive state selection (recommended).

```bash
move-jiraissue GCP-479                           # Interactive state selection (RECOMMENDED)
move-jiraissue GCP-479 --comment "Work done"    # Interactive with comment
move-jiraissue GCP-479 "Done"                   # Direct transition (if you know exact state name)
```

### `set-jiraissueassignee`

Assign issues to users (defaults to self if no assignee specified).

```bash
set-jiraissueassignee GCP-479                    # Assign to self (DEFAULT)
set-jiraissueassignee GCP-479 --interactive     # Interactive assignee selection
set-jiraissueassignee GCP-479 "john@company.com" # Assign to specific user
set-jiraissueassignee GCP-479 unassign          # Unassign issue
```

## Comments & Communication

### `add-jiraissuecomment`

Add comments to Jira issues.

```bash
add-jiraissuecomment GCP-479                     # Interactive comment
add-jiraissuecomment GCP-479 "Fixed the issue"  # Direct comment
add-jiraissuecomment GCP-479 --template comment.md  # From template
```

## Browser Integration

### `open-jiraissue`

Open Jira issues in browser or get URLs.

```bash
open-jiraissue                    # Open project page in browser
open-jiraissue GCP-479            # Open specific issue
open-jiraissue GCP-479 --no-browser  # Get issue URL only
```

## Settings Management

### `get-jirasettings`

Display current Jira settings and configuration.

```bash
get-jirasettings                    # Show formatted settings
```

### `set-jirateammembers`

Manage the team members list for assignee selection.

```bash
set-jirateammembers                           # Interactive management
set-jirateammembers --add john@company.com   # Add specific member
set-jirateammembers --remove                 # Remove members interactively
set-jirateammembers --list                   # Show current list
```

### Additional Settings Scripts

Note: Additional settings management scripts may be added in the future for labels, components, and projects.

## Utility Scripts

### `get-jiracurrentuser`

Display current Jira user information.

```bash
get-jiracurrentuser                    # Show current user
```

## Configuration

The library uses the settings framework with the following configurable options:

```bash
JIRA_TEAM_MEMBERS=("user1@domain.com" "user2@domain.com" "John Doe")
JIRA_COMMON_LABELS=("bug" "feature" "urgent" "backend" "frontend")
JIRA_COMPONENTS=("API" "UI" "Database" "Infrastructure")
JIRA_PROJECTS=("GCP" "OTHER")
JIRA_DEFAULT_PROJECT="GCP"
JIRA_ISSUE_TYPES=("Task" "Bug" "Story" "Epic")
JIRA_PRIORITIES=("Lowest" "Low" "Medium" "High" "Highest")
```

Use the settings management scripts to configure these values for your environment.

## Interactive Features

Most scripts support interactive mode using `fzf` for:

-   **Issue Type Selection**: Choose from configured issue types
-   **State Transitions**: Select from available transitions for the current issue state
-   **User Assignment**: Pick from your configured team members
-   **Project Switching**: Switch between available projects
-   **Priority Selection**: Choose from priority levels
-   **Label/Component Selection**: Multi-select from configured options

## API Compatibility Note

The `jira issue list` command is currently affected by Atlassian API changes. The scripts are designed to work when this is fixed in the jira-cli tool. In the meantime, individual issue operations work normally.

## Integration with Other Tools

Scripts are designed to work well with:

-   Shell scripting and automation
-   CI/CD pipelines
-   The existing scripts framework with logging and settings
-   Standard Unix tools (pipes, redirects, etc.)

## Getting Started

1.  Install dependencies: `brew install ankitpokhrel/jira-cli/jira-cli fzf`
2.  Configure jira-cli: `jira init`
3.  Set up your team and project settings using the settings management scripts
4.  Start using the interactive scripts for your Jira workflow

Use `? jira` to see all available scripts in this library.