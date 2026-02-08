# README Standards

All `README.md` files in LOW-LAYER projects MUST follow this standardized structure. Adapt sections based on project type (library, service, tool, infrastructure).

---

## Required Structure

### 1. Header Section (Mandatory)

```markdown
# Project Name

[![Tech1](https://img.shields.io/badge/Tech1-Version-COLOR?style=for-the-badge&logo=LOGO&logoColor=white)](URL)
[![Tech2](https://img.shields.io/badge/Tech2-Version-COLOR?style=for-the-badge&logo=LOGO&logoColor=white)](URL)

[LICENSE_BADGE]
[![Release](https://img.shields.io/github/v/release/[GITHUB_REPO])](https://github.com/[GITHUB_REPO]/releases/latest)
[![Issues](https://img.shields.io/github/issues/[GITHUB_REPO])](https://github.com/[GITHUB_REPO]/issues)
[![Tests](https://img.shields.io/badge/Tests-XX%20passed-success)](./tests/)
[![Coverage](https://img.shields.io/badge/Coverage-XX%25-green)](./tests/)

[One-line description of what this project does and its main value proposition.]

[Optional: 1-2 sentences explaining the unique approach or differentiator.]

---
```

> **License Badge**: Replace `[LICENSE_BADGE]` with the appropriate badge based on the license chosen from `.claude/licenses/`. See license files for badge format.

> **GitHub Repo**: Replace `[GITHUB_REPO]` with the repository path (e.g., `Astocanthus/my-project`). This is used for Release and Issues badges.

> **Release Badge**: Optional - only include for projects with published releases/artifacts. Remove for configuration-only repositories.

**Badge Categories:**
- **Technology Stack**: Node.js, Python, Go, Docker, Kubernetes, etc.
- **Status**: License, Tests, Coverage, Build Status
- **Links**: GitHub Issues, Documentation

---

### 2. Features Section

```markdown
## Features

- **Feature Name**: Brief description of what it does.
- **Feature Name**: Brief description of what it does.
- **Feature Name**: Brief description of what it does.

---
```

---

### 3. Project Structure (For codebases)

```markdown
## Project Structure

\`\`\`
project-name/
├── Dockerfile                  # Description
├── package.json
├── src/
│   ├── main.js                 # Entry point
│   ├── lib/
│   │   ├── module1.js          # Description
│   │   └── module2.js          # Description
│   └── routes/
│       └── api.js              # Description
├── tests/
│   └── unit/
│       └── module.test.js      # Description
└── docs/
    └── API.md                  # API documentation
\`\`\`

---
```

---

### 4. Architecture Section (For services/applications)

Use Mermaid diagrams to illustrate flows:

```markdown
## Architecture

### [Flow Name]

\`\`\`mermaid
sequenceDiagram
    participant User
    participant Service
    participant Database

    User->>Service: Request
    Service->>Database: Query
    Database-->>Service: Response
    Service-->>User: Result
\`\`\`

---
```

---

### 5. Quick Start Section

```markdown
## Quick Start

### Prerequisites

- **Dependency 1**: Version X.X+ with specific requirement.
- **Dependency 2**: Brief description of why it's needed.

### Installation

\`\`\`bash
# Clone the repository
git clone https://github.com/org/project.git
cd project

# Install dependencies
npm install  # or pip install -r requirements.txt

# Run
npm start
\`\`\`

### Docker Compose (If applicable)

\`\`\`yaml
version: '3.8'

services:
  service-name:
    image: image:tag
    environment:
      - VAR=value
    ports:
      - "3000:3000"
\`\`\`

---
```

---

### 6. Configuration Section

```markdown
## Configuration

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `VAR_NAME` | What it configures | Yes/No | value |
| `VAR_NAME` | What it configures | Yes/No | — |

### [Subsection if needed: Logging, Security, etc.]

| Option | Description | Values |
|--------|-------------|--------|
| `option` | What it does | value1, value2 |

---
```

---

### 7. API/Endpoints Section (For services)

```markdown
## API Endpoints

### [Route Group Name] (`/path/`)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/path/action` | GET | What it does |
| `/path/action` | POST | What it does |

---
```

---

### 8. Health Check Section (For containerized services)

```markdown
## Health Check Endpoints

| Endpoint | Type | Status Codes | Description |
|----------|------|--------------|-------------|
| `/health` | Liveness | 200 | Process is running |
| `/ready` | Readiness | 200 / 503 | Dependencies healthy |

### Kubernetes Probe Configuration

\`\`\`yaml
livenessProbe:
  httpGet:
    path: /health
    port: 3000
  initialDelaySeconds: 5
  periodSeconds: 10
\`\`\`

---
```

---

### 9. Development Section

```markdown
## Development

### Local Setup

\`\`\`bash
# Development mode
npm run dev
\`\`\`

### Running Tests

\`\`\`bash
npm test              # Run all tests
npm run test:watch    # Watch mode
npm run test:coverage # Coverage report
\`\`\`

### Test Coverage (If applicable)

| Module | Statements | Branches | Functions |
|--------|------------|----------|-----------|
| `module.js` | XX% | XX% | XX% |
| **Total** | **XX%** | **XX%** | **XX%** |

---
```

---

### 10. Troubleshooting Section

```markdown
## Troubleshooting

### "Error Message Here"

**Cause**: Explanation of why this happens.

**Solution**: Steps to resolve.

### Issue Description

Check specific configuration:
\`\`\`bash
command to diagnose
\`\`\`

---
```

---

### 11. Footer Sections (Mandatory)

```markdown
## License

[LICENSE_TEXT]

---

## Author

**Author Name** - Role/Title

- GitHub: [@username](https://github.com/username)
- LinkedIn: [Name](https://linkedin.com/in/profile)

---

## Acknowledgments

- Built for [Organization/Project](URL)
- Powered by [Technology](URL)
```

---

## Section Selection Guide

| Project Type | Required Sections |
|--------------|-------------------|
| **Library/Package** | Header, Features, Quick Start, API, Development, License, Author |
| **Service/API** | Header, Features, Architecture, Quick Start, Config, API, Health, Troubleshooting, License, Author |
| **CLI Tool** | Header, Features, Quick Start, Config (flags), Examples, License, Author |
| **Infrastructure** | Header, Features, Architecture, Quick Start, Config, Troubleshooting, License, Author |
| **Ansible Role** | Header, Features, Variables Table, Dependencies, Example Playbook, License, Author |

---

## Badge Color Reference

| Technology | Color Code | Logo Name |
|------------|------------|-----------|
| Node.js | 339933 | nodedotjs |
| Python | 3776AB | python |
| Go | 00ADD8 | go |
| Docker | 2496ED | docker |
| Kubernetes | 326CE5 | kubernetes |
| Ansible | EE0000 | ansible |
| PostgreSQL | 4169E1 | postgresql |
| Redis | DC382D | redis |
| Keycloak | 4D4D4D | keycloak |
| Ghost | 738A94 | ghost |
