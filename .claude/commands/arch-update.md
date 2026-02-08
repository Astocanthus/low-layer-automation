---
description: Document architectural decisions and evolution in low-layer-architecture/ folder
argument-hint: <decision|change|session> - e.g., "session", "Add Redis caching"
allowed-tools: Bash, Read, Edit, Write, Grep, Glob, Task
---

# Architecture Update Command

Document architectural decisions, changes, and evolution by updating or creating entries in the `low-layer-architecture/` folder.

**You need to always ULTRA THINK.**

## Usage

```bash
/arch-update <decision|change|session>
```

**Examples:**
```bash
/arch-update session                      # Extract decisions from current work session
/arch-update "Add Redis caching layer"    # Document specific change
/arch-update "Decision: PostgreSQL over MySQL for tenant isolation"
```

## Workflow Context

This command is used to keep architecture documentation in sync:

```
1. [Work session with architectural discussions]
2. /arch-update session        # ← THIS COMMAND (synthesize session into docs)
3. /changelog <project>        # Document implementation changes
4. /push <project>             # Commit everything
```

**Or for specific changes:**
```
1. /epct <feature>             # Implement feature with architectural impact
2. /arch-update <change>       # ← Document the specific architecture change
3. /changelog <project>        # Document implementation changes
4. /push <project>             # Commit everything
```

## Instructions

When the user invokes `/arch-update <input>`, execute the following steps:

### Step 0: Parse Input Mode

Determine the mode based on input:

| Input | Mode | Action |
|-------|------|--------|
| `session` | **Session Synthesis** | Analyze current conversation context and extract all architectural decisions |
| Specific description | **Direct Update** | Document the specific change described |

---

## Mode A: Session Synthesis (`/arch-update session`)

### Step A1: Analyze Conversation Context

**ULTRA THINK** about the entire conversation history:

1. **Identify architectural discussions:**
   - New components or services discussed
   - Technology choices made (database, framework, protocol)
   - Structural decisions (repo organization, folder structure)
   - Integration patterns decided
   - Trade-offs evaluated and resolved

2. **Extract implicit decisions:**
   - "We should use X" → Decision to use X
   - "Let's separate Y into its own service" → New component Y
   - "The API will communicate via Z" → Interface decision

3. **Categorize findings:**
   - Platform/Infrastructure changes → `platform.md`
   - Repository structure changes → `repositories.md`
   - Major decisions with rationale → `decisions/ADR-XXX.md`
   - New concepts requiring documentation → New file

### Step A2: Present Extracted Decisions

```
📐 Session Architecture Synthesis

🔍 Extracted from conversation:

   1. DECISION: Use PostgreSQL for tenant isolation
      → Rationale: Row-level security, native JSON support
      → Target: low-layer-architecture/decisions/ADR-001-database.md

   2. NEW COMPONENT: Notification service
      → Purpose: Async messaging, email/webhook delivery
      → Target: low-layer-architecture/repositories.md (add section)

   3. CHANGE: Add caching layer
      → Impact: Between API and database
      → Target: low-layer-architecture/platform.md (update diagram)

Document these changes?
```

**Options:**
1. "Yes, document all"
2. "Select specific items"
3. "Edit before documenting"
4. "Cancel"

### Step A3: Generate Documentation

For each extracted decision, generate appropriate documentation following the templates below.

---

## Mode B: Direct Update (`/arch-update <description>`)

### Step B0: Parse Input

Identify the type of architectural update:
- **Decision**: A technical choice with rationale (e.g., "Use X over Y because...")
- **Change**: Modification to existing architecture (e.g., "Add caching layer")
- **New Component**: A new repository, service, or major component

### Step B1: Explore Current Architecture

Launch **parallel subagents** to analyze existing documentation:

```bash
# Read existing architecture files
ls -la low-layer-architecture/
```

Files to examine:
- `low-layer-architecture/platform.md` - Infrastructure and platform design
- `low-layer-architecture/repositories.md` - Repository structure and responsibilities
- `low-layer-architecture/diagrams/` - Visual representations

**ULTRA THINK**: Where does this change fit? What existing documentation needs updating?

### Step B2: Determine Update Strategy

Based on the change type:

| Type | Action |
|------|--------|
| **Decision** | Add to existing file's "Decisions" section or create `low-layer-architecture/decisions/ADR-XXX.md` |
| **Change to existing** | Update relevant section in `platform.md` or `repositories.md` |
| **New component** | Add section to `repositories.md`, update diagrams if needed |
| **New concept** | Create new file in `low-layer-architecture/` |

---

## Common Steps (Both Modes)

### Step 3: Present Changes

Show the proposed documentation changes to the user:

```
📐 Architecture Update

📁 Files to modify:
   • low-layer-architecture/repositories.md (add new section)

📝 Changes:
┌────────────────────────────────────────────────────────────┐
│ ## 7. low-layer-notifications                              │
│                                                            │
│ **Purpose**: Async messaging and notification service      │
│ ...                                                        │
└────────────────────────────────────────────────────────────┘

Proceed with this update?
```

**Options:**
1. "Yes, apply changes"
2. "Edit before applying"
3. "Cancel"

### Step 4: Apply Changes

After user approval:

1. Edit or create the appropriate file(s)
2. Update any cross-references in other architecture docs
3. Update diagrams if the change is visual

### Step 5: Verify Consistency

Check for:
- [ ] All references updated (if component renamed/added)
- [ ] Diagrams reflect the change (flag if manual update needed)
- [ ] No broken links in documentation
- [ ] Consistent terminology across files

### Step 6: Summary

```
✅ Architecture documentation updated!

📁 Modified:
   • low-layer-architecture/repositories.md

📝 Changes:
   • Added section for low-layer-notifications repository
   • Updated repository count in overview

💡 Next steps:
   • Update low-layer-architecture/diagrams/ if needed
   • Run /changelog to document implementation
```

---

## Documentation Templates

### Decision (ADR style)

```markdown
## Decision: [Title]

**Date**: YYYY-MM-DD
**Status**: Accepted | Proposed | Deprecated

### Context
[What is the issue that we're seeing that is motivating this decision?]

### Decision
[What is the change that we're proposing and/or doing?]

### Consequences
[What becomes easier or more difficult as a result?]
```

### Component Change

```markdown
## [Component Name]

**Purpose**: [One-line description]

**Responsibilities**:
- [Responsibility 1]
- [Responsibility 2]

**Interfaces**:
- [API/Protocol it exposes]
- [Dependencies it has]
```

### Repository Addition

```markdown
## X. [repo-name]

**Purpose**: [Description]

**Tech Stack**: [Languages, frameworks]

**Key Files**:
repo-name/
├── [structure]
└── [key files]

**Dependencies**: [Other repos it depends on]
```

## Architecture File Reference

| File | Contains |
|------|----------|
| `platform.md` | Infrastructure design, tenant model, VPC structure |
| `repositories.md` | Multi-repo structure, responsibilities, dependencies |
| `diagrams/` | ASCII and visual architecture diagrams |
| `decisions/` | Architecture Decision Records (ADRs) - create if needed |

## Error Handling

| Issue | Action |
|-------|--------|
| Unclear where to add | Ask user to clarify scope |
| Conflicting information | Highlight conflict, ask for resolution |
| Missing low-layer-architecture/ folder | Create basic structure |
| Change too broad | Suggest breaking into multiple updates |

## Notes

- **ULTRA THINK** about architectural impact before documenting
- Keep documentation concise but complete
- Use ASCII diagrams for in-file visuals
- Reference related files when appropriate
- Date significant decisions
- Architecture docs are for humans - clarity over formality

User: $ARGUMENTS
