---
allowed-tools: Bash(get-jiraissue:*), Bash(get-jiraissuecomment:*), Bash(add-jiraissuecomment:*), Bash(get-jiracurrentuser:*), Bash(open-jiraissue:*), Bash(set-jiraissueassignee:*)
argument-hint: [issue-key]
description: Work with Jira issues including getting issue content, user, comments, and creating comments.
---

Work with Jira issues with the issue-key of $ARGUMENTS.

The following Jira scripts exist:

- add-jiraissuecomment    Add Jira Issue Comment
- get-jiracurrentuser     Jira Current User Information
- get-jiraissue           Jira Issue Viewer
- get-jirasettings        Jira Settings Configuration
- move-jiraissue          Move Jira Issue
- new-jiraissue           Create New Jira Issue
- open-jiraissue          Open Jira Issue in Browser
- remove-jiraissue        Delete Jira Issue
- set-jiraissueassignee   Assign Jira Issue
- set-jirateammembers     Manage Jira Team Members
