---
description: TDD bug fix workflow. Write a failing E2E test (Red), fix the bug (Green), iterate until passing.
argument-hint: <describe the buggy behavior>
allowed-tools: Bash, Read, Edit, Write, Grep, Glob, Task, WebSearch, WebFetch
---

# Red-Green Command

TDD-style bug fix workflow: write a failing E2E test first (Red), then fix the bug (Green), with iteration.

**You need to always ULTRA THINK.**

## Usage

```bash
/red-green <describe the buggy behavior>
```

**Examples:**
```bash
/red-green "Clicking save on the graph editor loses node positions"
/red-green "Login form submits twice when pressing Enter"
/red-green "Dashboard chart does not update after filtering by date"
```

## Workflow Context

This command guides TDD bug resolution:

```
1. /red-green <bug-description>   # <- THIS COMMAND (test first, then fix)
2. /changelog <project>            # Document the fix
3. /push <project>                 # Commit the work
```

## Instructions

When the user invokes `/red-green <bug-description>`, execute the following steps:

### Step 0: Auto-Detect Skills

Before any exploration, detect and load relevant skills:
1. Use `Bash` to list `~/.claude/skills/*/SKILL.md` (Glob does not follow symlinks)
2. Read frontmatters to extract `name`, `description`, `triggers`
3. Match `triggers` against the bug description and any known file paths/extensions
4. Load matched skills (read full `SKILL.md` content) — their rules apply for the **entire Red-Green session**
5. Display to user: "Skills loaded: `skill-a`, `skill-b`" (or "No skills detected" if none match)
6. If no skills are installed, skip silently

> Loaded skills MUST be injected into **every subagent prompt** during all subsequent steps (Explore, Red, Investigate, Fix, Green). See WORKFLOW.md § Context Injection.

### Step 1: Explore

Use parallel subagents to understand the bug area and the E2E test infrastructure:
- Understand the buggy behavior area (components, services, data flow)
- Find existing E2E test patterns (framework, fixtures, selectors, auth setup)
- Find the E2E test directory structure and configuration
- Identify dev server start commands and E2E runner configuration
- **ULTRA THINK**: What is the expected vs actual behavior? What assertion will prove the bug exists?

Subagents should return:
- Relevant file paths for the buggy area
- E2E framework in use (Playwright, Cypress, etc.)
- Existing test patterns: auth fixtures, page objects, selectors, assertion style
- Dev server and E2E runner commands
- Useful context for writing the failing test

### Step 2: Red (Write Failing E2E Test)

Write an E2E test that reproduces the bug:
- Follow existing test patterns exactly (auth fixture, selectors, assertions)
- Reproduce the bug scenario described by the user
- Include a clear assertion that SHOULD pass once the bug is fixed
- Add a comment block explaining the expected failure and the bug being targeted

Then verify the test fails correctly:
1. Start or confirm the dev server is running
2. Run the E2E test
3. Confirm it **FAILS on the correct assertion** (not a setup error, not a wrong selector, not a timeout)
4. If it fails for the wrong reason: fix the test, not the code. Iterate until the test fails on the intended assertion.
5. If the test **passes** before any fix: the bug is not reproduced. Re-examine the bug description, adjust the test scenario, and retry.

> **Gate**: Do not proceed to Step 3 until the test fails on the correct assertion. This is the Red confirmation.

### Step 3: Investigate Root Cause

Use parallel subagents to find the root cause:
- Trace the data flow from UI action to persistence (or wherever the bug manifests)
- Apply the **WHY technique** 5+ times: symptom → immediate cause → deeper cause → root cause
- Map the failure path with exact file paths and line numbers
- Identify the minimal fix (smallest change that corrects the behavior)
- **ULTRA THINK**: Is this truly the root cause, or just a symptom?

Subagents should return:
- Root cause description
- Exact file paths and line numbers involved
- Proposed minimal fix approach
- Any side effects or risks of the fix

### Step 4: Fix (Green Attempt)

Implement the minimal fix:
- One subagent per implementation slice (1 to 3 related files)
- Follow existing code patterns and conventions
- Do NOT over-engineer or refactor surrounding code
- **STAY IN SCOPE**: Fix only the root cause identified in Step 3

### Step 5: Green (Verify) — GATE with Iteration

This step gates completion. The E2E test must pass.

1. Ensure the dev server has reloaded with the changes (wait for recompilation if using hot reload, or restart the server explicitly if needed)
2. Run the E2E test from Step 2
3. **If the test PASSES**: proceed to Step 6
4. **If the test FAILS**: analyze the failure output, **ULTRA THINK** about what went wrong, go back to Step 4, fix, and retry
5. **Maximum 3 iterations** of the Step 4 → Step 5 loop. If still failing after 3 attempts: stop, present all evidence (test output, code changes, hypotheses), and ask the user for guidance.

> **Gate**: Do not proceed to Step 6 until the E2E test passes. This is the Green confirmation.

### Step 6: Write Up

When the E2E test passes (Step 5 gate cleared), write a short report for PR description:
- **Root cause**: What the bug was and why it happened
- **Fix**: What was changed (files modified, approach taken)
- **Test coverage**: Which E2E test verifies the fix (file path and test name)
- **Verification story**: How we know it works (test output, before/after behavior)
- Any follow-up tasks identified

**Verify DoD**:
- [ ] Bug no longer reproduces (E2E test passes)
- [ ] E2E test correctly validates the fixed behavior
- [ ] No regressions in related tests
- [ ] Code follows project conventions
- [ ] Verification story filled in

## Error Handling

| Issue | Action |
|-------|--------|
| Test fails for wrong reason (setup, selector, timeout) | Fix the test, not the code. Iterate Step 2. |
| Test passes before fix (bug not reproduced) | Re-examine bug description, adjust test scenario |
| Fix doesn't make test pass after 3 iterations | Stop, show evidence, ask user for guidance |
| Dev server doesn't reload | Restart the server explicitly |
| E2E infrastructure not set up | Guide user through setup (Playwright install, env file, etc.) |
| Missing test patterns | Explore existing E2E tests more broadly, check `testing-standards.md` |
| Unclear bug description | Ask user for clarification with recommended default |

## Notes

- **ULTRA THINK** at each phase transition
- **Red before Green**: never skip the failing test step
- The test proves the bug exists AND proves the fix works
- Minimal fix only: don't refactor surrounding code
- Use parallel agents for comprehensive exploration and investigation
- Document findings and reasoning at each step
- Priority: Correct test > Correct fix > Speed

User: $ARGUMENTS