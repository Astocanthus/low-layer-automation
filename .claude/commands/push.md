---
description: Commit and push changes to the current version branch with auto-generated commit message
argument-hint: <project> - e.g., "low-layer-website"
allowed-tools: Bash, Read, Grep, Glob
---

# Push Command

Commit and push changes to the version branch with automatic commit message generation from CHANGELOG.

**You need to always ULTRA THINK.**

## Usage

```bash
/push <project>
```

**Examples:**
```bash
/push low-layer-website
```

## Workflow Context

This command is part of the LOW-LAYER release workflow:

```
1. git checkout -b v1.2.0          # Create version branch
2. [code + update CHANGELOG]       # Development work
3. /push low-layer-website             # ← THIS COMMAND (repeat as needed)
4. /release low-layer-website 1.2.0    # Final release
```

## Instructions

When the user invokes `/push <project>`, execute the following steps:

### Step 0: Identify and Validate Project

**If no project specified:**
1. List available git projects:
   ```bash
   for dir in /mnt/e/Taff/low-layer/*/; do
     if [ -d "$dir/.git" ]; then
       echo "$(basename "$dir")"
     fi
   done
   ```
2. Ask user which project to use

**Project path resolution:**
- Input: `low-layer-website`
- Full path: `/mnt/e/Taff/low-layer/low-layer-website/`

### Step 1: Validate Branch

```bash
PROJECT_PATH="/mnt/e/Taff/low-layer/<project>"

# Get current branch
BRANCH=$(git -C "$PROJECT_PATH" branch --show-current)
echo "Current branch: $BRANCH"
```

**Validations:**
- [ ] Must NOT be on `main` or `master` branch
- [ ] Should be on a version branch (e.g., `v1.2.0`) - warn if not matching pattern

**If on main/master:**
> ❌ "You are on the `main` branch. Create a version branch first: `git checkout -b v1.2.0`"

### Step 2: Check for Changes

```bash
# Show git status
git -C "$PROJECT_PATH" status --short

# List modified/added/deleted files
git -C "$PROJECT_PATH" diff --name-status
git -C "$PROJECT_PATH" diff --name-status --cached
```

**If no changes:**
> ℹ️ "No changes to commit."
> Stop workflow.

### Step 3: Verify CHANGELOG is Modified (MANDATORY)

```bash
# Check if CHANGELOG.md is in the modified files
git -C "$PROJECT_PATH" status --short | grep -E "CHANGELOG\.md"
```

**If CHANGELOG.md is NOT modified:**
> ❌ "CHANGELOG.md has not been modified. Please update the changelog before committing."
>
> **BLOCKING:** Do not proceed. The user must update CHANGELOG.md first.

### Step 4: Display Changes for Confirmation

Present the changes clearly:

```
📁 Project: low-layer-website
🌿 Branch: v1.2.0

📋 Files to be committed:

   Modified:
   ├── src/routes/health.js
   ├── src/lib/logger.js
   └── CHANGELOG.md ✓

   Added:
   └── tests/unit/health.test.js

   Deleted:
   └── (none)

Total: 4 files
```

**Ask for confirmation:**
> "Do you want to stage and commit these files?"

**Options:**
1. "Yes, commit all listed files"
2. "No, cancel"
3. "Let me review the diff first" → show `git diff`

### Step 5: Generate Commit Message

Analyze the CHANGELOG.md diff to generate a professional commit message:

```bash
# Get the diff of CHANGELOG.md
git -C "$PROJECT_PATH" diff CHANGELOG.md
git -C "$PROJECT_PATH" diff --cached CHANGELOG.md
```

**Commit Message Generation Rules:**

1. **Parse the CHANGELOG diff** to find new entries under:
   - `### Added` → prefix with `feat:`
   - `### Changed` → prefix with `refactor:` or `change:`
   - `### Fixed` → prefix with `fix:`
   - `### Removed` → prefix with `remove:`
   - `### Security` → prefix with `security:`

2. **Format:** Use Conventional Commits style
   ```
   <type>(<scope>): <short description>

   <optional body with details>
   ```

