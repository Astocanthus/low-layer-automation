# WORKFLOW.md

AI Agent workflow orchestration guidelines for LOW-LAYER projects.

This file complements `CLAUDE.md` with operational principles, task management, and quality assurance rules.

---

## Operating Principles (Non-Negotiable)

1. **Correctness over cleverness**: Prefer boring, readable solutions that are easy to maintain.
2. **Smallest change that works**: Minimize blast radius; avoid refactoring unrelated code unless it meaningfully reduces risk.
3. **Leverage existing patterns**: Follow project conventions before introducing new abstractions.
4. **Prove it works**: "Seems right" is not done—validate with tests, build, lint, or reliable manual reproduction.
5. **Be explicit about uncertainty**: Acknowledge what cannot be verified and propose safe next steps.

---

## Workflow Orchestration

### 1. Plan Mode Default

- Use for non-trivial tasks (3+ steps, multi-file changes, architectural decisions)
- **Consult `architecture/`** before proposing structural changes or new components
- Include verification steps in the plan
- Stop and update the plan if new information invalidates it
- Write crisp specs when requirements are ambiguous

### 2. Subagent Strategy

- Keep main context clean by parallelizing: repo exploration, pattern discovery, test triage, dependency research
- Assign one focused objective per subagent
- Merge outputs into short, actionable synthesis before coding

### 3. Incremental Delivery

- Prefer thin vertical slices over big-bang changes
- Implement → test → verify → expand
- Use feature flags, config switches, or safe defaults

### 4. Self-Improvement Loop

- After corrections or mistakes, add entries to `.CLAUDE/tasks/lessons.md`
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

File-based, auditable task tracking using `.CLAUDE/tasks/todo.md` and `.CLAUDE/tasks/lessons.md`.

### Rules

1. **Plan First**: Write checklist to `.CLAUDE/tasks/todo.md` for non-trivial work with explicit "Verify" tasks
2. **Define Success**: Add acceptance criteria
3. **Track Progress**: Mark items complete; maintain one in-progress item
4. **Checkpoint Notes**: Capture discoveries, decisions, and constraints in Working Notes section
5. **Document Results**: What changed, where, how verified
6. **Capture Lessons**: Update `.CLAUDE/tasks/lessons.md` after corrections or discoveries

### Task File Structure

```
.CLAUDE/tasks/
├── todo.md       # Current work items and working memory
└── lessons.md    # Failure modes and prevention rules
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
- **For structural changes**: Read `architecture/` to understand platform design and repository relationships

### 2. Keep a Working Memory

- Maintain "Working Notes" in `tasks/todo.md`: constraints, invariants, decisions, pitfalls
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

- Add smallest test that would catch the bug
- Prefer: unit tests for logic, integration tests for DB/network, E2E for critical flows
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
| Non-trivial task | Use Plan Mode, write to `.CLAUDE/tasks/todo.md` |
| Structural/architectural change | Consult `architecture/` before proposing |
| After mistake/correction | Add entry to `.CLAUDE/tasks/lessons.md` |
| New session | Review `.CLAUDE/tasks/lessons.md` |
| Before major refactor | Review `.CLAUDE/tasks/lessons.md` and `architecture/` |
| Blocked | Ask ONE question with recommended default |
| Unexpected failure | Stop-the-line, preserve evidence, re-plan |
| Task complete | Verify DoD checklist, update todo |
