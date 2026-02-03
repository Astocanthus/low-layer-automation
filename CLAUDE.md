# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

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
| `CLAUDE.md` | Code standards, documentation formats, Git workflow |
| `WORKFLOW.md` | AI agent orchestration, task management, quality assurance |
| `.CLAUDE/tasks/todo.md` | Current work items and working memory |
| `.CLAUDE/tasks/lessons.md` | Failure modes and prevention rules |

> **Important**: Always follow `WORKFLOW.md` for operational principles and task management. This file (`CLAUDE.md`) defines code and documentation standards.

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

- Hook script: `.claude/hooks/security-guard.sh`
- Settings: `.claude/settings.json`

### Disabling (Not Recommended)

To temporarily disable security, set `"disableAllHooks": true` in settings or use `/hooks` menu.

---

## Code Generation Standards

**ROLE:** When generating or refactoring code in this repository, act as a Senior Code Refactoring and Documentation Specialist for "LOW-LAYER". Rewrite, format, and document every code file to meet the strict standardization rules below, regardless of the programming language (Python, Go, Bash, YAML, TOML, Ansible, etc.).

**OUTPUT LANGUAGE:** All comments, documentation, and descriptions must be in **ENGLISH**.

### 1. File Headers (Mandatory)

Every single file must start with this exact header block.
**Note:** Apply the "Copyright (C) - LOW-LAYER" line by default, unless explicitly stated "NO LICENSE" for a specific file.

```
# Copyright (C) - LOW-LAYER
# Contact : contact@low-layer.com

# ============================================================================
# [INSERT FILE NAME HERE]
# [One-line summary of what this file is]
#
# Purpose:
#   - [Bulleted list: Why does this file exist?]
#   - [Example: Installs dependencies for the API]
#
# Key Functions:
#   - [Bulleted list: What are the main methods, tasks, or configuration blocks?]
#   - [Example: Configures network interfaces]
#   - [Example: Manages error handling logic]
#
# Characteristics:
#   - [Bulleted list: Technical details, idempotency, specific versions, etc.]
#   - [Example: Idempotent execution]
#   - [Example: Requires root privileges]
# ============================================================================
```

### 2. Block/Section Headers

For every major function, class, or configuration section (like a Pod template in YAML or a specific TOML block), use the following separator style. It must include a short title and a one-sentence introduction.

```
# ---------------------------------------------------------------------------
# [SECTION TITLE IN UPPERCASE]
# ---------------------------------------------------------------------------
# [Brief sentence describing exactly what this section does].
```

### 3. Commenting Logic

Follow these specific rules based on the file type:

#### A. For Standard Code (Python, Go, C++, Bash, etc.)

- **Inline Comments:** Do NOT comment obvious code. Only add single-line comments internally for **complex logic** or non-obvious algorithms.

#### B. For Configuration & Automation (Ansible, YAML, TOML, Kubernetes Manifests)

- **Descriptive Input:** Every input or task must have a comment describing what it does.
- **Ansible Specifics:** Place a comment immediately under the `- name:` line to explain the task technically.

**Example format for Ansible:**
```yaml
- name: Install python3-kubernetes to call API
  # Installs the python3-kubernetes package via rpm-ostree for API interaction
  community.general.rpm_ostree_pkg:
    name:
      - "python3-kubernetes-{{ python_version_kubernetes }}"
```

### 4. Documentation Update (Markdown)

After processing code files, generate or update a `README.md` file documenting the changes.

### 5. Execution Process

1. Receive the code content
2. REWRITE the code applying the headers, separators, and comments defined above
3. Output each file in a separate code block
4. Output the updated `README.md` at the end

---

## README Standards

All `README.md` files in LOW-LAYER projects MUST follow this standardized structure. Adapt sections based on project type (library, service, tool, infrastructure).

### Required Structure

#### 1. Header Section (Mandatory)

```markdown
# Project Name

[![Tech1](https://img.shields.io/badge/Tech1-Version-COLOR?style=for-the-badge&logo=LOGO&logoColor=white)](URL)
[![Tech2](https://img.shields.io/badge/Tech2-Version-COLOR?style=for-the-badge&logo=LOGO&logoColor=white)](URL)

[![License: LOW-LAYER](https://img.shields.io/badge/License-LOW--LAYER-blue.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-XX%20passed-success)](./tests/)
[![Coverage](https://img.shields.io/badge/Coverage-XX%25-green)](./tests/)

[One-line description of what this project does and its main value proposition.]

[Optional: 1-2 sentences explaining the unique approach or differentiator.]

---
```

**Badge Categories:**
- **Technology Stack**: Node.js, Python, Go, Docker, Kubernetes, etc.
- **Status**: License, Tests, Coverage, Build Status
- **Links**: GitHub Issues, Documentation

#### 2. Features Section

