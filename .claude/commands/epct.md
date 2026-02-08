---
description: Explore codebase, create implementation plan, code, and test following EPCT workflow
argument-hint: <feature-description|ticket>
allowed-tools: Bash, Read, Edit, Write, Grep, Glob, Task, WebSearch, WebFetch
---

# EPCT Command

Explore-Plan-Code-Test workflow for implementing features systematically with thorough analysis.

**You need to always ULTRA THINK.**

## Usage

```bash
/epct <feature-description|ticket>
```

**Examples:**
```bash
/epct "Add user authentication with OAuth"
/epct "Implement dark mode toggle"
/epct "Refactor database connection pooling"
```

## Workflow Context

This command guides complete feature implementation:

```
1. /epct <feature>             # <- THIS COMMAND (full implementation)
2. /changelog <project>        # Document the changes
3. /push <project>             # Commit the work
```

## Instructions

When the user invokes `/epct <feature>`, execute the following steps:

### Step 0: Auto-Detect Skills

Before any exploration, detect and load relevant skills:
1. Use `Bash` to list `~/.claude/skills/*/SKILL.md` (Glob does not follow symlinks)
2. Read frontmatters to extract `name`, `description`, `triggers`
3. Match `triggers` against the task description and any known file paths/extensions
4. Load matched skills (read full `SKILL.md` content) — their rules apply for the **entire EPCT session**
5. Display to user: "Skills loaded: `skill-a`, `skill-b`" (or "No skills detected" if none match)
6. If no skills are installed, skip silently

> Loaded skills MUST be injected into **every subagent prompt** during all subsequent steps (Explore, Code, Test). See WORKFLOW.md § Context Injection.

### Step 1: Explore

Use parallel subagents to find and read all files that may be useful:
- Search for existing similar implementations as examples
- Find files that will need modification
- Identify **existing test patterns** in the codebase (framework, naming, structure)
- Locate documentation and configuration files
- **ULTRA THINK**: What patterns exist? What can be reused?

Subagents should return:
- Relevant file paths
- Code patterns found
- **Test patterns found** (framework used, file naming, AAA structure, mocking strategy)
- Useful context for implementation

### Step 2: Plan

Think hard and write up a detailed implementation plan:
- List all files to create or modify
- Use your judgement for what's necessary given repo standards
- **CRITICAL**: If unsure, launch parallel subagents for web research

**Test plan (MANDATORY)** — for every feature, the plan MUST include:
- Which **unit tests** to write or update (list the spec/test files)
- Which **integration tests** if boundaries are crossed (HTTP, DB, K8s API)
- Which **E2E tests** if a critical user flow is affected
- Reference `testing-standards.md` for stack-specific conventions (Go: `_test.go`, TS: `.spec.ts`, Helm: `helm lint`, etc.)

> **Rule**: A plan without a test section is incomplete. Do not present it for validation.

**DoD declaration** — the plan must include a DoD checklist:
- [ ] Acceptance criteria met
- [ ] Tests written and passing (TU + TI + TE2E as applicable)
- [ ] Lint/typecheck/build pass
- [ ] Code follows project conventions
- [ ] Verification story filled in

**Before proceeding:**
- If there are ambiguities, pause and ask the user
- Present the plan (with test plan + DoD) for confirmation
- **ULTRA THINK**: Is this the right approach?

### Step 3: Code

When you have a thorough implementation plan, start writing code:
- Follow the style of the existing codebase
- Prefer clearly named variables/methods over extensive comments
- **Write tests alongside production code** — not after, not later, alongside
- For each implementation slice: write the code, then immediately write its tests
- Run autoformatting when done
- Fix reasonable linter warnings
- **STAY IN SCOPE**: Build exactly what's planned

### Step 4: Test (GATE — blocks Step 5)

Use parallel subagents to run ALL tests declared in the plan:
- Run **unit tests** for modified code
- Run **integration tests** if applicable
- Run **E2E tests** if applicable
- Run **lint/typecheck/build** to catch regressions

**This step is a gate** — Step 5 CANNOT proceed until:
- [ ] All declared tests pass
- [ ] No new lint/typecheck errors
- [ ] Build succeeds

**If testing shows problems:**
> Go back to Step 3 and **ULTRA THINK** about what went wrong. Fix the code AND the tests. Re-run Step 4.

### Step 5: Write Up

When **all tests pass** (Step 4 gate cleared), write a short report for PR description:
- What you set out to do
- Choices made with brief justification
- **Test coverage summary**: which tests were added/modified, what they verify
- Commands run that may be useful for future developers
- Any follow-up tasks identified

**Verify DoD** — check every item declared in Step 2:
- [ ] Acceptance criteria met
- [ ] Tests written and passing
- [ ] Lint/typecheck/build pass
- [ ] Code follows project conventions
- [ ] Verification story filled in

## Quality Checklist

Before completing:
- [ ] Code follows existing patterns
- [ ] **All declared tests written and passing**
- [ ] No lint/typecheck warnings
- [ ] Build passes
- [ ] Documentation updated if needed
- [ ] Changes are minimal and focused
- [ ] DoD from plan fully checked

## Error Handling

| Issue | Action |
|-------|--------|
| Tests failing | Analyze errors, fix code/tests, re-run Step 4 |
| Missing test patterns | Read `testing-standards.md`, explore existing tests |
| Unclear requirements | Ask user for clarification |
| Missing dependencies | Research and propose additions |
| Conflicts with existing code | Propose refactoring approach |

## Notes

- **ULTRA THINK** at each phase transition
- Use parallel agents for comprehensive exploration
- Document findings and reasoning at each step
- **Tests are not optional** — no feature ships without tests
- Priority: Correctness > Completeness > Speed

User: $ARGUMENTS
