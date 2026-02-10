# Changelog

All notable changes to the LOW-LAYER Automation project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

---

## [1.1.0] - 2026-02-10

### Added

- **`/rg` Command: TDD Bug Fix Workflow** (`.claude/commands/rg.md`)
  - Red/Green iteration cycle for test-driven bug fixing
  - Red phase: write a failing E2E test that reproduces the bug
  - Green phase: implement the minimal fix to make the test pass
  - Structured workflow ensuring regression coverage before marking bugs resolved

### Changed

- **WORKFLOW.md Session Bootstrap Table** (`.claude/rules/WORKFLOW.md`)
  - Added `/rg` command entry with required reads for skill detection and session bootstrap
  - Updated quick reference section with `/rg` workflow guidance

- **README.md and CLAUDE.md Command Count** (`README.md`, `CLAUDE.md`)
  - Updated from 10 to 11 custom slash commands to reflect the addition of `/rg`

---

## [1.0.1] - 2026-02-09

### Changed

- **Auto-Allow Permissions** (`.claude/settings.json`)
  - Added non-destructive command permissions for streamlined developer workflow
  - File reading, builds, tests, search/exploration, and file navigation/copy/move operations
  - Full stack tooling coverage: Go, Rust, Node.js/Angular, Docker, Git (read only), and GitHub CLI
  - Eliminates manual approval prompts for safe, routine development operations

---

## [1.0.0] - 2026-02-09

### Added

- **Security Hook System** (`.claude/hooks/security-guard.sh`)
  - Pre-execution guard blocking dangerous operations: `sudo`, `su`, `rm -rf`, `chmod 777`, `shutdown`, `reboot`
  - Sensitive file protection: `.env`, credentials, API keys, SSH keys
  - Dangerous Git operations prevention: `git push --force`, `rm -rf .git`
  - Remote code execution pattern detection: `curl|bash`, `wget|sh`, reverse shells
  - File access restriction to project directory only
  - Configurable via `.claude/settings.json`

- **10 Custom Slash Commands** (`.claude/commands/`)
  - `/epct` — AI-driven exploration, planning, coding, and test orchestration with subagents
  - `/push` — Git workflow automation with conventional commit enforcement
  - `/changelog` — Keep a Changelog entry generator with format compliance
  - `/release` — Semantic versioning and release automation with git tagging
  - `/release-note` — Release note generation from changelog entries
  - `/docker-release` — Docker image build and registry push workflows
  - `/debug` — Error triage and diagnostic workflow orchestration
  - `/web-design` — Documentation site scaffolding and README updates
  - `/arch-update` — Architecture documentation synthesis from codebase analysis
  - `/create-cmd` — Custom command scaffolding with CLI argument binding

- **Code Generation Standards** (`.claude/standards/code-standards.md`)
  - File header templates with copyright notice and summary
  - Section header conventions for code organization
  - Inline commenting rules: only complex logic for code, every task for automation
  - Output language: English for all comments and documentation

- **README Standards** (`.claude/standards/readme-standards.md`)
  - Standardized README template with required sections per project type
  - Badge placement and `for-the-badge` format conventions
  - Release and Issues badge requirements
  - Footer sections: License, Author, Acknowledgments

- **Git Workflow Standards** (`.claude/standards/git-workflow.md`)
  - Branching strategy: `main → vX.Y.Z → feature/*`
  - Conventional commit naming conventions
  - Atomic commit discipline rules
  - Pre-release (`v0.X.Y`) and production (`release/vX.Y.Z`) patterns

- **Changelog Standards** (`.claude/standards/changelog-standards.md`)
  - Keep a Changelog format with Semantic Versioning
  - Section categories: Added, Changed, Deprecated, Removed, Fixed, Security, Developer Experience
  - Entry format: bold feature name + file path + bullet details
  - Footer comparison links mandatory

- **Testing Standards** (`.claude/standards/testing-standards.md`)
  - Test pyramid principles: unit, integration, E2E layers
  - Per-stack testing patterns (TypeScript/Angular, Go, Bash)
  - Regression test requirements for bug fixes
  - Coverage targets and reporting conventions

- **License Template System** (`.claude/licenses/`)
  - LOW-LAYER Proprietary License v1.1 with 5-user free tier
  - MIT Open Source License
  - Dynamic metadata headers for automated README badge generation
  - Rule: always ask user which license to apply for new projects

- **AI Orchestration Framework** (`CLAUDE.md`, `.claude/rules/WORKFLOW.md`)
  - Plan Mode default for non-trivial tasks (3+ steps, multi-file changes)
  - Subagent strategy for all phases: Explore, Plan, Code, Test
  - Main context reserved for orchestration only
  - Context injection of skills and standards into subagent prompts
  - Incremental delivery with thin vertical slices
  - Definition of Done (DoD) checklist for task completion

- **Task Management System** (`.claude/rules/todo.md`, `.claude/tasks/`)
  - Feature/task plan template with acceptance criteria and verification story
  - Bugfix template with repro steps, root cause, and regression testing
  - File-based auditable tracking: templates in `rules/`, plans in `tasks/`

- **Lessons Learned System** (`.claude/rules/lessons.md`)
  - Failure mode documentation with detection signals and prevention rules
  - Self-improvement loop: capture lessons after corrections
  - Review at session start and before major refactors

- **Skills Auto-Detection** (integrated into `WORKFLOW.md`)
  - Automatic skill discovery from `~/.claude/skills/*/SKILL.md`
  - Trigger-based matching: keywords, file extensions, project markers
  - Context injection into all subagent prompts
  - Skill acknowledgment verification in subagent responses

### Changed

- **Configuration Restructured for Opus 4.6** (`.claude/`)
  - Reorganized command patterns with `argument-hint` and `allowed-tools` fields
  - Extracted architecture repository as separate reference module
  - Updated console architecture documentation to Angular/Nx conventions

- **Standards Externalized** (`.claude/standards/`)
  - Moved standards from monolithic `CLAUDE.md` into 5 dedicated files
  - Standardized reference paths across all commands

- **License Files Renamed** (`.claude/licenses/`)
  - Renamed to semantic names: `low-layer.license`, `mit.license`
  - Added metadata headers with badge and readme text fields

### Fixed

- **Command Argument Handling** (`.claude/commands/`)
  - Added missing `User: $ARGUMENTS` to 4 commands for proper CLI argument binding

- **README References** (`.claude/commands/`, `CLAUDE.md`)
  - Renamed `create-cmd` references, lowercased `.claude` paths, updated workflow paths

---

[1.1.0]: https://github.com/Astocanthus/low-layer-automation/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/Astocanthus/low-layer-automation/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/Astocanthus/low-layer-automation/releases/tag/v1.0.0
