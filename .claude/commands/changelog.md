---
description: Add an entry to CHANGELOG.md based on current changes
argument-hint: <project> - e.g., "low-layer-website"
allowed-tools: Bash, Read, Edit, Write, Grep, Glob
---

# Changelog Update Command

Add a new entry to the CHANGELOG.md file based on the current modifications. This command appends entries incrementally without rewriting the entire file.

**You need to always ULTRA THINK.**

## Usage

```bash
/changelog <project>
```

**Examples:**
```bash
/changelog low-layer-website
```

## Workflow Context

This command fits into the LOW-LAYER release workflow:

```
1. git checkout -b release/v1.1.0     # Create version branch
2. [code feature]                      # Development work
3. /changelog low-layer-website            # ← THIS COMMAND (add changelog entry)
4. /push low-layer-website                 # Commit and push
5. Repeat steps 2-4 as needed
6. /release low-layer-website              # Final release
```

## Instructions

When the user invokes `/changelog <project>`, execute the following steps:

### Step 0: Identify Project

**Project path resolution:**
- Input: `low-layer-website`
- Full path: `/mnt/e/Taff/low-layer/low-layer-website/`
- CHANGELOG: `/mnt/e/Taff/low-layer/low-layer-website/CHANGELOG.md`

### Step 1: Analyze Current Changes

```bash
PROJECT_PATH="/mnt/e/Taff/low-layer/<project>"

# Show modified files
git -C "$PROJECT_PATH" status --short

# Show detailed diff (excluding CHANGELOG.md itself)
git -C "$PROJECT_PATH" diff -- . ':!CHANGELOG.md'
git -C "$PROJECT_PATH" diff --cached -- . ':!CHANGELOG.md'
```

**If no changes (excluding CHANGELOG.md):**
> ℹ️ "No code changes detected. Nothing to add to changelog."

### Step 2: Display Changes Summary

Present the changes clearly:

```
📁 Project: low-layer-website
🌿 Branch: release/v1.1.0

📋 Modified files:

   src/routes/health.js      (+45, -2)
   src/lib/logger.js         (+120, -0)  [NEW]
   tests/unit/health.test.js (+89, -0)   [NEW]
```

### Step 3: Determine Change Type

**Ask user to select the type of change:**

| Type | Description | Use for |
|------|-------------|---------|
| **Added** | New features | New files, new functionality |
| **Changed** | Modifications | Refactoring, improvements |
| **Fixed** | Bug fixes | Corrections, patches |
| **Removed** | Deletions | Removed features/files |
| **Security** | Security patches | Vulnerabilities, auth fixes |
| **Deprecated** | Soon to be removed | Planned removals |

**Options:**
1. "Added - New feature"
2. "Changed - Modification"
3. "Fixed - Bug fix"
4. "Removed - Deletion"
5. "Security - Security patch"

### Step 4: Generate Entry Description

**Analyze the changes and propose a changelog entry:**

Based on the diff, generate a structured entry following the LOW-LAYER CHANGELOG format:

```markdown
- **Feature Name** (`path/to/file.js`)
  - Detailed description of what was added/changed
  - Sub-feature or capability
  - Technical details if relevant
```

**Example generated entry:**

```markdown
- **Health Check Endpoints** (`src/routes/health.js`)
  - `GET /health`, `/healthz` - Liveness probe endpoints
  - `GET /ready`, `/readyz` - Readiness probe with database check
  - JSON responses with status, timestamp, and diagnostic info
```

**Present to user for confirmation/editing:**

```
📝 Proposed changelog entry:

┌────────────────────────────────────────────────────────────────┐
│ ### Added                                                      │
│                                                                │
│ - **Health Check Endpoints** (`src/routes/health.js`)          │
│   - `GET /health`, `/healthz` - Liveness probe endpoints       │
│   - `GET /ready`, `/readyz` - Readiness probe with DB check    │
│   - JSON responses with status and diagnostic info             │
└────────────────────────────────────────────────────────────────┘

Use this entry?
```

