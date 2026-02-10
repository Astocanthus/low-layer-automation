# WORKFLOW.md

AI Agent workflow orchestration guidelines for LOW-LAYER projects.

This file complements `CLAUDE.md` with operational principles, task management, and quality assurance rules.

---

## Session Bootstrap (Load Order)

At session start or before any command, load files in this order:

1. **`CLAUDE.md`** — project overview, security, standards index (entry point)
2. **`.claude/rules/WORKFLOW.md`** — this file (orchestration, DoD, task management)
3. **`.claude/rules/lessons.md`** — past failures and prevention rules
4. **`low-layer-architecture/`** — if the task involves structural or architectural changes
5. **Before any command**: read `.claude/commands/<cmd>.md` + its associated standards:

| Command | Required reads |
|---------|---------------|
| `/epct` | `WORKFLOW.md`, `code-standards.md`, `testing-standards.md`, `low-layer-architecture/` |
| `/push` | `git-workflow.md`, `code-standards.md` |
| `/changelog` | `changelog-standards.md` |
| `/web-design` | `code-standards.md`, `readme-standards.md` |
| `/debug` | `WORKFLOW.md` (error handling, triage checklist) |
| `/arch-update` | `low-layer-architecture/` |
| `/rg` | `WORKFLOW.md`, `code-standards.md`, `testing-standards.md` |
| `/release`, `/release-note` | `changelog-standards.md`, `git-workflow.md` |

> **Non-negotiable**: Never skip this bootstrap. Every command depends on it.

---

## Operating Principles (Non-Negotiable)

1. **Correctness over cleverness**: Prefer boring, readable solutions that are easy to maintain.
2. **Smallest change that works**: Minimize blast radius; avoid refactoring unrelated code unless it meaningfully reduces risk.
3. **Leverage existing patterns**: Follow project conventions before introducing new abstractions.
4. **Prove it works**: "Seems right" is not done—validate with tests, build, lint, or reliable manual reproduction.
5. **Be explicit about uncertainty**: Acknowledge what cannot be verified and propose safe next steps.

---

## Workflow Orchestration

### 0. Skill Auto-Detection (Commands with code tasks)

Before starting work in commands like `/epct`, `/debug`, `/rg`, or any command that writes code:

1. **Discover skills**: Use `Bash` to list `~/.claude/skills/*/SKILL.md` (Glob does not follow symlinks)
2. **Read frontmatters**: Extract `name`, `description`, `triggers` from each `SKILL.md`
3. **Auto-detect**: Match skill `triggers` against:
   - The task description (keywords, technology names)
   - File paths involved (extensions: `.go`, `.ts`, `.yaml`, etc.)
   - Project markers (`go.mod`, `angular.json`, `Chart.yaml`, etc.)
4. **Load matched skills**: `Read` full content of detected `SKILL.md` files
5. **Report to user**: Display loaded skills — e.g., "Skills loaded: `golang-pro`, `test-master`"
6. **Inject into ALL subagents**: Include loaded skill rules in every subagent prompt (see Context Injection below)

> **Rule**: Detection is automatic — no user prompt needed. If no skills match, skip silently.

Skills are installed globally via `npx skills add -g` and stored in `~/.claude/skills/<name>/SKILL.md`:
```
~/.claude/skills/
├── golang-pro/
│   ├── SKILL.md        # Frontmatter (name, triggers) + rules
│   └── references/     # Deep-dive reference docs
├── test-master/
│   ├── SKILL.md
│   └── references/
└── ...
```

### 1. Plan Mode Default

- Use for non-trivial tasks (3+ steps, multi-file changes, architectural decisions)
- **Consult `low-layer-architecture/`** before proposing structural changes or new components
- Include verification steps in the plan
- Stop and update the plan if new information invalidates it
- Write crisp specs when requirements are ambiguous

### 2. Subagent Strategy

Use subagents (Task tool) **obligatorily** when:

| Trigger | Why |
|---------|-----|
| Codebase exploration before planning | Main context stays clean for reasoning |
| Pattern search across 3+ files | Parallel search is faster and exhaustive |
| Test/error triage | Isolate noisy output from main flow |
| Dependency or API research | Web search pollutes main context |
| Running tests after implementation | Parallel test suites |

Rules:
- One focused objective per subagent
- Main context must **not** do the exploration itself — delegate it
- Merge subagent outputs into short, actionable synthesis before coding
- **Subagents apply to ALL phases** — not just Explore:
  - **Explore**: subagents for all codebase reads and searches
  - **Plan**: subagent if uncertain or need additional exploration
  - **Code**: subagents do both reading AND writing (`Read` + `Edit`/`Write` inside the subagent). One subagent per implementation slice (1-3 related files)
  - **Test**: subagents to run build/test/lint commands
