# GitLab CLI (glab) Command Reference

Essential glab commands for LLM agents working with GitLab CI/CD pipelines and repositories.

Use the fetch markdown tool to read: https://docs.gitlab.com/ci/yaml/

After reading this document and the reference, I'll give you the pipeline or job ID. Ask me for the ID.

**USAGE:** `glab <command> <subcommand> [flags]`

**CORE COMMANDS:**

- `api`: Make authenticated requests to GitLab API
- `ci`: Work with CI/CD pipelines and jobs
- `config`: Manage glab settings
- `job`: Work with CI/CD jobs
- `mr`: Create, view, and manage merge requests
- `repo`: Work with repositories and projects
- `variable`: Manage project/group variables

**KEY ENVIRONMENT VARIABLES:**

- `GITLAB_TOKEN`: Authentication token for API requests
- `GITLAB_HOST` or `GL_HOST`: GitLab server URL (defaults to gitlab.com)
- `DEBUG`: Set to true for verbose logging
- `NO_PROMPT`: Set to true to disable prompts

## CI/CD Commands

**USAGE:** `glab ci <command> [flags]`

**ALIASES:** `pipe`, `pipeline`

**CORE COMMANDS:**

- `cancel`: Cancel a running pipeline or job
- `config`: Work with GitLab CI/CD configuration
- `get`: Get JSON of a running CI/CD pipeline
- `lint`: Checks if your `.gitlab-ci.yml` file is valid
- `list`: Get the list of CI/CD pipelines
- `retry`: Retry a CI/CD job
- `run`: Create or run a new CI/CD pipeline
- `status`: View a running CI/CD pipeline status
- `trace`: Trace a CI/CD job log in real time
- `trigger`: Trigger a manual CI/CD job
- `view`: View pipeline status and jobs

### glab ci config

Work with GitLab CI/CD configuration.

**COMMANDS:**

- `compile`: View the fully expanded CI/CD configuration

**Examples:**

```bash
# View expanded configuration from current directory
glab ci config compile

# View expanded configuration from specific file
glab ci config compile .gitlab-ci.yml
glab ci config compile path/to/.gitlab-ci.yml
```

### glab ci view

View pipeline status and jobs.

**USAGE:** `glab ci view [branch/tag] [flags]`

**FLAGS:**

- `-b, --branch string`: Check pipeline status for a branch or tag (defaults to current branch)
- `-w, --web`: Open pipeline in a browser

**Examples:**

```bash
# View current branch pipeline
glab ci view

# View main branch pipeline
glab ci view main
glab ci view -b main

# View specific repo pipeline
glab ci view -b main -R profclems/glab
```

### glab ci cancel

Cancel running pipelines or jobs.

**COMMANDS:**

- `job`: Cancel CI/CD jobs
- `pipeline`: Cancel CI/CD pipelines

## Detailed Command Reference

### glab ci trace

Trace a CI/CD job log in real time.

**USAGE:** `glab ci trace [<job-id>] [flags]`

**FLAGS:**

- `-b, --branch string`: The branch to search for the job (default: current branch)
- `-p, --pipeline-id int`: The pipeline ID to search for the job

**Examples:**

```bash
# Interactively select a job to trace
glab ci trace

# Trace job with specific ID
glab ci trace 224356863

# Trace job with specific name
glab ci trace lint

# Trace job from specific branch
glab ci trace -b main
```

### glab ci list

Get the list of CI/CD pipelines.

**USAGE:** `glab ci list [flags]`

**KEY FLAGS:**

- `-s, --status string`: Filter by pipeline status (running, pending, success, failed, etc.)
- `-r, --ref string`: Return only pipelines for given ref/branch
- `--source string`: Filter by trigger source (merge_request_event, push, trigger, etc.)
- `-F, --output string`: Format output (text, json)
- `-p, --page int`: Page number (default: 1)
- `-P, --per-page int`: Items per page (default: 30)

**Examples:**

```bash
# List all pipelines
glab ci list

# List only failed pipelines
glab ci list --status=failed

# List pipelines for main branch
glab ci list --ref=main

# List merge request pipelines in JSON format
glab ci list --source=merge_request_event --output=json
```

