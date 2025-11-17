# Document Driven Development (DDD) Template - Bootstrap Guide

This document guides AI agents through bootstrapping a new DDD project structure.

**IMPORTANT:** Read `docs/design/dr-writing-guide.md` before continuing. That guide defines how to write Design Records. This guide defines how to bootstrap the project structure.

---

## Phase 1: Bootstrap Tasks

### Step 1: Gather Project Information

Ask the user these questions to understand what structure to create:

**Essential:**

- What is the project name?
- What type of project is this? (Examples: CLI tool, web application, library, API service, mobile app, game, embedded system, desktop application, etc.)
- What programming language(s)?
- Brief description (1-2 sentences)?

**Documentation needs:**

- Does this project need CLI command documentation?
- Does this project need API/endpoint documentation?
- Does this project need architecture documentation?
- Does this project need user guides/tutorials?
- Any other specific documentation types?

**Development workflow:**

- How do you install/setup the project?
- How do you run it in development?
- How do you run tests?
- How do you build for production?
- Any code style guidelines?

### Step 2: Create Directory Structure

Based on answers from Step 1, create the appropriate directories:

**Always create:**

```bash
mkdir -p docs/design/design-records
mkdir -p docs/guides
mkdir -p docs/ideas
```

**Conditionally create:**

```bash
# If CLI documentation needed:
mkdir -p docs/cli

# If API documentation needed:
mkdir -p docs/api

# If architecture documentation needed:
mkdir -p docs/architecture
```

### Step 3: Populate AGENTS.md

Update the existing AGENTS.md template with information gathered in Step 1:

**Replace placeholders:**

- `[Project Name]` → Actual project name
- TODO in project description → Actual description
- TODO in Setup section → Actual setup commands
- TODO in Development section → Actual dev commands
- TODO in Code Style section → Actual style guidelines
- TODO in Testing section → Actual test instructions
- TODO in Pull Requests section → Actual PR guidelines (if applicable)

**Keep the DDD section at the bottom unchanged.**

### Step 4: Create Core DDD Files

Copy and generate these files:

#### File: `docs/design/dr-writing-guide.md`

Copy from template location: `docs/design/dr-writing-guide.md` (in same directory tree as this PROJECT.md)

This is the complete guide for writing Design Records.

#### File: `docs/design/README.md`

```markdown
# Design Documentation

This directory contains design decisions and technical documentation.

## Design Records (DRs)

Design Records document significant technical decisions made during development. They serve as the single source of truth for architectural choices, algorithms, and design trade-offs.

**Location:** `design-records/`

**Writing guidelines:** See [dr-writing-guide.md](dr-writing-guide.md)

**Index:** See [design-records/README.md](design-records/README.md) for complete list.

## Quick Decision Log

_Update this list when adding significant DRs_
```

#### File: `docs/design/design-records/README.md`

```markdown
# Design Records Index

This directory contains Design Records (DRs) - formal documentation of significant technical decisions.

## What are Design Records?

Design Records document the **why** behind technical decisions. They capture:

- The context and problem being solved
- The decision made
- Alternatives considered
- Trade-offs and consequences

For DR writing guidelines, see [../dr-writing-guide.md](../dr-writing-guide.md)

## Active DRs

| Number | Title | Status | Date |
| ------ | ----- | ------ | ---- |
| -      | -     | -      | -    |

## Superseded DRs

| Number | Title | Superseded By | Date |
| ------ | ----- | ------------- | ---- |
| -      | -     | -             | -    |

## Deprecated DRs

| Number | Title | Reason | Date |
| ------ | ----- | ------ | ---- |
| -      | -     | -      | -    |
```

#### File: `docs/guides/getting-started.md` (if applicable)

```markdown
# Getting Started with [Project Name]

TODO: Quick start guide for new users

## Prerequisites

- List requirements

## Installation

\`\`\`bash

# Installation commands

\`\`\`

## Quick Start

\`\`\`bash

# Basic usage examples

\`\`\`

## Next Steps

- Link to relevant documentation
- Common workflows
```

#### File: `docs/ideas/README.md`

```markdown
# Ideas and Future Work

This directory contains exploratory ideas, brainstorming, and future concepts that aren't yet formal Design Records.

## When to use this directory

- Brainstorming new features
- Exploring alternative approaches
- Documenting "maybe someday" ideas
- Sketching out concepts before formal DR

## When to move to Design Records

When an idea becomes a concrete decision that will be implemented, create a formal DR in `design-records/`.
```

### Step 5: Create Type-Specific Documentation

**If CLI documentation needed**, create `docs/cli/README.md`:

```markdown
# CLI Command Reference

Complete reference for all [Project Name] commands.

## Command Index

- `command` - Brief description

## Command Format

Each command is documented in its own file following this structure:

- Usage and syntax
- Description
- Options and flags
- Examples
- Related commands
```

**If API documentation needed**, create `docs/api/README.md`:

```markdown
# API Reference

Complete reference for [Project Name] API.

## Endpoints

- `GET /endpoint` - Brief description

## Authentication

TODO: Authentication mechanism

## Rate Limiting

TODO: Rate limiting policy (if applicable)

## Response Format

TODO: Standard response format
```

**If architecture documentation needed**, create `docs/architecture.md`:

```markdown
# Architecture

High-level architecture and system design for [Project Name].

## Overview

TODO: System architecture overview

## Components

TODO: Major components and their responsibilities

## Data Flow

TODO: How data flows through the system

## Design Decisions

See [design/design-records/](design/design-records/) for detailed design decisions.
```

### Step 6: Update README.md

Ensure the project's main README.md references the new documentation structure:

```markdown
## Documentation

Complete documentation is available in the `docs/` directory:

- `docs/guides/` - User guides and tutorials
- `docs/design/` - Design decisions and architecture
  [Add other relevant doc directories based on project type]

For AI agents working on this project, see [AGENTS.md](AGENTS.md).
```

### Step 7: Verify Bootstrap Complete

Confirm all files are created:

**Essential files:**

- [x] `AGENTS.md` - Populated with project information
- [x] `docs/design/dr-writing-guide.md` - DR writing guidelines
- [x] `docs/design/README.md`
- [x] `docs/design/design-records/README.md` - DR index
- [x] `docs/ideas/README.md`

**Conditional files:**

- [ ] `docs/cli/README.md` (if CLI project)
- [ ] `docs/api/README.md` (if API project)
- [ ] `docs/architecture.md` (if architecture docs needed)
- [ ] `docs/guides/getting-started.md` (if user guides needed)

**README updated:**

- [ ] Main README.md references docs/ structure

### Step 8: Report to User

Provide summary of created structure:

```
✓ DDD project structure initialized

Created:
- DR writing guide (docs/design/dr-writing-guide.md)
- Design Records system (docs/design/design-records/)
- DR index (docs/design/design-records/README.md)
- Ideas directory (docs/ideas/)
[List conditional directories created]

Next steps:
1. Read docs/design/dr-writing-guide.md
2. Start documenting design decisions as DRs
3. Run documentation reconciliation after ~5-10 DRs

Ready to begin design phase.
```
