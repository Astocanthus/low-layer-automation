# LOW-LAYER Automation

[![Claude Code](https://img.shields.io/badge/Claude_Code-Config-7C3AED?style=for-the-badge&logo=anthropic&logoColor=white)](https://claude.ai/code)
[![Bash](https://img.shields.io/badge/Bash-Hooks-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

**Claude Code automation configuration** for development workflows: code standards, AI orchestration, custom commands, and security hooks.

This repository contains a production-ready Claude Code setup with workflows for release management, changelog generation, debugging, and more.

---

## Features

- **Security Hook**: Pre-execution guard blocking dangerous operations (sudo, rm -rf, sensitive files)
- **10 Custom Commands**: Specialized workflows for common development tasks
- **Code Standards**: Comprehensive guidelines for code generation and documentation
- **AI Orchestration**: Workflow patterns for effective Claude Code usage
- **Task Management**: File-based todo tracking and lessons learned system

---

## Structure

```
low-layer-automation/
├── .CLAUDE/                         # Claude Code configuration
│   ├── settings.json                # Hooks and shared permissions
│   ├── settings.local.json          # Local permissions (not committed)
│   ├── hooks/
│   │   └── security-guard.sh        # Pre-execution security checks
│   ├── tasks/
│   │   ├── todo.md                  # Task tracking template
│   │   └── lessons.md               # Lessons learned template
│   ├── standards/                   # Externalized code standards
│   │   ├── code-standards.md        # File headers, comments
│   │   ├── readme-standards.md      # README template
│   │   ├── git-workflow.md          # Branching strategy
│   │   └── changelog-standards.md   # Changelog format
│   └── commands/                    # Custom slash commands
│       ├── changelog.md             # /changelog - Add changelog entries
│       ├── push.md                  # /push - Commit and push
│       ├── release.md               # /release - Full release workflow
│       ├── release-note.md          # /release-note - Generate release notes
│       ├── docker-release.md        # /docker-release - Build & push images
│       ├── debug.md                 # /debug - Systematic debugging
│       ├── epct.md                  # /epct - Explore-Plan-Code-Test
│       ├── arch-update.md           # /arch-update - Document architecture changes
│       ├── ask-command.md           # /ask-command - Create new commands
│       └── web-design.md            # /web-design - UI/UX specialist
│
├── architecture/                    # Technical documentation (LOW-LAYER example)
│   ├── platform.md                  # Platform architecture
│   ├── repositories.md              # Multi-repo structure
│   └── diagrams/                    # Architecture diagrams
│
├── CLAUDE.md                        # Code generation standards
├── WORKFLOW.md                      # AI orchestration guidelines
└── .gitignore
```

---

## Custom Commands

| Command | Description |
|---------|-------------|
| `/changelog` | Add entries to CHANGELOG.md based on current changes |
| `/push` | Commit and push with auto-generated message from changelog |
| `/release` | Complete release workflow (PR, merge, tag, GitHub release) |
| `/release-note` | Generate professional release notes from changelog |
| `/docker-release` | Build and push Docker image to ghcr.io |
| `/debug` | Systematic bug debugging with deep analysis |
| `/epct` | Explore-Plan-Code-Test workflow for features |
| `/arch-update` | Document architectural decisions and changes |
| `/ask-command` | Create and optimize new slash commands |
| `/web-design` | Web development and UI/UX specialist mode |

---

## Security Hook

The security guard ([.CLAUDE/hooks/security-guard.sh](.CLAUDE/hooks/security-guard.sh)) blocks:

- **Privileged commands**: `sudo`, `su`, `runas`, `chmod 777`
- **Destructive operations**: `rm -rf /`, `format`, `mkfs`, `dd`
- **System modifications**: `shutdown`, `reboot`
- **File access outside project**: All Read/Write/Edit operations restricted
- **Sensitive files**: `.env`, credentials, API keys, SSH keys
- **Dangerous git**: `git push --force`, `rm -rf .git`
- **Remote code execution**: `curl|bash`, `wget|sh`, reverse shells

---

## Quick Start

### 1. Copy Configuration

```bash
# Copy the .CLAUDE directory and config files to your project
cp -r .CLAUDE /path/to/your/project/
cp CLAUDE.md WORKFLOW.md /path/to/your/project/
```

### 2. Adapt Standards

Edit `CLAUDE.md` to match your project's:
- File header format
- Code commenting rules
- README structure
- Git workflow
- Changelog format

### 3. Customize Commands

Modify commands in `.CLAUDE/commands/` to match your:
- Project paths
- Release workflow
- Docker registry
- Git branching strategy

---

## Configuration Files

### settings.json (Shared)

Hook configuration and shared permissions:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash|Read|Write|Edit|Glob|Grep",
        "hooks": [
          {
            "type": "command",
            "command": "bash \"$CLAUDE_PROJECT_DIR/.CLAUDE/hooks/security-guard.sh\"",
            "timeout": 10,
            "statusMessage": "Security check..."
          }
        ]
      }
    ]
  },
  "permissions": {
    "allow": [
      "Bash(gh pr create:*)",
      "Bash(gh release create:*)"
    ]
  },
  "includeCoAuthoredBy": false
}

---

## Standards Overview

### CLAUDE.md

- **File Headers**: Mandatory copyright and purpose blocks
- **Section Headers**: Uppercase titles with descriptions
- **Comments**: Only for complex logic, not obvious code
- **README Format**: Comprehensive template with required sections
- **Git Workflow**: Version branches, feature branches, changelog-per-commit
- **Changelog Format**: Keep a Changelog + Semantic Versioning

### WORKFLOW.md

- **Operating Principles**: Correctness, minimal changes, verification
- **Task Management**: File-based tracking in `.CLAUDE/tasks/`
- **Quality Assurance**: Test before commit, incremental delivery
- **Communication**: Concise, high-signal reporting

---

## Example Workflow

```bash
# 1. Start a new version
git checkout main && git pull
git checkout -b v1.2.0

# 2. Make changes...

# 3. Add changelog entry
/changelog low-layer-website

# 4. Commit and push
/push low-layer-website

# 5. More changes... repeat steps 2-4

# 6. Create release
/release low-layer-website

# 7. Build Docker image
/docker-release low-layer-website
```

---

## License

This project is licensed under the [MIT License](LICENSE).

---

## Author

**LOW-LAYER Engineering** - Toulouse, France

- Website: [https://low-layer.com](https://low-layer.com)
- Contact: contact@low-layer.com
