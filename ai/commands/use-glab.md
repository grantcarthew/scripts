---
argument-hint: [action] [pipeline-id|job-id|branch] [additional-args]
description: GitLab CLI operations for pipeline debugging and CI/CD management
allowed-tools: Bash(glab:*), mcp__fetch__fetch_markdown
model: claude-3-5-haiku-20241022
---

# GitLab CLI Command Reference

## CI/CD Actions

`status` `list` `view` `trace` `get` `run` `lint` `retry` `cancel` `delete` `config`

## Common Flags

- `-R, --repo OWNER/REPO` Select repository (OWNER/REPO, GROUP/NAMESPACE/REPO, or full URL)
- `-b, --branch` Branch/ref to operate on (default: current branch)
- `-p, --pipeline-id` Pipeline ID
- `-F, --output` Output format (text, json)
- `-w, --web` Open in browser
- `--dry-run` Simulate without executing

## Command Examples

### Status

```bash
glab ci status  # current branch
glab ci status -b main --live  # real-time monitoring
glab ci status --compact  # compact view
```

### List

```bash
glab ci list  # recent pipelines
glab ci list -s failed --per-page 5  # failed pipelines
glab ci list --status running --scope branches
glab ci list -r main -u username --updated-after 2024-01-01T00:00:00Z
glab ci list --yaml-errors  # invalid configurations
glab ci list -F json  # JSON output
```

**Additional:** `-n, --name` Pipeline name | `-r, --ref` Ref filter | `--sha` SHA filter | `--scope` Scope (running, pending, finished, branches, tags) | `--source` Source (merge_request_event, push, trigger, etc.) | `-u, --username` User filter | `-a, --updated-after` `-b, --updated-before` Date filters (ISO 8601) | `-o, --orderBy` Order by (id, status, ref, updated_at, user_id) | `--sort` Sort (asc, desc) | `-p, --page` `--per-page` Pagination

### View

```bash
glab ci view  # interactive TUI for current branch
glab ci view main  # view main branch pipeline
glab ci view -b develop -w  # open in browser
```

**Interactive controls:** Enter=toggle logs/traces | Esc/q=close | Ctrl+R/P=run/retry/play | Ctrl+D=cancel | Ctrl+Q=quit | Ctrl+Space=suspend and view logs | vi bindings supported

### Trace

```bash
glab ci trace  # interactive job selection
glab ci trace 224356863  # trace by job ID
glab ci trace lint  # trace by job name
glab ci trace -p 12345  # trace from specific pipeline
```

### Get

```bash
glab ci get  # current branch pipeline
glab ci get -p 12345 -d  # with job details
glab ci get -b main --with-variables -F json
```

**Additional:** `-d, --with-job-details` Extended job info | `--with-variables` Show variables (requires Maintainer)

### Run

```bash
glab ci run  # current branch
glab ci run -b main --web
glab ci run --mr  # merge request pipeline
glab ci run --variables "key1:value1,key2:value2"
glab ci run --variables-env key:val --variables-file MYKEY:file1
glab ci run --input "replicas:int(3)" --input "debug:bool(false)"
glab ci run --input "regions:array(us-east,eu-west)"
glab ci run -f variables.json  # from JSON file
```

**Input types:** `string(val)` (default) | `int(42)` | `float(3.14)` | `bool(true)` | `array(foo,bar)`

**Additional:** `-i, --input` Pipeline inputs (key:value or key:type(value)) | `--variables` Variables (key:value) | `--variables-env` `--variables-file` Variable sources | `-f, --variables-from` JSON file with variables

### Lint

```bash
glab ci lint  # validate .gitlab-ci.yml
glab ci lint path/to/.gitlab-ci.yml
glab ci lint --dry-run --include-jobs  # simulation with job list
glab ci lint --dry-run --ref main  # validate against branch context
```

**Additional:** `--dry-run` Pipeline simulation | `--include-jobs` Show jobs | `--ref` Branch/tag context

### Retry

```bash
glab ci retry  # interactive selection
glab ci retry 224356863  # retry by job ID
glab ci retry lint  # retry by job name
glab ci retry -p 12345  # retry from specific pipeline
```

### Cancel

```bash
glab ci cancel pipeline 12345
glab ci cancel job 224356863
```

### Delete

```bash
glab ci delete 34  # delete pipeline ID 34
glab ci delete 12,34,56  # delete multiple
glab ci delete --status failed --dry-run
glab ci delete --older-than 24h --status failed
glab ci delete --source api --paginate
```

**Additional:** `--older-than` Duration filter (h, m, s) | `--source` Source filter (api, push, schedule, trigger, web, etc.) | `-s, --status` Status filter | `--paginate` Fetch all pages | `--page` `--per-page` Pagination

### Config

```bash
glab ci config compile  # view fully expanded configuration
```

## Other Commands

### Merge Requests

```bash
glab mr list  # list MRs
glab mr create --fill --label bugfix
glab mr view 123
glab mr approve 123
glab mr merge 123
glab mr checkout 123
```

### Repository

```bash
glab repo view  # view repository
glab repo clone OWNER/REPO
glab api /projects/:id/pipelines  # direct API access
```

### Authentication

```bash
glab auth status  # check auth status
glab auth login  # authenticate
```

## Usage Notes

Analyze chat context to determine appropriate action and flags. Use `--web` to open in browser, `-F json` for programmatic processing, `--live` for real-time monitoring, or interactive mode when unclear. For debugging failed pipelines, combine `glab ci get -d` with `glab ci trace` for job logs.

## GitLab CI/CD Docs

When troubleshooting, reference: https://docs.gitlab.com/ci/yaml/
