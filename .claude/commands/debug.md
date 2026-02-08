---
description: Systematic bug debugging with deep analysis and resolution
argument-hint: <log|error|problem-description>
allowed-tools: Bash, Read, Edit, Write, Grep, Glob, Task, WebSearch, WebFetch
---

# Debug Command

Systematic debugging specialist workflow to identify, understand, and resolve bugs through ultra-deep analysis.

**You need to always ULTRA THINK.**

## Usage

```bash
/debug <log|error|problem-description>
```

**Examples:**
```bash
/debug "TypeError: Cannot read property 'id' of undefined"
/debug @logs/error.log
/debug "API returns 500 on user creation"
```

## Workflow Context

This command is used for systematic bug resolution:

```
1. /debug <error>              # ← THIS COMMAND (analyze and fix)
2. [verify fix]                # Test the solution
3. /changelog <project>        # Document the fix
4. /push <project>             # Commit the fix
```

## Instructions

When the user invokes `/debug <error>`, execute the following steps:

### Step 0: Parse Input

Identify the type of input:
- Error message string
- Log file path (@logs/...)
- Problem description

### Step 0.5: Auto-Detect Skills

After parsing input, detect and load relevant skills:
1. Use `Bash` to list `~/.claude/skills/*/SKILL.md` (Glob does not follow symlinks)
2. Read frontmatters to extract `name`, `description`, `triggers`
3. Match `triggers` against the error/log content, file paths, and technology keywords
4. Load matched skills (read full content) — their rules guide the **entire debug session**
5. Display to user: "Skills loaded: `skill-a`, `skill-b`" (or "No skills detected")
6. If no skills are installed, skip silently

> Loaded skills MUST be injected into **every subagent prompt** during all subsequent steps (Explore, Research, Implement). See WORKFLOW.md § Context Injection.

### Step 1: Analyze

Deep log/error analysis:
- Parse the provided log/error message carefully
- Extract key error patterns, stack traces, and symptoms
- Identify error types: runtime, compile-time, logic, performance
- **CRITICAL**: Document exact error context and reproduction steps

### Step 2: Explore

Targeted codebase investigation:
- Launch **parallel subagents** to search for error-related code
- Search for similar error patterns in codebase using Grep
- Find all files related to the failing component/module
- Examine recent changes that might have introduced the bug
- **ULTRA THINK**: Connect error symptoms to potential root causes

### Step 3: Ultra-Think

Deep root cause analysis:
- **THINK DEEPLY** about the error chain: symptoms → immediate cause → root cause
- Consider all possible causes:
  - Code logic errors
  - Configuration issues
  - Environment problems
  - Race conditions
  - Memory issues
  - Network problems
- **CRITICAL**: Map the complete failure path from root cause to visible symptom
- Validate hypotheses against the evidence

### Step 4: Research

Solution investigation:
- Launch **parallel subagents** for web research
- Search for similar issues and solutions online
- Check documentation for affected libraries/frameworks
- Look for known bugs, workarounds, and best practices
- **THINK**: Evaluate solution approaches for this specific context

### Step 5: Implement

Systematic resolution:
- Choose the most appropriate solution based on analysis
- Follow existing codebase patterns and conventions
- Implement minimal, targeted fixes
- **STAY IN SCOPE**: Fix only what's needed for this specific bug
- Add defensive programming where appropriate

### Step 6: Verify

Comprehensive testing:
- Test the specific scenario that was failing
- Run related tests to ensure no regressions
- Check edge cases around the fix
- **CRITICAL**: Verify the original error is completely resolved

## Deep Analysis Techniques

### Log Analysis

- Extract timestamps, error codes, stack traces
- Identify error propagation patterns
- Look for correlation with system events

### Code Investigation

- Trace execution path to error location
- Check variable states and data flow
- Examine error handling patterns
- Review recent commits affecting the area

### Root Cause Mapping

- **WHY technique**: Ask "why" 5 times minimum
- Consider environmental factors
- Check for timing/concurrency issues
- Validate assumptions about data/state

## Error Handling

| Symptom | Investigation | Common Causes |
|---------|---------------|---------------|
| TypeError | Check null/undefined values | Missing data, async timing |
| 500 Error | Check server logs | Unhandled exception, DB error |
| Timeout | Check network/async code | Slow query, infinite loop |
| Memory | Check object references | Leaks, large allocations |

## Notes

- **ULTRA THINK** at each phase transition
- Use parallel agents for comprehensive investigation
- Document findings and reasoning at each step
- **NEVER guess** - validate all hypotheses with evidence
- **MINIMAL CHANGES**: Fix root cause, not symptoms
- Priority: Understanding > Speed > Completeness

User: $ARGUMENTS
