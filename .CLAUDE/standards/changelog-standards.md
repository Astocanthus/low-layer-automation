# Changelog Standards

All LOW-LAYER projects MUST maintain a `CHANGELOG.md` file following the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format and [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## Required Structure

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

---

## Section Categories

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

---

## Entry Format Rules

1. **Bold the feature/component name**: `**Feature Name**`
2. **Include file path**: `(`path/to/file.js`)`
3. **Use bullet points** for details under each feature
4. **Be specific**: Include endpoint paths, function names, configuration options
5. **Group related changes** under the same feature entry

---

## Example Entry

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

---

## Footer Links (Mandatory)

Always include comparison links at the bottom of the changelog:

```markdown
[1.2.0]: https://github.com/org/repo/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/org/repo/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/org/repo/releases/tag/v1.0.0
```

---

## Updating the Changelog

**MANDATORY**: When completing a feature:

1. Add entry under `[Unreleased]` during development
2. Move entries to new version section when releasing
3. Update version links at bottom
4. Commit changelog with the feature or in release commit