```markdown
## Features

- **Feature Name**: Brief description of what it does.
- **Feature Name**: Brief description of what it does.
- **Feature Name**: Brief description of what it does.

---
```

#### 3. Project Structure (For codebases)

```markdown
## Project Structure

\`\`\`
project-name/
├── Dockerfile                  # Description
├── package.json
├── src/
│   ├── main.js                 # Entry point
│   ├── lib/
│   │   ├── module1.js          # Description
│   │   └── module2.js          # Description
│   └── routes/
│       └── api.js              # Description
├── tests/
│   └── unit/
│       └── module.test.js      # Description
└── docs/
    └── API.md                  # API documentation
\`\`\`

---
```

#### 4. Architecture Section (For services/applications)

Use Mermaid diagrams to illustrate flows:

```markdown
## Architecture

### [Flow Name]

\`\`\`mermaid
sequenceDiagram
    participant User
    participant Service
    participant Database

    User->>Service: Request
    Service->>Database: Query
    Database-->>Service: Response
    Service-->>User: Result
\`\`\`

---
```

#### 5. Quick Start Section

```markdown
## Quick Start

### Prerequisites

- **Dependency 1**: Version X.X+ with specific requirement.
- **Dependency 2**: Brief description of why it's needed.

### Installation

\`\`\`bash
# Clone the repository
git clone https://github.com/org/project.git
cd project

# Install dependencies
npm install  # or pip install -r requirements.txt

# Run
npm start
\`\`\`

### Docker Compose (If applicable)

\`\`\`yaml
version: '3.8'

services:
  service-name:
    image: image:tag
    environment:
      - VAR=value
    ports:
      - "3000:3000"
\`\`\`

---
```

#### 6. Configuration Section

```markdown
## Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `VAR_NAME` | What it configures | Yes/No | value |
| `VAR_NAME` | What it configures | Yes/No | — |

### [Subsection if needed: Logging, Security, etc.]

| Option | Description | Values |
|--------|-------------|--------|
| `option` | What it does | value1, value2 |

---
```

#### 7. API/Endpoints Section (For services)

```markdown
## API Endpoints

### [Route Group Name] (`/path/`)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/path/action` | GET | What it does |
| `/path/action` | POST | What it does |

---
```

#### 8. Health Check Section (For containerized services)

```markdown
## Health Check Endpoints

| Endpoint | Type | Status Codes | Description |
|----------|------|--------------|-------------|
| `/health` | Liveness | 200 | Process is running |
| `/ready` | Readiness | 200 / 503 | Dependencies healthy |

### Kubernetes Probe Configuration

\`\`\`yaml
livenessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 5
  periodSeconds: 10
\`\`\`

---
```

#### 9. Development Section

```markdown
## Development

### Local Setup

\`\`\`bash
# Development mode
npm run dev
\`\`\`

### Running Tests

\`\`\`bash
npm test              # Run all tests
npm run test:watch    # Watch mode
npm run test:coverage # Coverage report
\`\`\`

### Test Coverage (If applicable)

| Module | Statements | Branches | Functions |
|--------|------------|----------|-----------|
| `module.js` | XX% | XX% | XX% |
| **Total** | **XX%** | **XX%** | **XX%** |

---
```

#### 10. Troubleshooting Section

```markdown
## Troubleshooting

### "Error Message Here"

**Cause**: Explanation of why this happens.

**Solution**: Steps to resolve.

### Issue Description

Check specific configuration:
\`\`\`bash
command to diagnose
\`\`\`

---
```

#### 11. Footer Sections (Mandatory)

```markdown
## License

This project is licensed under the [LOW-LAYER Source Available License](LICENSE).

- **Free** for up to 5 users
- **Commercial license** required for larger teams
- Contact: contact@low-layer.com

---

## Author

**Author Name** - Role/Title

- GitHub: [@username](https://github.com/username)
- LinkedIn: [Name](https://linkedin.com/in/profile)

---

## Acknowledgments

- Built for [Organization/Project](URL)
- Powered by [Technology](URL)
```

### Section Selection Guide

| Project Type | Required Sections |
|--------------|-------------------|
| **Library/Package** | Header, Features, Quick Start, API, Development, License, Author |
| **Service/API** | Header, Features, Architecture, Quick Start, Config, API, Health, Troubleshooting, License, Author |
| **CLI Tool** | Header, Features, Quick Start, Config (flags), Examples, License, Author |
| **Infrastructure** | Header, Features, Architecture, Quick Start, Config, Troubleshooting, License, Author |
| **Ansible Role** | Header, Features, Variables Table, Dependencies, Example Playbook, License, Author |

### Badge Color Reference

