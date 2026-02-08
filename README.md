# LOW-LAYER Automation

[![Claude Code](https://img.shields.io/badge/Claude_Code-Config-7C3AED?style=for-the-badge&logo=anthropic&logoColor=white)](https://claude.ai/code)
[![Bash](https://img.shields.io/badge/Bash-Hooks-4EAA25?style=for-the-badge&logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Issues](https://img.shields.io/github/issues/Astocanthus/low-layer-automation)](https://github.com/Astocanthus/low-layer-automation/issues)

**Claude Code automation configuration** for development workflows: code standards, AI orchestration, custom commands, and security hooks.

This repository contains a production-ready Claude Code setup with workflows for release management, changelog generation, debugging, and more.

---

## Features

- **Security Hook**: Pre-execution guard blocking dangerous operations (sudo, rm -rf, sensitive files)
- **10 Custom Commands**: Specialized workflows for common development tasks
- **[Skills Auto-Detection](#skills)**: Context-aware skill loading via [jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills)
- **Code & Testing Standards**: Guidelines for code generation, documentation, and [test pyramid](.claude/standards/testing-standards.md)
- **AI Orchestration**: Workflow patterns for effective Claude Code usage
- **Task Management**: File-based todo tracking and lessons learned system

---

## Structure

```
low-layer-automation/
├── .claude/                         # Claude Code configuration
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
│   │   ├── changelog-standards.md   # Changelog format
│   │   └── testing-standards.md     # Test pyramid, per-stack conventions
│   ├── licenses/                    # License templates
│   │   ├── low-layer.license        # LOW-LAYER proprietary license
│   │   └── mit.license              # MIT license template
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
├── low-layer-architecture/           # Technical documentation (LOW-LAYER example)
│   ├── platform.md                  # Platform architecture
│   ├── repositories.md              # Multi-repo structure
│   └── infrastructure.md            # Infrastructure architecture
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

## Skills

Skills inject domain expertise (language patterns, framework conventions, testing strategies) into Claude Code sessions. Commands like `/epct` and `/debug` **auto-detect** relevant skills based on file extensions, project markers, and task keywords — no manual selection needed.

Skills are loaded from [jeffallan/claude-skills](https://github.com/Jeffallan/claude-skills) (65 skills, 12 categories). Full documentation: [jeffallan.github.io/claude-skills](https://jeffallan.github.io/claude-skills)

### Installation (Global)

This project uses **global installation** to avoid duplicating skills across repositories:

```bash
# Install the CLI
npx skills add https://github.com/Jeffallan/claude-skills --list   # Preview available skills

# Install skills globally (available across all projects)
npx skills add https://github.com/Jeffallan/claude-skills -g -s golang-pro
npx skills add https://github.com/Jeffallan/claude-skills -g -s angular-architect
npx skills add https://github.com/Jeffallan/claude-skills -g -s test-master
npx skills add https://github.com/Jeffallan/claude-skills -g -s kubernetes-specialist
npx skills add https://github.com/Jeffallan/claude-skills -g -s terraform-engineer
npx skills add https://github.com/Jeffallan/claude-skills -g -s typescript-pro
```

> Global skills are stored in `~/.claude/skills/` and shared across all projects.

### Recommended Profiles

| Profile | Skills | Use case |
|---------|--------|----------|
| **Backend** | `golang-pro`, `postgres-pro`, `api-designer` | API, CLI, Operator, Agent |
| **Frontend** | `angular-architect`, `typescript-pro` | Console (Angular 21) |
| **Infra** | `kubernetes-specialist`, `terraform-engineer`, `devops-engineer` | Operator, Helm, CAPI |
| **Quality** | `test-master`, `code-reviewer`, `debugging-wizard` | All projects |

### Management

```bash
npx skills ls -g                  # List globally installed skills
npx skills find <keyword>         # Search available skills
npx skills check                  # Check for updates
npx skills update                 # Update all skills
npx skills rm -g <skill-name>     # Remove a global skill
```

### How Auto-Detection Works

Each skill has `triggers` in its frontmatter (e.g., `.go`, `angular.json`, `Chart.yaml`). When `/epct` or `/debug` runs:

1. Scans `~/.claude/skills/*/SKILL.md` for installed skills
2. Matches `triggers` against the task description and involved files
3. Loads matched skills and injects their rules into **all subagent prompts**
4. Reports: "Skills loaded: `golang-pro`, `test-master`"

See [WORKFLOW.md § Skill Auto-Detection](.claude/rules/WORKFLOW.md) for implementation details.

---

## Security Hook

The security guard ([.claude/hooks/security-guard.sh](.claude/hooks/security-guard.sh)) blocks:

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

Modify commands in `.claude/commands/` to match your:
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
            "command": "bash \"$CLAUDE_PROJECT_DIR/.claude/hooks/security-guard.sh\"",
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
- **Task Management**: File-based tracking in `.claude/tasks/`
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
