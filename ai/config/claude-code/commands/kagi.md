---
argument-hint: <search-query> [options]
description: Enhanced internet search using Kagi search engine
allowed-tools: Bash(kagi:*)
---

# Kagi Search Assistant

Perform intelligent web search using Kagi: $ARGUMENTS

## Search Strategy

Enhance the search query for better results:

### Query Optimization

- **Technical Topics**: Add relevant technical keywords and version numbers
- **Documentation**: Include "docs", "documentation", "guide", or "tutorial"
- **Troubleshooting**: Add "error", "fix", "solution", or "troubleshoot"
- **Code Examples**: Include "example", "code", "implementation"
- **Best Practices**: Add "best practices", "patterns", "recommended"

### Search Modifiers

- Use quotes for exact phrases: `"exact phrase"`
- Exclude terms with minus: `-unwanted`
- Site-specific search: `site:github.com`
- File type search: `filetype:pdf`
- Date ranges: `after:2023`

## Search Processing

1. **Query Analysis**: Understand the search intent
2. **Query Enhancement**: Optimize search terms for better results
3. **Result Execution**: Run the Kagi search command
4. **Result Summary**: Provide key findings and relevant links

## Usage Examples

```bash
# Basic search
/kagi "Claude Code documentation"

# Technical search with modifiers
/kagi "bash script security best practices 2024"

# Documentation search
/kagi "Docker compose examples site:github.com"

# Troubleshooting search
/kagi "GitLab CI pipeline failed error fix"

# Code examples
/kagi "Python asyncio examples tutorial"
```

## Smart Suggestions

Based on search results, provide:

- **Most Relevant Links**: Top 3-5 most useful results
- **Quick Summary**: Key points from search results
- **Related Topics**: Suggest follow-up searches
- **Actionable Insights**: Next steps based on findings

Execute the search and provide a concise summary of the most valuable results.
