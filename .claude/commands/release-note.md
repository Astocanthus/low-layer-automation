---
description: Generate a release note document from CHANGELOG.md for GitHub releases
argument-hint: <project> [version] - e.g., "low-layer-website", "low-layer-website 1.2.0"
allowed-tools: Read, Write, Grep, Glob
---

# Release Note Generator

Generate a professional release note document from a project's CHANGELOG.md file.

**You need to always ULTRA THINK.**

## Usage

```bash
/release-note <project> [version]
```

**Examples:**
```bash
/release-note low-layer-website           # Latest version
/release-note low-layer-website 1.2.0     # Specific version
```

## Instructions

When the user invokes this command, follow these steps:

### Step 0: Identify the Project

**If no project specified:**
1. List available projects in the workspace:
   ```bash
   # Find all directories containing a .git folder
   find /mnt/e/Taff/low-layer -maxdepth 2 -type d -name ".git" -exec dirname {} \;
   ```
2. Present the list to the user and ask which project to use

**If project specified:**
1. Validate the project directory exists: `/mnt/e/Taff/low-layer/<project>/`
2. Validate it contains a `CHANGELOG.md`
3. Set working context to that project

**Project path resolution:**
- Input: `low-layer-website`
- Full path: `/mnt/e/Taff/low-layer/low-layer-website/`
- CHANGELOG: `/mnt/e/Taff/low-layer/low-layer-website/CHANGELOG.md`

### Step 1: Locate the CHANGELOG

Search for `CHANGELOG.md` in the project directory:
```bash
cat /mnt/e/Taff/low-layer/<project>/CHANGELOG.md
```

If not found, ask the user for the path.

### Step 2: Identify the Version

- If the user specified a version (e.g., `/release-note low-layer-website 1.2.0`), use that version
- If no version specified, use the **most recent released version** (not `[Unreleased]`)

### Step 3: Extract Information from CHANGELOG

Parse the CHANGELOG entry for the target version and extract:
- **Version number** and **release date**
- **Added** → New Features
- **Changed** → Breaking Changes (if applicable)
- **Fixed** → Bug Fixes
- **Removed** → Removed Features
- **Security** → Security Updates
- **Developer Experience** → Dev Tooling

### Step 4: Generate the Release Note

Create a markdown document following this exact structure:

```markdown
**Release Date:** [YYYY-MM-DD from changelog]
**Version:** [X.Y.Z]
**Status:** Stable Release

---

## 🎉 Highlights

[Write 2-3 sentences summarizing the main achievements of this release. Focus on the most impactful features or changes. Make it exciting but professional.]

---

## ✨ New Features

[For each item in "Added" section, create a subsection with:]

### [Feature Name]

[Description of the feature with context about what it does and why it matters.]

[Include tables, code examples, or configuration snippets where relevant.]

[Repeat for each major feature]

---

## 🔄 Breaking Changes

[If there are breaking changes from "Changed" section, document them here with migration guides.]

[If no breaking changes, write: "None in this release."]

---

## 📦 Installation

### Docker

```bash
docker pull [image:version]
```

### Upgrade from vX.Y.Z

[List upgrade steps if applicable]

[If this is initial release: "This is the initial release."]

---

## 📁 New Files

```
project-name/
├── [List new files and directories added in this release]
│   └── [With brief descriptions as comments]
```

[Extract file paths from the changelog entries]

---

## 🐛 Bug Fixes

[List items from "Fixed" section]

[If no bug fixes: "None in this release."]

---

## 📚 Documentation

[List documentation changes]

[If none explicitly mentioned: "- Updated README with new features"]

---

## 🙏 Contributors

[If contributors are known, list them. Otherwise use:]

- [Maintainer Name] ([@GitHubUsername](https://github.com/Username))

---

## 📋 Full Changelog

See [CHANGELOG.md](./CHANGELOG.md) for complete version history.

[Unreleased]: [link to compare]
[X.Y.Z]: [link to release]
```

### Step 5: Formatting Rules

- **Tables**: Use tables for endpoints, configuration options, environment variables
- **Code blocks**: Include practical examples (Docker, YAML, Bash, etc.)
- **File trees**: Use ASCII tree structure for new files section
- **Emojis**: Use the specific emojis defined in the structure above
- **Links**: Include links to relevant documentation or files

### Step 6: Output

1. Display the generated release note in a code block
2. Ask the user if they want to save it to a file:
   - Suggested path: `/mnt/e/Taff/low-layer/<project>/RELEASE-NOTE-vX.Y.Z.md`

## Quality Checklist

Before outputting, verify:
- [ ] Project path is correct
- [ ] Version and date are correct
- [ ] All "Added" items are covered in New Features
- [ ] Breaking changes are clearly documented with migration steps
- [ ] Code examples are syntactically correct
- [ ] File paths in New Files section are accurate
- [ ] Tone is professional but engaging

## Tone Guidelines

- **Highlights**: Exciting, summarizes impact
- **Features**: Technical but accessible, include practical examples
- **Breaking Changes**: Clear warnings, helpful migration paths
- **Installation**: Direct, step-by-step instructions

User: $ARGUMENTS
