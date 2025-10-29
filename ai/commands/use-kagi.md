---
argument-hint: <search-query>
description: Enhanced internet search using Kagi search engine
allowed-tools: Bash(kagi:*)
model: claude-3-5-haiku-20241022
---

# Kagi Search

Search the web using Kagi search engine with `$ARGUMENTS`

## Usage

```bash
kagi "search terms"
kagi "Claude Code documentation"
kagi "GitLab CI pipeline troubleshooting"
kagi "Python asyncio examples"
```

## Search Modifiers

- `"exact phrase"` Exact phrase match
- `-term` Exclude term
- `site:domain.com` Limit to specific site
- `filetype:pdf` Limit to file type
- `after:2023` Date filter
- `before:2024` Date filter

## Examples

```bash
kagi "Docker compose examples site:github.com"
kagi "bash script security -wordpress"
kagi "GitLab CI YAML reference after:2024"
kagi "Go concurrency patterns filetype:pdf"
```

Execute search and summarize key findings with relevant links.
