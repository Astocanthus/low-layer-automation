---
description: Complete release workflow - PR, merge, tag, and GitHub release with release notes
argument-hint: <project> [version] - e.g., "low-layer-website", "low-layer-website 1.2.0"
allowed-tools: Bash, Read, Edit, Write, Grep, Glob
---

# Release Workflow

Complete automated release workflow that handles the entire release process from PR creation to GitHub release publication.

**You need to always ULTRA THINK.**

## Usage

```bash
/release <project> [version]
```

**Examples:**
```bash
/release low-layer-website           # Version auto-detected from branch (v1.2.0 → 1.2.0)
/release low-layer-website 1.2.0     # Explicit version
```

## Workflow Context

This command is the final step of the LOW-LAYER release workflow:

```
1. git checkout -b v1.2.0          # Create version branch from main
2. [code + update CHANGELOG]       # Development work
3. /push low-layer-website             # Commit and push (repeat as needed)
4. /release low-layer-website          # ← THIS COMMAND (final step)
```

## Prerequisites

Before running this command, ensure:
- `gh` CLI is installed and authenticated (`gh auth status`)
- You are on a version branch (e.g., `v1.2.0`)
- All changes are committed and pushed (use `/push` first)
- `CHANGELOG.md` contains the release version with correct date

## Workflow Steps

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
2. Ask user which project to release

**Project path resolution:**
- Input: `low-layer-website`
- Full path: `/mnt/e/Taff/low-layer/low-layer-website/`

### Step 1: Validate Environment

```bash
PROJECT_PATH="/mnt/e/Taff/low-layer/<project>"

# Check gh CLI
gh auth status

# Check current branch
BRANCH=$(git -C "$PROJECT_PATH" branch --show-current)

# Check for uncommitted changes
git -C "$PROJECT_PATH" status --short

# Check remote
git -C "$PROJECT_PATH" remote -v
```

**Validations:**
- [ ] `gh` CLI is authenticated
- [ ] Current branch matches version pattern (e.g., `v1.2.0`)
- [ ] Working directory is clean (no uncommitted changes)
- [ ] All commits are pushed to origin
- [ ] CHANGELOG.md contains the version entry

**If uncommitted changes exist:**
> ⚠️ "You have uncommitted changes. Run `/push <project>` first."

### Step 2: Determine Release Version

```bash
# Get current branch
BRANCH=$(git -C "$PROJECT_PATH" branch --show-current)

# Extract version (v1.2.0 → 1.2.0)
VERSION=$(echo "$BRANCH" | sed 's/^v//')
```

**If version provided as argument, use that instead.**

**Validate version in CHANGELOG:**
```bash
grep -E "^\#\# \[$VERSION\]" "$PROJECT_PATH/CHANGELOG.md"
```

**Ask for confirmation:**
```
📦 Release Summary

   Project:  low-layer-website
   Branch:   v1.2.0
   Version:  1.2.0

   Commits to be released:
   ├── abc1234 feat(health): add health endpoints
   ├── def5678 feat(logging): add centralized logger
   └── ghi9012 feat(tests): add unit test suite

Proceed with release?
```

### Step 3: Create Release PR

```bash
cd "$PROJECT_PATH"

# Get default branch
DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef -q '.defaultBranchRef.name')

# Ensure branch is pushed
git push -u origin HEAD

# Extract changelog section for PR body
CHANGELOG_SECTION=$(sed -n "/^## \[$VERSION\]/,/^## \[/p" CHANGELOG.md | head -n -1)

# Create PR
gh pr create \
  --base "$DEFAULT_BRANCH" \
  --title "Release v$VERSION" \
  --body "$(cat <<EOF
## Release v$VERSION

### Changelog

$CHANGELOG_SECTION

### Checklist

- [x] CHANGELOG.md updated
- [x] All changes committed and pushed
- [ ] CI checks passing
- [ ] Ready for merge

---
🚀 Release PR created by \`/release\` workflow
EOF
)"
```

**Output:**
```
✅ PR created: https://github.com/org/repo/pull/123

⏳ Waiting for PR validation...

Options:
1. "PR is approved, proceed with merge"
2. "Check PR status"
3. "Cancel release"
```

### Step 4: Wait for PR Approval

```bash
cd "$PROJECT_PATH"

# Check CI status
gh pr checks

# Check review status
gh pr view --json reviewDecision,state
```

**Loop until user confirms PR is ready:**
- Show CI check status
- Show review status
- Wait for user to confirm "Proceed with merge"

### Step 5: Merge the PR

