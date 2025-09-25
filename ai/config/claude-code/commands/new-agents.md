---
description: Create a new AGENTS.md document for the current project
argument-hint: [project-type] [additional-context]
allowed-tools: Read(*), Write(*), Glob(*), Grep(*), WebFetch(*)
---

# Create New AGENTS.md Document

You are tasked with creating a comprehensive AGENTS.md document for this project. This document should serve as a "README for agents" - providing AI coding agents with the context and instructions they need to work effectively on this project.

## Instructions

1. **Read the latest AGENTS.md specification** from https://agents.md/ to understand the current format and best practices.

2. **Analyze the current project** by:
   - Reading existing README.md, package.json, or similar configuration files
   - Understanding the project structure and technology stack
   - Identifying build systems, test frameworks, and development workflows
   - Finding code style configurations (ESLint, Prettier, etc.)
   - Discovering any existing documentation or contribution guidelines

3. **Create a comprehensive AGENTS.md** that includes relevant sections such as:
   - **Project overview** - Brief description of what the project does
   - **Setup commands** - How to install dependencies and set up the development environment
   - **Build and test commands** - How to build, test, and validate the project
   - **Code style guidelines** - Formatting rules, naming conventions, architectural patterns
   - **Development workflow** - Branch management, commit message format, PR guidelines
   - **Testing instructions** - How to run tests, add new tests, test coverage requirements
   - **Security considerations** - Any security-specific requirements or gotchas
   - **Deployment** - How the project is deployed (if applicable)
   - **Troubleshooting** - Common issues and their solutions

4. **Follow AGENTS.md best practices**:
   - Use standard CommonMark Markdown format
   - Be specific and actionable - include exact commands
   - Focus on information that agents need but might not be in README.md
   - Keep it concise but comprehensive
   - Use code blocks with proper syntax highlighting
   - Include any project-specific conventions or requirements

5. **Consider the project type** if specified in arguments:
   - $1 (project-type): Tailor the document for specific project types (web app, library, CLI tool, etc.)
   - $2 (additional-context): Include any additional context or specific requirements

## Additional Context

$ARGUMENTS

Remember: AGENTS.md should complement, not replace, existing documentation. Focus on the technical details and workflows that coding agents need to work effectively on this project.
