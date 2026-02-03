# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Project Overview

This is a new repository. Update this file as the project develops with:
- Build and test commands
- Architecture decisions
- Project-specific conventions

### Business Context

- **Certification Target**: ISO 27001 (NOT SecNumCloud - do not reference SecNumCloud in any content)
- **Market Position**: Competitive with European cloud providers (Hetzner, Scaleway, OVH)
- **Pricing Strategy**: Base infrastructure cost × ~2.5-3x markup for management/platform value

### Related Documentation

| File | Purpose |
|------|---------|
| `CLAUDE.md` | Project overview, security, standards aggregator |
| `WORKFLOW.md` | AI agent orchestration, task management, quality assurance |
| `architecture/` | Platform architecture, repository structure, technical decisions |
| `.CLAUDE/tasks/todo.md` | Current work items and working memory |
| `.CLAUDE/tasks/lessons.md` | Failure modes and prevention rules |

> **Important**: Always follow `WORKFLOW.md` for operational principles and task management.
>
> **Architecture**: Consult `architecture/` before proposing structural changes or new components.

---

## Security System

This project is protected by a security hook that prevents dangerous operations.

### Protected Actions

The security guard blocks:

1. **Privileged Commands**: `sudo`, `su`, `runas`, etc.
2. **Destructive Commands**: `rm -rf /`, `format`, `mkfs`, `dd`, etc.
3. **System Modifications**: `shutdown`, `reboot`, `chmod 777`, etc.
4. **File Access Outside Project**: All Read/Write/Edit operations are restricted to this project directory
5. **Sensitive Files**: `.env`, credentials, API keys, SSH keys, etc.
6. **Dangerous Git Operations**: `git push --force`, `rm -rf .git`
7. **Remote Code Execution Patterns**: `curl|bash`, `wget|sh`, reverse shells

### Configuration

- Hook script: `.CLAUDE/hooks/security-guard.sh`
- Settings: `.CLAUDE/settings.json`

### Disabling (Not Recommended)

To temporarily disable security, set `"disableAllHooks": true` in settings or use `/hooks` menu.

---

## Standards Reference

All code and documentation standards are externalized in `.CLAUDE/standards/`:

| Standard | File | Description |
|----------|------|-------------|
| **Code Generation** | [code-standards.md](.CLAUDE/standards/code-standards.md) | File headers, section headers, commenting rules |
| **README Format** | [readme-standards.md](.CLAUDE/standards/readme-standards.md) | README template, badges, required sections |
| **Git Workflow** | [git-workflow.md](.CLAUDE/standards/git-workflow.md) | Branching strategy, naming conventions |
| **Changelog** | [changelog-standards.md](.CLAUDE/standards/changelog-standards.md) | Keep a Changelog format, entry rules |

### License Templates

Available licenses in `.CLAUDE/licenses/`:

| License | File | Usage |
|---------|------|-------|
| **LOW-LAYER** | [LICENSE](.CLAUDE/licenses/LICENSE) | Proprietary projects (5 user free tier) |
| **MIT** | [MIT](.CLAUDE/licenses/MIT) | Open source projects |

To apply a license to a new project:
```bash
cp .CLAUDE/licenses/MIT /path/to/project/LICENSE
# Edit [YEAR] and [COPYRIGHT HOLDER] placeholders
```

> **Important**: Always consult these standards when generating code or documentation.

### Quick Reference

**File Header** (all files):
```
# Copyright (C) - LOW-LAYER
# Contact : contact@low-layer.com
# ============================================================================
# [FILENAME] - [One-line summary]
# ============================================================================
```

**Section Header** (major blocks):
```
# ---------------------------------------------------------------------------
# [SECTION TITLE IN UPPERCASE]
# ---------------------------------------------------------------------------
```

**Commit Message**:
```
feat|fix|docs|refactor: short description
```

**Changelog Entry**:
```markdown
- **Feature Name** (`path/to/file.js`)
  - Detailed description
```