- **Main context role**: Orchestrate, synthesize, communicate with user. Never `Read`/`Edit`/`Write`/`Bash` directly (exception: small config files <30 lines for routing decisions)
- **Plan approval does NOT lift subagent discipline** — same rules before and after validation

**Context injection**: Subagents do NOT auto-load project rules. When spawning a subagent, always include in the prompt:
- **Detected skills** from Step 0 (include their full rules content)
- The relevant standards from `.claude/standards/` (e.g., `code-standards.md` for code tasks)
- Applicable conventions from `low-layer-architecture/` if the task is structural
- Any constraints from the active task plan in `.claude/tasks/`

**Skill acknowledgment**: Every subagent MUST start its response with:
```
[Skills: golang-pro, test-master] or [Skills: none]
```
If a subagent response does not include this acknowledgment, the main context must flag it and re-inject the skills in a follow-up prompt.

### 3. Incremental Delivery

- Prefer thin vertical slices over big-bang changes
- Implement → test → verify → expand
- Use feature flags, config switches, or safe defaults

### 4. Self-Improvement Loop

- After corrections or mistakes, add entries to `.claude/rules/lessons.md`
- Capture: failure mode, detection signal, prevention rule
- Review lessons at session start and before major refactors

### 5. Verification Before "Done"

- Require evidence: tests, lint/typecheck, build, logs, or deterministic manual reproduction
- Compare baseline vs changed behavior when relevant
- Ask: "Would a staff engineer approve this diff?"

### 6. Demand Elegance (Balanced)

- Pause to ask: "Is there simpler structure with fewer moving parts?"
- Rewrite hacky fixes if it doesn't expand scope materially
- Don't over-engineer simple fixes

### 7. Autonomous Bug Fixing

- Reproduce → isolate root cause → fix → add regression coverage → verify
- Don't offload debugging unless truly blocked
- If blocked, ask for one missing detail with recommended default

---

## Task Management

File-based, auditable task tracking. Templates live in `rules/`, actual task plans live in `tasks/`.

### Where to Write What

| What | Where | Example |
|------|-------|---------|
| Task/plan templates and patterns | `.claude/rules/todo.md` | Plan template, bugfix template |
| Failure modes, prevention rules | `.claude/rules/lessons.md` | Lesson entry |
| **Actual task/feature plans** | **`.claude/tasks/<name>-plan.md`** | `console-architecture-plan.md` |

> **Rule**: Never write actual task plans to `rules/`. Plans always go to `.claude/tasks/`. The `rules/todo.md` file is a **template reference** only — use its patterns when creating plans in `tasks/`.

### Rules

1. **Plan First**: Create a plan in `.claude/tasks/<name>-plan.md` using the templates from `rules/todo.md`. Include explicit "Verify" rules.
2. **Define Success**: Add acceptance criteria to the plan
3. **Track Progress**: Mark items complete; maintain one in-progress item
4. **Checkpoint Notes**: Capture discoveries, decisions, and constraints in the plan's Working Notes section
5. **Document Results**: What changed, where, how verified
6. **Capture Lessons**: Update `.claude/rules/lessons.md` after corrections or discoveries

### File Structure

```
.claude/
├── rules/
│   ├── todo.md       # Task templates and patterns (reference only)
│   ├── lessons.md    # Failure modes and prevention rules
│   └── WORKFLOW.md   # This file — workflow guidelines
└── tasks/
    └── *-plan.md     # Actual task/feature plans (generated by /epct, plan mode, etc.)
```

---

## Communication Guidelines

### 1. Be Concise, High-Signal

- Lead with outcome and impact, not process
- Reference concrete artifacts: file paths, commands, error messages
- Summarize logs; point to evidence location

### 2. Ask Questions Only When Blocked

- Ask exactly one targeted question
- Provide recommended default
- State what changes based on the answer

### 3. State Assumptions and Constraints

- List inferred requirements briefly
- Explain why verification wasn't run if applicable

### 4. Show the Verification Story

- Always include: what was run (tests/lint/build) and outcome
- Provide minimal command list if verification wasn't performed

### 5. Avoid "Busywork Updates"

- Don't narrate every step
- Provide checkpoints when: scope changes, risks appear, verification fails, or decision needed

---

## Context Management

### 1. Read Before Write