```bash
cd "$PROJECT_PATH"

# Merge with merge commit (preserves commit history)
gh pr merge --merge --delete-branch

# Switch to main and pull
git checkout "$DEFAULT_BRANCH"
git pull origin "$DEFAULT_BRANCH"
```

**Confirm merge success before continuing.**

### Step 6: Create and Push Tag

```bash
cd "$PROJECT_PATH"

# Create annotated tag on the merge commit
git tag -a "v$VERSION" -m "Release v$VERSION"

# Push tag
git push origin "v$VERSION"
```

**Output:**
```
✅ Tag v1.2.0 created at commit abc1234
✅ Tag pushed to origin
```

### Step 7: Generate Release Notes

**Invoke `/release-note` internally:**

Read CHANGELOG.md and generate the formatted release notes following the release-note template:

- 🎉 Highlights
- ✨ New Features
- 🔄 Breaking Changes
- 📦 Installation
- 📁 New Files
- 🐛 Bug Fixes
- 📚 Documentation
- 🙏 Contributors
- 📋 Full Changelog

**Store the generated markdown for the next step.**

### Step 8: Create GitHub Release

```bash
cd "$PROJECT_PATH"

# Create release with generated notes
gh release create "v$VERSION" \
  --title "v$VERSION" \
  --notes "$(cat <<'EOF'
[GENERATED RELEASE NOTES]
EOF
)"
```

**Or save to file first:**
```bash
# Save release notes to file (optional, for record)
echo "$RELEASE_NOTES" > "RELEASE-NOTE-v$VERSION.md"

# Create release
gh release create "v$VERSION" \
  --title "v$VERSION" \
  --notes-file "RELEASE-NOTE-v$VERSION.md"
```

### Step 9: Final Summary

```
✅ Release v1.2.0 of low-layer-website completed successfully!

📋 Summary:
   • PR #123 merged to main
   • Tag v1.2.0 created
   • GitHub Release published

🔗 Links:
   • Release: https://github.com/org/repo/releases/tag/v1.2.0
   • PR: https://github.com/org/repo/pull/123
   • Commits: https://github.com/org/repo/compare/v1.1.0...v1.2.0

🧹 Cleanup:
   • Branch v1.2.0 deleted from remote
   • Local branch switched to main

💡 Next release:
   git checkout -b v1.3.0
```

## Error Handling

### Uncommitted Changes
```
❌ You have uncommitted changes:
   M  src/lib/utils.js

Run /push low-layer-website first, then retry /release.
```

### Branch Not Pushed
```
⚠️ Local branch is ahead of origin by 2 commits.

Run: git -C /path/to/project push origin HEAD
```

### Version Not in CHANGELOG
```
❌ Version 1.2.0 not found in CHANGELOG.md.

Expected entry: ## [1.2.0] - YYYY-MM-DD
```

### PR Checks Failing
```
⚠️ PR checks are failing:

   ❌ tests - 3 failed
   ✅ lint - passed

Fix the issues, push, and retry.
```

### Tag Already Exists
```
⚠️ Tag v1.2.0 already exists.

Options:
1. Delete and recreate (dangerous)
2. Cancel release
```

### Release Already Exists
```
⚠️ GitHub release v1.2.0 already exists.

Options:
1. Update release notes
2. Cancel
```

## Git Command Reference

```bash
PROJECT="/mnt/e/Taff/low-layer/<project>"

# All git commands
git -C "$PROJECT" <command>

# gh commands require cd
cd "$PROJECT" && gh <command>
```

## Complete Workflow Example

```bash
# 1. Start new version (from main)
git -C /mnt/e/Taff/low-layer/low-layer-website checkout main
git -C /mnt/e/Taff/low-layer/low-layer-website pull
git -C /mnt/e/Taff/low-layer/low-layer-website checkout -b v1.2.0

# 2. Develop feature, update CHANGELOG
# ... coding ...

# 3. Push changes (repeat as needed)
/push low-layer-website

# 4. More development...
# ... coding ...
/push low-layer-website

# 5. Final release
/release low-layer-website
```

## Rollback

If something goes wrong:

```bash
PROJECT="/mnt/e/Taff/low-layer/<project>"

# Delete local tag
git -C "$PROJECT" tag -d v1.2.0

# Delete remote tag
git -C "$PROJECT" push origin --delete v1.2.0

# Delete GitHub release
cd "$PROJECT" && gh release delete v1.2.0 --yes

# Revert merge on main (if needed)
git -C "$PROJECT" checkout main
git -C "$PROJECT" revert <merge-commit> --no-edit
git -C "$PROJECT" push origin main
```

User: $ARGUMENTS