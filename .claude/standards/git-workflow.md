# Git Workflow

**Context:** Single developer workflow - simplified release branching without complex GitFlow.

---

## Branching Strategy

```
main (stable releases)
  │
  └── vX.Y.Z (version branch for development)
        │
        └── feature/description (feature branches)
```

---

## Rules

1. **Version Branches**: All development happens on version branches (`v1.2.0`, `v2.0.0`, etc.)
2. **Feature Branches**: Each feature is developed on a dedicated branch from the version branch
3. **Versioning**: Each completed feature produces a **new minor version** (X.Y.0 → X.Y+1.0)
4. **Changelog**: Every feature MUST be documented in the project's `CHANGELOG.md`
5. **Merge Flow**: `feature/* → vX.Y.Z → main` (with tag)

---

## Branch Naming Convention

### Pre-release (before v1.0.0)

| Type | Pattern | Example |
|------|---------|---------|
| Version | `v0.X.Y` | `v0.1.0`, `v0.2.0` |
| Feature | `feature/short-description` | `feature/health-endpoints` |
| Bugfix | `fix/short-description` | `fix/auth-cookie-issue` |

### Production releases (v1.0.0 and above)

| Type | Pattern | Example |
|------|---------|---------|
| Release | `release/vX.Y.Z` | `release/v1.0.0`, `release/v1.2.0` |
| Feature | `feature/short-description` | `feature/health-endpoints` |
| Bugfix | `fix/short-description` | `fix/auth-cookie-issue` |
| Hotfix | `hotfix/short-description` | `hotfix/critical-security` |

---

## Workflow Steps

```bash
# 1. Create version branch from main
git checkout main
git checkout -b v1.2.0

# 2. Create feature branch
git checkout -b feature/new-feature

# 3. Develop and commit
git add .
git commit -m "feat: add new feature description"

# 4. Update CHANGELOG.md (MANDATORY)

# 5. Merge feature into version branch
git checkout v1.2.0
git merge feature/new-feature

# 6. When ready for release, merge to main and tag
git checkout main
git merge v1.2.0
git tag -a v1.2.0 -m "Release v1.2.0"
git push origin main --tags
```