- Locate authoritative source of truth before editing
- Prefer small, local reads over scanning entire repo
- **For structural changes**: Read `low-layer-architecture/` to understand platform design and repository relationships

### 2. Keep a Working Memory

- Maintain "Working Notes" in the active task plan (`tasks/<name>-plan.md`): constraints, invariants, decisions, pitfalls
- Compress and discard raw noise as context grows

### 3. Minimize Cognitive Load in Code

- Use explicit names and direct control flow
- Avoid clever meta-programming unless project already uses it
- Leave code easier to read than found

### 4. Control Scope Creep

- Fix only what's necessary for correctness/safety
- Log deeper issues as TODOs/issues, not expanding current task

---

## Error Handling and Recovery

### 1. "Stop-the-Line" Rule

When unexpected events occur (test failures, build errors, regressions):

- Stop adding features
- Preserve evidence
- Return to diagnosis and re-plan

### 2. Triage Checklist (In Order)

1. Reproduce reliably
2. Localize the failure (which layer)
3. Reduce to minimal failing case
4. Fix root cause, not symptoms
5. Guard with regression coverage
6. Verify end-to-end for original report

### 3. Safe Fallbacks (Under Time Pressure)

- Prefer "safe default + warning" over partial behavior
- Return actionable errors, not silent failures
- Avoid broad refactors as fixes

### 4. Rollback Strategy (High-Risk Changes)

- Keep changes reversible via feature flags, config gating, isolated commits
- Ship behind disabled-by-default flag if unsure about production impact

### 5. Instrumentation as a Tool

- Add logging/metrics only when they materially reduce debugging time or prevent recurrence
- Remove temporary debug output once resolved

---

## Engineering Best Practices

### 1. API / Interface Discipline

- Design around stable boundaries: functions, modules, components, route handlers
- Prefer optional parameters over duplicated code paths
- Keep error semantics consistent

### 2. Testing Strategy

> Full rules in [testing-standards.md](/.claude/standards/testing-standards.md) — pyramid, per-stack conventions, coverage.

- **Mandatory**: Every feature and bugfix ships with at least one test
- Prefer: unit tests for logic, integration tests for boundaries (DB/K8s/HTTP), E2E for critical user flows
- Avoid brittle tests tied to implementation details

### 3. Type Safety and Invariants

- Avoid suppressions unless project explicitly permits
- Encode invariants at boundaries, not scattered throughout

### 4. Dependency Discipline

- Add new dependencies only when existing stack cannot solve cleanly and benefit is clear
- Prefer standard library and existing utilities

### 5. Security and Privacy

- Never introduce secrets into code, logs, or output
- Treat user input as untrusted: validate, sanitize, constrain
- Prefer least privilege (DB access, server actions)

### 6. Performance (Pragmatic)

- Avoid premature optimization
- Fix: obvious N+1 patterns, unbounded loops, repeated heavy computation
- Measure when doubtful; don't guess

### 7. Accessibility and UX (UI Changes)

- Keyboard navigation, focus management, readable contrast, meaningful empty/error states
- Prefer clear copy and predictable interactions over fancy effects

---

## Git and Change Hygiene

- Keep commits atomic and describable; avoid "misc fixes" bundles
- Don't rewrite history unless explicitly requested
- Don't mix formatting-only changes with behavioral changes unless required
- Treat generated files carefully—only commit if project expects it

> **Note**: See `CLAUDE.md` for detailed Git workflow and branching strategy.

---

## Definition of Done (DoD)

A task is complete when:

- [ ] Behavior matches acceptance criteria
- [ ] Tests/lint/typecheck/build pass (or documented reason they weren't run)
- [ ] Risky changes have rollback/flag strategy
- [ ] Code follows conventions and is readable
- [ ] Short verification story exists: what changed + how we know it works

---

## Quick Reference

| Situation | Action |
|-----------|--------|
| Non-trivial task | Use Plan Mode, create plan in `.claude/tasks/<name>-plan.md` |
| Structural/architectural change | Consult `low-layer-architecture/` before proposing |
| After mistake/correction | Add entry to `.claude/rules/lessons.md` |
| New session | Review `.claude/rules/lessons.md` |
| Before major refactor | Review `.claude/rules/lessons.md` and `low-layer-architecture/` |
| Blocked | Ask ONE question with recommended default |
| Unexpected failure | Stop-the-line, preserve evidence, re-plan |
| Bug fix with TDD approach | Use `/rg` (Red test, Green fix, verify) |
| Task complete | Verify DoD checklist, update task plan in `tasks/` |