### glab ci lint

Checks if your `.gitlab-ci.yml` file is valid.

**USAGE:** `glab ci lint [flags]`

**FLAGS:**

- `--dry-run`: Run pipeline creation simulation
- `--include-jobs`: Include list of jobs in response
- `--ref string`: Set branch/tag context for validation (used with --dry-run)

**Examples:**

```bash
# Validate .gitlab-ci.yml in current directory
glab ci lint

# Validate specific file
glab ci lint .gitlab-ci.yml
glab ci lint path/to/.gitlab-ci.yml

# Dry run simulation with job details
glab ci lint --dry-run --include-jobs --ref=main
```

### glab ci run

Create or run a new CI/CD pipeline.

**USAGE:** `glab ci run [flags]`

**ALIASES:** `create`

**KEY FLAGS:**

- `-b, --branch string`: Create pipeline on specific branch/ref
- `--mr`: Run merge request pipeline instead of branch pipeline
- `--variables strings`: Pass variables in format `key:value` (not for MR pipelines)
- `-f, --variables-from string`: JSON file with variables (not for MR pipelines)
- `-w, --web`: Open pipeline in browser

**Important Notes:**

- Variable options are incompatible with merge request pipelines
- The `--branch` option is available for all pipeline types

**Examples:**

```bash
# Run pipeline on current branch
glab ci run

# Run pipeline on specific branch
glab ci run -b main

# Run pipeline with variables
glab ci run --variables "key1:value1,key2:value2"

# Run pipeline with environment variables
glab ci run -b main --variables-env key1:val1 --variables-env key2:val2

# Run pipeline with file variables
glab ci run -b main --variables-file MYKEY:file1 --variables KEY2:some_value

# Run merge request pipeline
glab ci run --mr

# Run pipeline and open in browser
glab ci run --web
```

### glab ci get

Get JSON of a running CI/CD pipeline.

**USAGE:** `glab ci get [flags]`

**ALIASES:** `stats`

**FLAGS:**

- `-b, --branch string`: Check pipeline for specific branch (default: current branch)
- `-p, --pipeline-id int`: Get specific pipeline by ID
- `-d, --with-job-details`: Show extended job information
- `--with-variables`: Show variables in pipeline (requires Maintainer role)
- `-F, --output string`: Format output (text, json)

**Examples:**

```bash
# Get current branch pipeline
glab ci get

# Get pipeline by ID with job details
glab ci get -p 12345 --with-job-details

# Get main branch pipeline in JSON
glab ci get -b main -F json

# Get pipeline from different repo
glab ci get -R some/project -p 12345
```

### glab ci status

View a running CI/CD pipeline status.

**USAGE:** `glab ci status [flags]`

**ALIASES:** `stats`

**FLAGS:**

- `-b, --branch string`: Check pipeline for specific branch (default: current branch)
- `-c, --compact`: Show status in compact format
- `-l, --live`: Show status in real time until pipeline ends

**Examples:**

```bash
# Get current branch pipeline status
glab ci status

# Get main branch pipeline status
glab ci status --branch=main

# Compact view of pipeline status
glab ci status --compact

# Live view that updates in real time
glab ci status --live
```

## Common Workflows

### Debugging Failed Pipelines

```bash
# Check current pipeline status
glab ci status --compact

# List recent failed pipelines
glab ci list --status=failed --per-page=5

# Get detailed info about specific pipeline
glab ci get -p PIPELINE_ID --with-job-details

# Trace specific failed job
glab ci trace JOB_NAME
```

### Validating CI Configuration

```bash
# Lint .gitlab-ci.yml file
glab ci lint --dry-run --include-jobs

# View compiled configuration
glab ci config compile

# Run pipeline on specific branch
glab ci run -b branch-name
```

### Repository Flag

All commands support the `-R, --repo` flag to work with different repositories:

```bash
glab ci status -R owner/repo
glab ci list -R group/namespace/repo --status=failed
```
