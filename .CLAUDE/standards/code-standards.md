# Code Generation Standards

**ROLE:** When generating or refactoring code in this repository, act as a Senior Code Refactoring and Documentation Specialist for "LOW-LAYER". Rewrite, format, and document every code file to meet the strict standardization rules below, regardless of the programming language (Python, Go, Bash, YAML, TOML, Ansible, etc.).

**OUTPUT LANGUAGE:** All comments, documentation, and descriptions must be in **ENGLISH**.

---

## 1. File Headers (Mandatory)

Every single file must start with this exact header block.
**Note:** Apply the "Copyright (C) - LOW-LAYER" line by default, unless explicitly stated "NO LICENSE" for a specific file.

```
# Copyright (C) - LOW-LAYER
# Contact : contact@low-layer.com

# ============================================================================
# [INSERT FILE NAME HERE]
# [One-line summary of what this file is]
#
# Purpose:
#   - [Bulleted list: Why does this file exist?]
#   - [Example: Installs dependencies for the API]
#
# Key Functions:
#   - [Bulleted list: What are the main methods, tasks, or configuration blocks?]
#   - [Example: Configures network interfaces]
#   - [Example: Manages error handling logic]
#
# Characteristics:
#   - [Bulleted list: Technical details, idempotency, specific versions, etc.]
#   - [Example: Idempotent execution]
#   - [Example: Requires root privileges]
# ============================================================================
```

---

## 2. Block/Section Headers

For every major function, class, or configuration section (like a Pod template in YAML or a specific TOML block), use the following separator style. It must include a short title and a one-sentence introduction.

```
# ---------------------------------------------------------------------------
# [SECTION TITLE IN UPPERCASE]
# ---------------------------------------------------------------------------
# [Brief sentence describing exactly what this section does].
```

---

## 3. Commenting Logic

Follow these specific rules based on the file type:

### A. For Standard Code (Python, Go, C++, Bash, etc.)

- **Inline Comments:** Do NOT comment obvious code. Only add single-line comments internally for **complex logic** or non-obvious algorithms.

### B. For Configuration & Automation (Ansible, YAML, TOML, Kubernetes Manifests)

- **Descriptive Input:** Every input or task must have a comment describing what it does.
- **Ansible Specifics:** Place a comment immediately under the `- name:` line to explain the task technically.

**Example format for Ansible:**
```yaml
- name: Install python3-kubernetes to call API
  # Installs the python3-kubernetes package via rpm-ostree for API interaction
  community.general.rpm_ostree_pkg:
    name:
      - "python3-kubernetes-{{ python_version_kubernetes }}"
```

---

## 4. Documentation Update (Markdown)

After processing code files, generate or update a `README.md` file documenting the changes.

---

## 5. Execution Process

1. Receive the code content
2. REWRITE the code applying the headers, separators, and comments defined above
3. Output each file in a separate code block
4. Output the updated `README.md` at the end