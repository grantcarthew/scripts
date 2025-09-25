---
argument-hint: <url> [format]
description: Fetch web content using MCP fetch tools with format selection
allowed-tools: mcp__fetch__fetch_markdown, mcp__fetch__fetch_html, mcp__fetch__fetch_txt, mcp__fetch__fetch_json
---

# Web Content Fetcher

Fetch content from the specified URL: $1

## Format Selection

Use format: $2 (if specified, otherwise auto-select based on URL and content type)

### Available Formats

- **markdown** - `mcp__fetch__fetch_markdown` - Clean markdown conversion (default for most web content)
- **html** - `mcp__fetch__fetch_html` - Raw HTML source
- **text** - `mcp__fetch__fetch_txt` - Plain text with HTML stripped
- **json** - `mcp__fetch__fetch_json` - JSON content for APIs

### Auto-Selection Rules

If no format specified:

1. **JSON APIs**: Use `json` format for URLs containing `/api/`, `.json`, or API endpoints
2. **Documentation**: Use `markdown` format for docs, wikis, README files
3. **Raw HTML needed**: Use `html` format when HTML structure analysis required
4. **Content extraction**: Use `text` format for simple text extraction
5. **Default**: Use `markdown` format for general web content

## Usage Examples

```bash
# Fetch as markdown (default)
/fetch https://docs.example.com/guide

# Fetch specific format
/fetch https://api.example.com/data json
/fetch https://example.com/page html
/fetch https://news.example.com/article text
```
