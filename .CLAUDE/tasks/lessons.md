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

### Example: Missing Input Validation

**Date**: 2024-01-15

**Failure Mode**: API endpoint accepted malformed JSON without validation, causing downstream errors

**Detection Signal**: Integration test failure with cryptic error message

**Prevention Rule**: Always validate input at API boundaries using schema validation (Zod, Joi, etc.) before processing

**Context**: Related to user registration endpoint

---
