---
argument-hint: [action] [pipeline-id|job-id|branch] [additional-args]
description: GitLab CLI operations for pipeline debugging and CI/CD management
allowed-tools: Bash(glab:*), mcp__fetch__fetch_markdown
---

# GitLab Pipeline Assistant

Help with GitLab CI/CD operations using glab CLI: $ARGUMENTS

## Quick Actions

Based on the arguments provided, perform the most relevant GitLab operation:

### Pipeline Operations

- **status** - Show current pipeline status
- **debug [pipeline-id]** - Debug a failed pipeline with detailed analysis
- **trace [job-name]** - Follow job logs in real-time
- **retry [pipeline-id]** - Retry failed pipeline
- **cancel [pipeline-id]** - Cancel running pipeline

### Repository Operations

- **lint** - Validate .gitlab-ci.yml configuration
- **config** - Show compiled CI configuration
- **run [branch]** - Trigger new pipeline on branch

### Analysis Operations

- **failed** - List recent failed pipelines with analysis
- **summary [pipeline-id]** - Get comprehensive pipeline summary

## Smart Defaults

If no specific action provided:

1. Check current pipeline status
2. If failed, provide debug information
3. Suggest next steps based on status

## Reference Integration

When needed, fetch current GitLab CI documentation:

- GitLab CI YAML reference: https://docs.gitlab.com/ci/yaml/
- Pipeline troubleshooting guides
- Best practices documentation

## Context-Aware Help

Provide actionable suggestions based on pipeline state:

- **Failed jobs**: Show logs, suggest fixes, provide retry options
- **Pending pipelines**: Show queue status and estimated time
- **Successful pipelines**: Show duration and job details
- **Cancelled pipelines**: Show reason and restart options

## Command Examples

### Essential glab Commands

```bash
# Quick status check
glab ci status --compact

# Debug failed pipeline
glab ci get -p $1 --with-job-details
glab ci trace $2

# Lint configuration
glab ci lint --dry-run --include-jobs

# Trigger new pipeline
glab ci run -b $1

# List recent failures
glab ci list --status=failed --per-page=5
```

### Advanced Operations

```bash
# Repository-specific operations
glab ci status -R owner/repo

# Live monitoring
glab ci status --live

# View compiled configuration
glab ci config compile

# Cancel operations
glab ci cancel pipeline $1
glab ci cancel job $1
```

Use `glab --help` or `glab ci --help` for complete command reference.
