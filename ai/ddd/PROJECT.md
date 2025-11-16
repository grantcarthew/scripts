# Document Driven Development (DDD) Template - Bootstrap Guide

This document guides AI agents through bootstrapping a new DDD project structure. It captures lessons learned from the `start` CLI project to minimize documentation churn and maximize clarity.

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

Generate these files with the templates below:

#### File: `docs/design/README.md`

```markdown
# Design Documentation

This directory contains design decisions and technical documentation.

## Design Records (DRs)

Design Records document significant technical decisions made during development. They serve as the single source of truth for architectural choices, algorithms, and design trade-offs.

**Location:** `design-records/`

**When to create a DR:** See AGENTS.md for guidelines.

**Index:** See [design-records/README.md](design-records/README.md) for complete list.

## Quick Decision Log

For reference, recent major decisions:

- [DR-001](design-records/dr-001-template.md) - DR Template (example)

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

## DR Writing Guidelines

**Focus on decisions, not implementation:**
- DRs capture the reasoning behind choices
- Implementation details belong in code/docs, not DRs
- Code-level design decisions (map vs switch) can be included as supporting details

**Structure:**
- Problem: What constraint drove this decision?
- Decision: Clear statement of what we chose
- Why: Core reasoning behind the choice
- Trade-offs: What we're giving up and gaining
- Alternatives: Other options considered

**Cross-linking:**
- Avoid "Related:" sections in individual DRs
- All relationships managed in this README index
- Prevents maintenance overhead when DRs change

## DR Template

Use [dr-001-template.md](dr-001-template.md) as the template for new DRs.

## Active DRs

| Number | Title    | Status  | Date   |
| ------ | -------- | ------- | ------ |
| DR-001 | Template | Example | [DATE] |

## Superseded DRs

| Number | Title | Superseded By | Date |
| ------ | ----- | ------------- | ---- |
| -      | -     | -             | -    |

## Deprecated DRs

| Number | Title | Reason | Date |
| ------ | ----- | ------ | ---- |
| -      | -     | -      | -    |
```

#### File: `docs/design/design-records/dr-001-template.md`

```markdown
# DR-001: Design Record Template

**Date:** [Current Date]
**Status:** Example
**Category:** Template

## Problem

This is the template for creating new Design Records. Replace this section with the problem or constraint that drove this decision: What specific issue needs to be resolved? What forces are at play?

## Decision

State your decision clearly and concisely. This should be specific and actionable.

## Why

Explain the core reasoning behind this choice. Why is this the right solution for our context? Include any code-level design decisions as supporting details.

## Trade-offs

**Accept:** What costs or limitations are we accepting?
**Gain:** What benefits do we get from this choice?

## Alternatives

What other options were evaluated and why they didn't fit?

- **Alternative 1:** Brief description and why rejected
- **Alternative 2:** Brief description and why rejected
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
- [x] `docs/design/README.md`
- [x] `docs/design/design-records/README.md` - DR index
- [x] `docs/design/design-records/dr-001-template.md` - DR template
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
- Design Records system (docs/design/design-records/)
- DR index and template (DR-001)
- Ideas directory (docs/ideas/)
[List conditional directories created]

Next steps:
1. Start documenting design decisions as DRs
2. Follow DDD guidelines in AGENTS.md when making changes
3. Run documentation reconciliation after ~5-10 DRs

Ready to begin design phase.
```

---

## Phase 2: DDD Reference

This section explains the philosophy and guidelines for maintaining DDD projects.

### Document Hierarchy and Cross-Linking Strategy

#### Single Source of Truth (Link to these)

**Design Records (DRs)**

- Authoritative technical decisions
- Never duplicate DR content elsewhere
- Other documents reference DRs via links
- Format: `See DR-XXX for details on [topic]`

**Example:**

```markdown
<!-- In user documentation -->

Asset resolution follows a three-tier lookup strategy.
See [DR-033: Asset Resolution Algorithm](../design/design-records/dr-033-asset-resolution-algorithm.md) for complete details.
```

#### Duplication Allowed (Optimize for reader)

**User-facing documentation**

- Command/API docs can duplicate practical examples from DRs
- Tutorial docs should be self-contained for learning flow
- README can summarize key concepts without full detail
- Include DR reference at bottom for deep dive

**Example:**

```markdown
<!-- In getting-started.md -->

## Installing Dependencies

Quick example:
$ npm install

This will install all dependencies listed in package.json.

For complete dependency resolution algorithm, see [DR-015: Dependency Resolution](../design/design-records/dr-015-dependency-resolution.md).
```

### When to Create Design Records

**Always create a DR for:**

- Architectural decisions (component structure, data flow)
- Algorithm specifications (search, sorting, resolution)
- Breaking changes or deprecations
- Data formats, schemas, or protocols
- Public API or CLI command structure
- Security or performance trade-offs
- Major UX decisions

**Never create a DR for:**

- Simple bug fixes
- Documentation corrections
- Code refactoring without behavior change
- Cosmetic changes
- Internal implementation details

### DR Structure

See `docs/design/design-records/dr-001-template.md` for the complete template.

**Minimum required sections:**

- **Status:** Proposed | Accepted | Superseded | Deprecated
- **Date:** YYYY-MM-DD
- **Context:** Why is this decision needed?
- **Decision:** What are we deciding?
- **Consequences:** What are the implications?

**Recommended sections:**

- **Alternatives Considered:** What else did we evaluate?
- **Implementation Notes:** Practical guidance

### DR Numbering

- Sequential numbering: DR-001, DR-002, etc.
- Gaps are acceptable (deleted/superseded DRs)
- Maintain index in `design-records/README.md`

### Documentation Reconciliation

**When to reconcile:**

1. After major design iteration (5-10 new DRs written)
2. Before milestone releases
3. When design stabilizes
4. When user feedback indicates confusion

**Reconciliation checklist:**

- Remove references to deprecated/removed features
- Update all cross-links to DRs
- Verify examples still work with current design
- Remove stale TODOs and placeholders
- Check consistency of terminology
- Ensure DR index is up to date
- Verify README reflects current state

**Commands for finding issues:**

```bash
# Find deprecated references (customize pattern)
rg "old-pattern" docs/

# Find placeholders
rg "TODO|TBD|to be written" docs/

# Verify DR links
rg "\[DR-[0-9]+" docs/
```

### Success Criteria

A successful DDD implementation achieves:

- Design decisions are traceable to specific DRs
- User documentation is readable without excessive navigation
- Changes to design require minimal document updates
- New team members can understand decisions through DRs
- Documentation remains consistent through iterations
- Reconciliation passes find minimal issues

---

## Meta

This framework was created through Document Driven Development. It represents distilled lessons from:

- Building the `start` CLI tool (January 2025)
- 5+ documentation reconciliation passes
- Identifying documentation churn patterns
- Discovering duplication vs. cross-linking trade-offs

The goal: Start new DDD projects with minimal churn by establishing structure upfront.
