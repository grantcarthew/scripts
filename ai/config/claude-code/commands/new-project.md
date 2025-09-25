---
argument-hint: [project-name] [project-type] [description]
description: Generate a new PROJECT.md document from current session context
allowed-tools: Read, Write, Edit, Glob, Grep
---

# New Project Documentation Generator

Create a comprehensive PROJECT.md document based on current session context: $ARGUMENTS

## Auto-Discovery Mode

If no arguments provided, analyze the current conversation to automatically generate a PROJECT.md:

1. **Session Context Analysis**: Extract project goals, technologies, and decisions
2. **Codebase Detection**: Scan for existing files to understand project structure
3. **Technology Stack Identification**: Detect frameworks, languages, and tools
4. **Documentation Generation**: Create structured PROJECT.md with relevant sections

## Manual Mode

Specify project details explicitly:

- **$1 (project-name)**: Name of the project
- **$2 (project-type)**: Type (web-app, cli-tool, library, etc.)
- **$3 (description)**: Brief project description

## Generation Process

### 1. Context Analysis

Analyze the current session for:
- **Project objectives** and goals mentioned
- **Technologies** and frameworks discussed
- **Architecture decisions** made
- **Implementation approaches** chosen
- **Key requirements** identified

### 2. Codebase Scanning

Use available tools to discover:
- **File structure** and organization
- **Configuration files** (package.json, Cargo.toml, etc.)
- **Documentation** already present
- **Build systems** and tooling
- **Dependencies** and libraries

### 3. Document Structure

Generate PROJECT.md with these sections:

#### Core Information
- **Project Overview**: Name, description, and purpose
- **Technology Stack**: Languages, frameworks, and tools
- **Getting Started**: Setup and installation instructions
- **Project Structure**: Directory layout and organization

#### Development Context
- **Current Status**: What's been accomplished
- **Active Development**: What's currently being worked on
- **Next Steps**: Planned features and improvements
- **Architecture**: Key design decisions and patterns

#### Reference Materials
- **Dependencies**: External libraries and tools
- **Configuration**: Important config files and settings
- **Commands**: Key development and build commands
- **Resources**: Relevant documentation and links

## Intelligence Features

### Smart Content Detection

- **Framework Recognition**: Automatically detect React, Vue, Express, etc.
- **Build Tool Detection**: Identify webpack, vite, cargo, npm scripts
- **Testing Setup**: Find test frameworks and configurations
- **Deployment Config**: Locate Docker, CI/CD, deployment files

### Context Synthesis

- **Goal Extraction**: Pull project objectives from conversation
- **Decision Tracking**: Document architectural choices made
- **Progress Summary**: Summarize work completed in session
- **Problem Solutions**: Document issues solved and approaches

### Template Selection

Choose appropriate PROJECT.md template based on:
- **Web Applications**: Frontend/backend structure
- **CLI Tools**: Installation, usage, and commands
- **Libraries**: API documentation and examples
- **Services**: Deployment and configuration

## Usage Examples

```bash
# Auto-generate from session context
/new-project

# Specify project details
/new-project "task-manager" "web-app" "A React-based task management application"

# Generate for CLI tool
/new-project "backup-tool" "cli-tool" "Command-line backup utility in Rust"
```

## Output Format

Creates a comprehensive PROJECT.md file containing:

- **Clear project description** and objectives
- **Technology stack** with versions where relevant
- **Setup instructions** for new developers
- **Development workflow** and common tasks
- **Architecture overview** and key decisions
- **Current status** and next priorities

The generated document serves as a comprehensive starting point for project documentation and future development sessions.