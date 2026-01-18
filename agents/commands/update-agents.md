---
description: Update the existing AGENTS.md document for the current project
argument-hint: [action] [section] [content]
allowed-tools: Read(*), Edit(*), Glob(*), Grep(*), WebFetch(*)
---

# Update AGENTS.md Document

You are tasked with updating the existing AGENTS.md document for this project. This document serves as a "README for agents" - providing AI coding agents with the context and instructions they need to work effectively on this project.

## Instructions

1. **Read the latest AGENTS.md specification** from <https://agents.md/> to ensure compliance with current format and best practices.

2. **Read the current AGENTS.md file** to understand the existing structure and content.

3. **Analyze the current project state** by:
   - Reading existing README.md, package.json, or similar configuration files
   - Understanding any recent changes to project structure or technology stack
   - Identifying new build systems, test frameworks, or development workflows
   - Finding updated code style configurations (ESLint, Prettier, etc.)
   - Discovering new documentation or contribution guidelines

4. **Update the AGENTS.md** based on:
   - **$1 (action)**: The type of update needed (add, update, remove, refresh)
   - **$2 (section)**: Specific section to update (setup, build, style, workflow, testing, security, deployment, troubleshooting)
   - **$3 (content)**: Additional context or specific content to add/update

5. **Ensure comprehensive coverage** of relevant sections:
   - **Project overview** - Brief description of what the project does
   - **Setup commands** - How to install dependencies and set up the development environment
   - **Build and test commands** - How to build, test, and validate the project
   - **Code style guidelines** - Formatting rules, naming conventions, architectural patterns
   - **Development workflow** - Branch management, commit message format, PR guidelines
   - **Testing instructions** - How to run tests, add new tests, test coverage requirements
   - **Security considerations** - Any security-specific requirements or gotchas
   - **Deployment** - How the project is deployed (if applicable)
   - **Troubleshooting** - Common issues and their solutions

6. **Follow AGENTS.md best practices**:
   - Use standard CommonMark Markdown format
   - Be specific and actionable - include exact commands
   - Focus on information that agents need but might not be in README.md
   - Keep it concise but comprehensive
   - Use code blocks with proper syntax highlighting
   - Include any project-specific conventions or requirements
   - Remove outdated or incorrect information
   - Ensure consistency across sections

7. **Actions Guide**:
   - **add**: Add new section or content to existing section
   - **update**: Modify existing section with new information
   - **remove**: Delete outdated or incorrect content
   - **refresh**: Review entire document and update based on current project state

## Additional Context

$ARGUMENTS

Remember: AGENTS.md should complement, not replace, existing documentation. Focus on keeping the technical details and workflows current so coding agents can work effectively on this project.