**Options:**
1. "Yes, add this entry"
2. "Edit entry" → Let user modify
3. "Cancel"

### Step 5: Determine Target Section

**Check current branch to determine where to add the entry:**

```bash
BRANCH=$(git -C "$PROJECT_PATH" branch --show-current)
```

**Logic:**
- If on `release/vX.Y.Z` branch → Add to `## [X.Y.Z]` section
- If section doesn't exist → Create it with today's date
- If on `main` or other → Add to `## [Unreleased]` section

**Example: On branch `release/v1.1.0`**

Check if `## [1.1.0]` section exists in CHANGELOG.md:
- If YES → Append entry under appropriate subsection (Added/Changed/Fixed)
- If NO → Create the section:

```markdown
## [1.1.0] - 2026-02-01

### Added

- **New Entry Here**
```

### Step 6: Update CHANGELOG.md

**Read the current CHANGELOG:**
```bash
cat "$PROJECT_PATH/CHANGELOG.md"
```

**Insert the new entry in the correct location:**

1. Find the target section (`## [1.1.0]` or `## [Unreleased]`)
2. Find or create the subsection (`### Added`, `### Fixed`, etc.)
3. Append the new entry under that subsection
4. Preserve all existing content

**IMPORTANT: Incremental update rules:**
- NEVER rewrite the entire file
- ONLY insert the new entry in the correct position
- Preserve all existing entries
- Maintain proper markdown formatting

### Step 7: Show Result

```
✅ Changelog updated!

📋 Entry added to: ## [1.1.0] - 2026-02-01

### Added

- **Health Check Endpoints** (`src/routes/health.js`)
  - `GET /health`, `/healthz` - Liveness probe endpoints
  - `GET /ready`, `/readyz` - Readiness probe with DB check

💡 Next steps:
   • Review the changes: cat CHANGELOG.md
   • Commit when ready: /push low-layer-website
```

### Step 8: Handle Multiple Entries

If the user has multiple distinct changes, ask:

> "Do you want to add another changelog entry for a different change?"

**Options:**
1. "Yes, add another entry" → Go back to Step 3
2. "No, I'm done"

## Entry Format Guidelines

### For New Features (Added)

```markdown
- **Feature Name** (`path/to/file.ext`)
  - What the feature does
  - Key capabilities or endpoints
  - Technical details (optional)
```

### For Bug Fixes (Fixed)

```markdown
- **Bug Description** (`path/to/file.ext`)
  - What was broken
  - How it was fixed
```

### For Changes (Changed)

```markdown
- **Component Name** (`path/to/file.ext`)
  - What changed
  - Why it changed (if relevant)
```

## Error Handling

### No CHANGELOG.md Found

```
❌ No CHANGELOG.md found in project.

Create one? (Y/n)
```

If yes, create from template:
```markdown
# Changelog

All notable changes to the [Project Name] project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---
```

### Version Section Doesn't Exist

Create it automatically:
```markdown
## [1.1.0] - 2026-02-01

### Added

[new entry here]
```

### Subsection Doesn't Exist

If adding a "Fixed" entry but `### Fixed` doesn't exist in the version section, create it in,the correct order:
1. Added
2. Changed
3. Deprecated
4. Removed
5. Fixed
6. Security

## Integration with Other Commands

| Command | When to use |
|---------|-------------|
| `/changelog` | After coding, before committing |
| `/push` | After changelog is updated |
| `/release` | When version is complete |

**Typical flow:**
```bash
# Code a feature...
/changelog low-layer-website    # Add entry
/push low-layer-website         # Commit all (including CHANGELOG)

# Code another feature...
/changelog low-layer-website    # Add another entry
/push low-layer-website         # Commit all

# Ready to release
/release low-layer-website      # Finalize version
```

User: $ARGUMENTS
