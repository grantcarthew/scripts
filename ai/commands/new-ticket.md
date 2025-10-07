---
argument-hint: [issue-summary] [issue-type:Task|Bug|Story|Epic]
description: Create a new Jira issue in GCP project, analyze chat for context, assign to Grant, and set appropriate status
allowed-tools: mcp__atlassian__*, Bash(*)
model: claude-sonnet-4-5@20250929
disable-model-invocation: false
categories: [jira, workflow]
---

# Create New Jira Ticket with Chat Analysis

You are creating a new Jira issue for Grant Carthew in the GCP project. Follow these steps:

## 1. Chat Analysis

Analyze the entire conversation history to understand:

- What work has been requested or completed
- Technical details and implementation approaches
- Any challenges, solutions, or outcomes
- Current state: planning, in-progress, or completed

## 2. Issue Creation Parameters

- **Project**: GCP (Grant's default project)
- **Issue Type**: $2 (default to "Task" if not specified)
- **Summary**: $1 (or generate from chat analysis if not provided)

## 3. Issue Content Strategy

### Summary

- Use $1 if provided, otherwise generate a clear, concise summary (max 60 chars)
- Format: "{{component-or-system}} | {{brief-description-of-work}}"
- Examples: "Cloud Run | User authentication system investigation"

### Description

Create a comprehensive description using this template:

```markdown
## Overview

[Brief description of the work/issue]

## Technical Details

[Key technical aspects, technologies, or approaches discussed]

## Requirements

[Specific requirements or acceptance criteria identified]

## Implementation Notes

[Any implementation decisions, code changes, or technical considerations]

## Context

[Additional context from the conversation that provides background]
```

### Status and Comments Strategy

**If work appears to be completed:**

- Set initial status to "In Progress"
- Add detailed comment with resolution
- Transition to "Done"

**If work is in progress:**

- Set status to "In Progress"
- Add comment with current progress

**If work is in planning:**

- Keep status as default (usually "To Do")
- Add comment with planning details

## 4. Execution Steps

1. **Create the issue** using `mcp__atlassian__createJiraIssue`
2. **Add detailed comment** using `mcp__atlassian__addCommentToJiraIssue`
3. **Transition status if needed** using `mcp__atlassian__transitionJiraIssue`

## 5. Comment Template

Use this markdown template for the detailed comment:

```markdown
## Chat Analysis Summary

### Work Performed

[Detailed breakdown of what was accomplished]

### Technical Implementation

[Code changes, configurations, or technical work completed]

### Challenges & Solutions

[Any issues encountered and how they were resolved]

### Current Status

[Current state of the work]

### Next Steps

[Any follow-up work needed or recommendations]

---
```

## 6. Error Handling

- If issue creation fails, provide clear error message and suggested fixes
- If status transition fails, explain available transitions
- Validate that all required tools are accessible

## 7. Output Format

Provide a summary of actions taken:

- Issue key and URL
- Status set
- Comment added
- Any transitions performed

Start the process now, analysing the chat history and creating the appropriate Jira issue.
