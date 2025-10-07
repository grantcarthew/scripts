# Computer and User Information

The following information is for AI Agents to learn specifics of the user and environment they are running in.

## User

- Name: Grant Carthew
- Skills: Expert in IT and a number of programming languages
- Language: Australian English
- Location: Brisbane, Queensland, Australia
- Company: Auto & General Insurance
- Document Style: CommonMark

## Operating System

- OS: macOS Tahoe 26.0 arm64
- CPU: Apple M4 Pro (14 cores) @ 4.51 GHz
- Memory: 24.00 GiB
- Shell: bash 5.3.3
- Architecture: arm64 (Apple Silicon)
- Locale: en_AU.UTF-8

## Terminal

- Ghostty 1.2.0: Fast, feature-rich, cross-platform terminal emulator
  - Terminal type: `xterm-ghostty`
  - Color support: 256 colors + truecolor
  - Font engine: CoreText (macOS native)
  - Renderer: Metal (GPU-accelerated)

## CLI Tools

Run `--help` argument for syntax.

Prefer these tools over other Bash built-in tools.

- checkov: Static code analysis tool for infrastructure-as-code
- coreutils: GNU File, Shell, and Text utilities
- csvkit: Suite of command-line tools for converting to and working with CSV
  - in2csv: Convert common, but less awesome, tabular data formats to CSV
  - sql2csv: Execute a SQL query on a database and output the result to a CSV file
  - csvclean: Report and fix common errors in a CSV file
  - csvcut: Filter and truncate CSV files. Like the Unix "cut" command, but for tabular data
  - csvgrep: Search CSV files. Like the Unix "grep" command, but for tabular data
  - csvjoin: Execute a SQL-like join to merge CSV files on a specified column or columns
  - csvsort: Sort CSV files. Like the Unix "sort" command, but for tabular data
  - csvstack: Stack up the rows from multiple CSV files, optionally adding a grouping value
  - csvformat: Convert a CSV file to a custom output format
  - csvjson: Convert a CSV file into JSON (or GeoJSON)
  - csvlook: Render a CSV file in the console as a Markdown-compatible, fixed-width table
  - csvpy: Load a CSV file into a CSV reader and then drop into a Python shell
  - csvsql: Generate SQL statements for one or more CSV files, or execute those statements directly on a database, and execute one or more SQL queries
  - csvstat: Print descriptive statistics for each column in a CSV file
- difft: difftastic - A structural diff that understands syntax
- entr: Run arbitrary commands when files change
- fd: A simple, fast and user-friendly alternative to 'find'
- glab: GitLab CLI tool
- glow: Render markdown on the CLI, with pizzazz!
- gnupg: GNU Pretty Good Privacy (PGP) package
- gron: Make JSON greppable!
- helm: The Kubernetes Package Manager
- hq: A HTML processor inspired by jq
- hyperfine: A command-line benchmarking tool
- jira-cli: Command line tool for Atlassian Jira
- jless: JSON viewer designed for reading, exploring, and searching through JSON data
- jq: Command-line JSON processor
- kubectx: Tool to switch between contexts (clusters) on kubectl
- lsd: The next gen ls command
- mise: dev tools, env vars, task runner
- mtr: Combines the functionality of traceroute and ping into one tool
- neovim: Better vim
- newrelic-cli: Command line interface for New Relic
- ngrep: GNU grep applied to the network layer
- oha: HTTP load generator
- pandoc: Swiss-army knife of markup format conversion
- prettier: Code formatter for JavaScript, CSS, JSON, GraphQL, Markdown, YAML
- procs: A modern replacement for ps written in Rust
- psql: postgresql - Object-relational database system
- ripgrep: Better file text search
- rsync: Efficiently transferring and synchronizing files
- sd: Intuitive find & replace CLI (sed alternative)
- shellcheck: Finds bugs in your shell scripts
- terraform-docs: Generate documentation from Terraform modules
- tflint: Terraform linter
- trivy: Scanner for vulnerabilities in container images, file systems, and Git repositories
- yamllint: Linter for YAML files
- yq: YAML, JSON, XML, CSV, TOML and properties processor

## Special Commands

- `kagi <search-terms>`: Search the internet returning clean search results for AI agent use
- `ff <search-terms>`: Open a new tab in Firefox searching Kagi for the search terms for the user to view
- `curl https://raw.githubusercontent.com/{{repo-and-path}}`: Use curl when getting content from GitHub raw URLs

## get-webpage

This is a special CLI tool designed for AI agents to get web pages as Markdown.

This tool will enable the ability to access pages authenticated by the user.

Usage: get-webpage <url> [options]

Examples:

- get-webpage example.com
- get-webpage https://example.com --output page.md
- get-webpage app.example.com/docs --wait-for ".content-loaded"
- get-webpage private.example.com --force-visible
- get-webpage localhost:3000 --html
- get-webpage 192.168.1.100:8080 --timeout 60

## Atlassian Configuration

### Atlassian Cloud Instance

- **Cloud ID**: `fcd4dd07-1eac-4c63-b213-3f8c02d7ad61`
- **Site URL**: `https://autogeneral-au.atlassian.net`
- **Organization**: Auto General

### Jira

- **Primary Project**: GCP (Project Key: `GCP`)
- **Board URL**: https://autogeneral-au.atlassian.net/jira/software/c/projects/GCP/boards/1342?assignee=712020%3Af0aa8349-1860-4d9d-bf31-d12e26b85d84
- **User Account ID**: `712020:f0aa8349-1860-4d9d-bf31-d12e26b85d84`

_Note: When I say "ticket" I am talking about Jira Issues._

### Confluence

- **Primary Space**: Cloud Security Architecture (Space Key: `CSA1`)
- **Space URL**: https://autogeneral-au.atlassian.net/wiki/spaces/CSA1/overview?homepageId=988841763

## Command Restrictions

- Use RipGrep `rg` instead of grep
- Use `lsd --tree [dir]` for a directory tree
- Use `fd` for finding files