3. **NO Co-Authored-By line** - This is a professional commit

4. **Examples of generated messages:**
   ```
   feat(health): add kubernetes health check endpoints

   - GET /health, /healthz for liveness probes
   - GET /ready, /readyz for readiness probes
   - GET /startup for startup probes
   ```

   ```
   feat(logging): add centralized winston logger

   - Configurable log levels (error, warn, info, http, debug)
   - JSON format for production, colored for development
   - Module-specific loggers with context injection
   ```

   ```
   fix(auth): resolve session cookie expiration issue
   ```

**If multiple features/fixes in CHANGELOG:**
- Create a combined message or
- Use the most significant change as the main message
- List others in the body

### Step 6: Present Generated Commit Message

```
📝 Generated commit message:

┌────────────────────────────────────────────────────────────┐
│ feat(health): add kubernetes health check endpoints        │
│                                                            │
│ - GET /health, /healthz for liveness probes                │
│ - GET /ready, /readyz for readiness probes                 │
│ - GET /startup for startup probes                          │
└────────────────────────────────────────────────────────────┘
```

**Ask for confirmation:**
> "Use this commit message?"

**Options:**
1. "Yes, use this message"
2. "Edit message" → Let user modify
3. "Cancel"

### Step 7: Execute Commit and Push

```bash
PROJECT_PATH="/mnt/e/Taff/low-layer/<project>"

# Stage all changes
git -C "$PROJECT_PATH" add .

# Commit with the generated message (using heredoc for multiline)
git -C "$PROJECT_PATH" commit -m "$(cat <<'EOF'
<generated commit message>
EOF
)"

# Push to origin
git -C "$PROJECT_PATH" push origin HEAD
```

### Step 8: Confirmation

```
✅ Changes committed and pushed successfully!

📋 Summary:
   • Project: low-layer-website
   • Branch: v1.2.0
   • Commit: abc1234
   • Files: 4 changed

🔗 Remote: origin/v1.2.0 is up to date

💡 Next steps:
   • Continue working and run /push again when ready
   • When release is complete, run: /release low-layer-website 1.2.0
```

## Error Handling

### No Git Repository
```
❌ "<project>" is not a git repository.
```

### No Remote Configured
```
❌ No remote 'origin' configured. Add a remote first:
   git -C /mnt/e/Taff/low-layer/<project> remote add origin <url>
```

### Push Rejected (Behind Remote)
```
⚠️ Push rejected. Your branch is behind the remote.

Options:
1. Pull and retry: git -C ... pull --rebase origin <branch>
2. Force push (dangerous): git -C ... push --force-with-lease
```

### Uncommitted Changes in CHANGELOG Only
If only CHANGELOG.md is modified but no code changes:
```
ℹ️ Only CHANGELOG.md is modified. This is unusual.
   Did you mean to commit code changes as well?

Options:
1. Proceed anyway (changelog-only commit)
2. Cancel and continue working
```

## Git Command Reference

All commands use `-C` to target the correct project:

```bash
PROJECT="/mnt/e/Taff/low-layer/<project>"

git -C "$PROJECT" status
git -C "$PROJECT" diff
git -C "$PROJECT" add .
git -C "$PROJECT" commit -m "message"
git -C "$PROJECT" push origin HEAD
```

## Commit Message Format

**DO:**
```
feat(scope): add new feature description

- Detail 1
- Detail 2
```

**DON'T:**
```
feat(scope): add new feature description

Co-Authored-By: Claude <...>   ← NEVER ADD THIS
```

## Integration with /release

After multiple `/push` commands, the version branch will have several commits:

```
v1.2.0
├── abc1234 feat(health): add health endpoints
├── def5678 feat(logging): add centralized logger
└── ghi9012 feat(tests): add unit test suite
```

When `/release` is called:
1. These commits are included in the PR
2. PR is merged to main (merge commit or squash based on preference)
3. Tag is created on the merge commit
4. Release notes are generated from CHANGELOG.md

User: $ARGUMENTS