# Lessons Learned

This file captures failure modes, detection signals, and prevention rules discovered during development.

**Purpose**: Review this file at session start and before major refactors to avoid repeating mistakes.

---

## Entry Format

Each lesson should include:

1. **Failure Mode**: What went wrong
2. **Detection Signal**: How was it discovered
3. **Prevention Rule**: How to avoid it in the future

---

## Lessons

### Template Entry

**Date**: YYYY-MM-DD

**Failure Mode**: _Description of what went wrong_

**Detection Signal**: _How the problem was discovered (test failure, user report, code review, etc.)_

**Prevention Rule**: _Concrete rule or check to prevent recurrence_

**Context**: _Optional: link to commit, PR, or issue_

---

<!-- Add new lessons below this line -->

### All Commands Must Follow CLAUDE.md References

**Date**: 2026-02-07

**Failure Mode**: Commands (`/epct`, `/push`, `/changelog`, etc.) were executed without reading and applying the files referenced in `CLAUDE.md`. Specifically:
- `WORKFLOW.md` — subagent strategy, plan mode, verification, incremental delivery
- `.claude/standards/code-standards.md` — file headers, section headers, commenting rules
- `.claude/standards/git-workflow.md` — branching, naming conventions
- `.claude/standards/changelog-standards.md` — changelog format, entry rules
- `.claude/standards/readme-standards.md` — README template, badges
- `low-layer-architecture/` — platform design, repository structure

This resulted in: no parallel subagents during `/epct`, skipped standards during code generation, inconsistent git workflow, missing verification steps.

**Detection Signal**: User noticed degraded workflow quality compared to previous model version (Opus 4.5) — subagents not used, standards not applied, workflow steps skipped.

**Prevention Rule**:
1. **At session start**: Read `CLAUDE.md` → follow all `>` Important blocks and linked files
2. **Before any command execution**: Read the command spec (`.claude/commands/<cmd>.md`) AND the relevant standards it touches
3. **Mapping of commands to required reads**:
   - `/epct` → `WORKFLOW.md` (subagents, plan mode), `code-standards.md`, `low-layer-architecture/`
   - `/push` → `git-workflow.md`, `code-standards.md`
   - `/changelog` → `changelog-standards.md`
   - `/web-design` → `code-standards.md`, `readme-standards.md`
   - `/debug` → `WORKFLOW.md` (error handling, triage checklist)
   - `/arch-update` → `low-layer-architecture/`
   - `/release`, `/release-note` → `changelog-standards.md`, `git-workflow.md`
4. **Non-negotiable**: If `WORKFLOW.md` says "use subagents" → use `Task` tool. If standards say "file headers" → add them. No shortcuts.
5. **Verify**: Before marking any task done, check DoD from `WORKFLOW.md`

**Context**: User feedback — workflow regression from Opus 4.5 to 4.6

---

### Subagent Discipline — ALL Phases, Not Just Explore

**Date**: 2026-02-07

**Failure Mode**: During `/epct`, subagents were launched correctly for the Explore phase (3 parallel Explore agents), but then:
- **Main context read files directly** (`editor.service.ts`, `graph-editor.component.ts`, `rete-editor.utils.ts`) instead of delegating to subagents — polluted main context with ~1500 lines of raw code
- **No subagent for Test phase** — EPCT says "Use parallel subagents to run tests" but build was run directly in main context

WORKFLOW.md is explicit: *"Main context must **not** do the exploration itself — delegate it"*

**Detection Signal**: User called out the violation directly.

**Prevention Rule**:
1. **Explore phase**: Subagent(s) for ALL codebase reads — never `Read` files in main context during exploration
2. **Plan phase**: If uncertain, launch Plan subagent with exploration context
3. **Code phase**: Use subagents for all file reads needed before writing code. Only the actual `Edit`/`Write` calls happen in main context
4. **Test phase**: Always use subagent(s) to run tests/build — isolate noisy output
5. **Rule of thumb**: If it produces output longer than ~50 lines, it belongs in a subagent
6. **After Explore subagents return**: Synthesize their results in main context, do NOT re-read the same files yourself
7. **Transparency**: When launching subagent(s), always tell the user explicitly:
   - That a subagent is being launched and its purpose (e.g., "Launching Explore subagent to search graph editor services")
   - When it finishes, show the **agent ID** (e.g., `agentId: abc1234`) so the user can track progress

**Context**: `/epct` graph save triggers task — Feb 2026

---

### Subagents Required After Plan Approval (Code + Test Phases)

**Date**: 2026-02-08

**Failure Mode**: After plan approval, the agent switched to doing everything in main context:
- Read files directly instead of delegating to subagents
- Ran builds/tests directly in main context
- No subagents launched at all after the user validated the plan

This contradicts WORKFLOW.md: subagents are required at **every phase**, not just Explore. The plan validation boundary is NOT a permission to stop using subagents.

**Detection Signal**: User observed that subagents were used correctly during exploration/planning, but completely dropped once the plan was approved and implementation started.

**Prevention Rule**:
1. **Plan approval does NOT change subagent discipline** — the same rules apply before and after
2. **Code phase workflow**:
   - Launch subagent(s) that read the files AND write the code (`Read` + `Edit`/`Write` all inside the subagent)
   - Main context only orchestrates: describes what to change, dispatches subagents, synthesizes results
   - One subagent per implementation slice (a slice = a coherent set of changes to 1-3 related files)
3. **Test phase**: Always subagent for `ng build`, `npm test`, `nx test`, etc.
4. **Main context golden rule**: The main context must NEVER use `Read`, `Edit`, `Write`, or `Bash` directly. Everything goes through subagents. Main context only: orchestrates, synthesizes, communicates with user.
5. **Exception**: Reading small config files (<30 lines) is acceptable in main context when needed for a quick routing decision

**Context**: User feedback — Feb 2026, plan mode implementation phase

---
