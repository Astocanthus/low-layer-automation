# Task Templates

Reusable templates for structuring task plans in `.claude/tasks/`.

> **Usage**: Copy the relevant template into a new `.claude/tasks/<name>-plan.md` file when starting work.

---

## Plan Template

```markdown
### [Feature/Task Name]

**Goal**: [Restate the objective]

**Acceptance Criteria**:
- [ ] Criterion 1
- [ ] Criterion 2

**Steps**:
1. [ ] Locate existing implementation/patterns
2. [ ] Design: minimal approach + key decisions
3. [ ] Implement smallest safe slice
4. [ ] Write/update tests (see testing-standards.md)
5. [ ] Run verification (tests, lint, build)
6. [ ] Summarize changes + verification story
7. [ ] Record lessons (if any)

**Tests**:
- [ ] Unit tests: _[list affected units]_
- [ ] Integration tests: _[list boundary contracts if applicable]_
- [ ] E2E tests: _[list critical flows if applicable]_

**DoD** (all checked before marking complete):
- [ ] Behavior matches acceptance criteria
- [ ] Tests pass (unit + integration + E2E as applicable)
- [ ] Lint/typecheck/build pass
- [ ] Risky changes have rollback/flag strategy
- [ ] Code follows project conventions
- [ ] Verification story filled in below

**Verification Story**:
- What changed: _TBD_
- How we know it works: _TBD_
```

---

## Bugfix Template

```markdown
### [Bug Description]

**Repro Steps**:
1. Step 1
2. Step 2

**Expected**: _What should happen_

**Actual**: _What happens instead_

**Root Cause**: _TBD_

**Fix**: _TBD_

**Tests**:
- [ ] Regression test: _[test that reproduces the bug before fix]_
- [ ] Related tests updated: _[any existing tests affected by the fix]_

**DoD**:
- [ ] Bug no longer reproduces
- [ ] Regression test added and passes
- [ ] Existing tests still pass
- [ ] Lint/typecheck/build pass
- [ ] No unintended side effects

**Verification**: _How verified?_

**Risk/Rollback Notes**: _TBD_
```
