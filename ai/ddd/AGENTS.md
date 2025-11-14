# [Project Name]

TODO: Brief project description (1-2 sentences)

## Setup

TODO: Installation and setup commands

- Install dependencies: `command here`
- Initialize: `command here`

## Development

TODO: Development workflow commands

- Start dev server: `command here`
- Build: `command here`
- Run tests: `command here`

## Code Style

TODO: Project-specific coding conventions

- Language-specific guidelines
- Formatting rules
- Preferred patterns

## Testing

TODO: Testing instructions

- How to run tests
- How to add tests
- Coverage requirements

## Pull Requests

TODO: PR guidelines

- Title format
- Review process
- Merge requirements

---

## Document Driven Development (DDD)

This project uses Document Driven Development. Design decisions are documented in Design Records (DRs) before implementation.

### Design Records (DRs)

**Location:** `docs/design/design-records/`

**When to create a DR:**

- Architectural decisions
- Algorithm specifications
- Breaking changes or deprecations
- CLI/API structure decisions

**DR workflow:**

1. Check `docs/design/design-records/README.md` for next DR number
2. Create `dr-NNN-title.md` using template from `dr-001-template.md`
3. Update DR index in `README.md`

### Documentation Rules

**Single source of truth (link to these):**

- Design decisions and rationale → Always in DRs
- Architecture and algorithms → Always in DRs

**Duplication allowed (with DR reference):**

- Practical examples in user docs
- Quick-start tutorials
- Common workflows

**Format:**

```markdown
<!-- User-facing docs -->

Brief practical explanation here.

See [DR-XXX](../design/design-records/dr-xxx.md) for complete details.
```

### Reconciliation

After 5-10 DRs or significant design changes:

1. Check for deprecated command references
2. Verify DR cross-links are valid
3. Remove stale TODOs/placeholders
4. Update DR index

**Commands:**

```bash
# Find deprecated references
rg "old-pattern" docs/

# Find placeholders
rg "TODO|TBD|to be written" docs/
```