| Technology | Color Code | Logo Name |
|------------|------------|-----------|
| Node.js | 339933 | nodedotjs |
| Python | 3776AB | python |
| Go | 00ADD8 | go |
| Docker | 2496ED | docker |
| Kubernetes | 326CE5 | kubernetes |
| Ansible | EE0000 | ansible |
| PostgreSQL | 4169E1 | postgresql |
| Redis | DC382D | redis |
| Keycloak | 4D4D4D | keycloak |
| Ghost | 738A94 | ghost |

---

## Git Workflow

**Context:** Single developer workflow - simplified release branching without complex GitFlow.

### Branching Strategy

```
main (stable releases)
  │
  └── vX.Y.Z (version branch for development)
        │
        └── feature/description (feature branches)
```

### Rules

1. **Version Branches**: All development happens on version branches (`v1.2.0`, `v2.0.0`, etc.)
2. **Feature Branches**: Each feature is developed on a dedicated branch from the version branch
3. **Versioning**: Each completed feature produces a **new minor version** (X.Y.0 → X.Y+1.0)
4. **Changelog**: Every feature MUST be documented in the project's `CHANGELOG.md`
5. **Merge Flow**: `feature/* → vX.Y.Z → main` (with tag)

### Branch Naming Convention

**Pre-release (before v1.0.0):**

| Type | Pattern | Example |
|------|---------|---------|
| Version | `v0.X.Y` | `v0.1.0`, `v0.2.0` |
| Feature | `feature/short-description` | `feature/health-endpoints` |
| Bugfix | `fix/short-description` | `fix/auth-cookie-issue` |

**Production releases (v1.0.0 and above):**

| Type | Pattern | Example |
|------|---------|---------|
| Release | `release/vX.Y.Z` | `release/v1.0.0`, `release/v1.2.0` |
| Feature | `feature/short-description` | `feature/health-endpoints` |
| Bugfix | `fix/short-description` | `fix/auth-cookie-issue` |
| Hotfix | `hotfix/short-description` | `hotfix/critical-security` |

### Workflow Steps

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

---

## Changelog Standards

All LOW-LAYER projects MUST maintain a `CHANGELOG.md` file following the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

### Required Structure

```markdown
# Changelog

All notable changes to the [Project Name] project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Planned

- Feature or improvement description

---

## [X.Y.Z] - YYYY-MM-DD

### Added

- **Feature Name** (`path/to/file.js`)
  - Detailed description of what was added
  - Sub-feature or capability
  - Technical details if relevant

### Changed

- **Component Name**
  - Description of what changed and why

### Fixed

- **Bug Description**
  - What was fixed and how

### Removed

- Description of removed feature/code

### Security

- Security-related changes

### Developer Experience

- `npm command` - Description of what it does

---

[X.Y.Z]: https://github.com/org/repo/compare/vX.Y-1.Z...vX.Y.Z
[X.Y-1.Z]: https://github.com/org/repo/releases/tag/vX.Y-1.Z
```

### Section Categories

Use these categories in order of appearance:

| Category | Description |
|----------|-------------|
| **Added** | New features, endpoints, files, capabilities |
| **Changed** | Modifications to existing functionality |
| **Deprecated** | Features marked for future removal |
| **Removed** | Features or code that was deleted |
| **Fixed** | Bug fixes |
| **Security** | Security patches or improvements |
| **Developer Experience** | Dev tooling, scripts, test improvements |

### Entry Format Rules

1. **Bold the feature/component name**: `**Feature Name**`
2. **Include file path**: `(`path/to/file.js`)`
3. **Use bullet points** for details under each feature
4. **Be specific**: Include endpoint paths, function names, configuration options
5. **Group related changes** under the same feature entry

### Example Entry

```markdown
### Added

- **Health Check Endpoints** (`src/routes/health.js`)
  - `GET /health`, `/healthz` - Liveness probe (always 200 if process running)
  - `GET /ready`, `/readyz` - Readiness probe (200 if database connected, 503 otherwise)
  - `GET /startup` - Startup probe for slow-starting containers
  - JSON responses with status, timestamp, and diagnostic info
  - Kubernetes/Podman orchestration ready

- **Centralized Logging System** (`src/lib/logger.js`)
  - Winston-based structured logging
  - Configurable log levels: error, warn, info, http, debug
  - Environment-driven format switching:
    - Production: JSON format for log aggregators (ELK, Loki, CloudWatch)
    - Development: Colored human-readable output
  - Module-specific loggers with automatic context injection
  - `LOG_LEVEL` environment variable support
```

### Footer Links (Mandatory)

Always include comparison links at the bottom of the changelog:

```markdown
[1.2.0]: https://github.com/org/repo/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/org/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/org/repo/releases/tag/v1.0.0
```

### Updating the Changelog

**MANDATORY**: When completing a feature:

1. Add entry under `[Unreleased]` during development
2. Move entries to new version section when releasing
3. Update version links at bottom
4. Commit changelog with the feature or in release commit
