#!/bin/bash
# =============================================================================
# CLAUDE CODE SECURITY GUARD - System Protection
# =============================================================================
# This hook protects your system against dangerous Claude Code actions
# It blocks: sudo, dangerous deletions, access outside project, sensitive files
# =============================================================================

set -euo pipefail

# Read JSON input from stdin
INPUT=$(cat)

# Extract hook information
TOOL_NAME=$(echo "$INPUT" | jq -r '.tool_name // empty')
HOOK_EVENT=$(echo "$INPUT" | jq -r '.hook_event_name // empty')
CWD=$(echo "$INPUT" | jq -r '.cwd // empty')

# Project path (authorized working directory)
# Prefer CLAUDE_PROJECT_DIR (project root) over CWD (which may be a subdirectory)
PROJECT_DIR="${CLAUDE_PROJECT_DIR:-$CWD}"

# =============================================================================
# CONFIGURATION - Dangerous paths and patterns
# =============================================================================

# Sensitive system directories (never access)
SENSITIVE_PATHS=(
    "/etc/passwd"
    "/etc/shadow"
    "/etc/sudoers"
    "~/.ssh"
    "~/.gnupg"
    "~/.aws"
    "~/.azure"
    "~/.config/gcloud"
    "~/.npmrc"
    "~/.pypirc"
    "~/.docker"
    "~/.kube"
    "/root"
    "C:/Windows/System32"
    "C:/Users/*/AppData"
    "*.pem"
    "*.key"
    "*id_rsa*"
    "*id_ed25519*"
    "*.pfx"
    "*.p12"
)

# Sensitive files to block
SENSITIVE_FILES=(
    ".env"
    ".env.*"
    "*.secrets"
    "*credentials*"
    "*password*"
    "*token*"
    "*apikey*"
    "*api_key*"
    "*secret*"
    "*.keystore"
    "config/secrets*"
)

# Dangerous bash commands
DANGEROUS_COMMANDS=(
    "sudo"
    "su "
    "runas"
    "chmod 777"
    "chmod -R 777"
    "rm -rf /"
    "rm -rf /*"
    "rm -rf ~"
    "rm -rf /home"
    "rm -rf /etc"
    "rm -rf /var"
    "rm -rf /usr"
    "rm -rf C:/"
    "rm -rf C:\\"
    "format "
    "mkfs"
    "dd if="
    "> /dev/sd"
    "shutdown"
    "reboot"
    "init 0"
    "init 6"
    "poweroff"
    "halt"
    ":(){:|:&};:"
    "wget.*|.*sh"
    "curl.*|.*sh"
    "wget.*|.*bash"
    "curl.*|.*bash"
    "nc -e"
    "netcat -e"
    "python.*-c.*import.*socket"
    "perl.*-e.*socket"
    "bash -i"
    "/dev/tcp/"
    "eval.*base64"
    "base64.*-d.*|.*sh"
    "base64.*-d.*|.*bash"
    "history -c"
    "shred"
    "wipe"
    "srm"
    "rm -rf .git"
    "git push --force"
    "git reset --hard origin"
    "DROP DATABASE"
    "DROP TABLE"
    "TRUNCATE"
    "DELETE FROM .* WHERE 1"
    "--no-preserve-root"
)

# =============================================================================
# VERIFICATION FUNCTIONS
# =============================================================================

# Function to normalize paths (Windows/Unix)
normalize_path() {
    local path="$1"
    # Convert backslashes to forward slashes
    path="${path//\\//}"
    # Remove double slashes
    path=$(echo "$path" | sed 's|//|/|g')
    # Resolve home path
    path="${path/#\~/$HOME}"
    echo "$path"
}

# Check if a path is within the project
is_within_project() {
    local path="$1"
    local norm_path=$(normalize_path "$path")
    local norm_project=$(normalize_path "$PROJECT_DIR")

    # Check if the path starts with the project directory
    if [[ "$norm_path" == "$norm_project"* ]]; then
        return 0  # Within project
    fi
    return 1  # Outside project
}

# Check if a path is within ~/.claude/ (read-only access for skills, config)
is_within_claude_home() {
    local path="$1"
    local norm_path=$(normalize_path "$path")
    local norm_claude_home=$(normalize_path "$HOME/.claude")

    if [[ "$norm_path" == "$norm_claude_home"* ]]; then
        return 0
    fi
    return 1
}

# Check if a path is sensitive
is_sensitive_path() {
    local path="$1"
    local norm_path=$(normalize_path "$path")

    for pattern in "${SENSITIVE_PATHS[@]}"; do
        # Expand the pattern
        local expanded=$(normalize_path "$pattern")
        if [[ "$norm_path" == *"$expanded"* ]] || [[ "$norm_path" =~ $pattern ]]; then
            return 0  # Sensitive path
        fi
    done
    return 1  # Path OK
}

# Check if a file is sensitive
is_sensitive_file() {
    local path="$1"
    local filename=$(basename "$path")
    local extension="${filename##*.}"

    # CSS files are never sensitive (e.g. tokens.css is design tokens, not secrets)
    if [[ "$extension" == "css" ]]; then
        return 1  # File OK
    fi

    for pattern in "${SENSITIVE_FILES[@]}"; do
        if [[ "$filename" == $pattern ]] || [[ "$path" == *"$pattern"* ]]; then
            return 0  # Sensitive file
        fi
    done
    return 1  # File OK
}

# Check if a command is dangerous
is_dangerous_command() {
    local cmd="$1"
    local cmd_lower=$(echo "$cmd" | tr '[:upper:]' '[:lower:]')

    for pattern in "${DANGEROUS_COMMANDS[@]}"; do
        local pattern_lower=$(echo "$pattern" | tr '[:upper:]' '[:lower:]')
        if [[ "$cmd_lower" == *"$pattern_lower"* ]]; then
            return 0  # Dangerous command
        fi
    done
    return 1  # Command OK
}

# Check for dangerous rm commands
check_rm_command() {
    local cmd="$1"

    # Check rm with absolute paths outside the project
    if [[ "$cmd" =~ rm[[:space:]].*(-rf|-r|-f) ]]; then
        # Extract paths from the rm command
        local paths=$(echo "$cmd" | grep -oE '(/[^[:space:]]+|[A-Za-z]:[^[:space:]]+)' || true)
        for path in $paths; do
            if ! is_within_project "$path"; then
                return 0  # Dangerous rm outside project
            fi
        done
    fi
    return 1  # rm OK
}

# =============================================================================
# MAIN VERIFICATION LOGIC
# =============================================================================

block_action() {
    local reason="$1"
    echo "{\"decision\":\"block\",\"reason\":\"🛡️ SECURITY: $reason\"}"
    exit 0
}

allow_action() {
    exit 0
}

# Verification for Bash commands
check_bash_tool() {
    local command=$(echo "$INPUT" | jq -r '.tool_input.command // empty')

    if [ -z "$command" ]; then
        allow_action
    fi

    # Check for dangerous commands
    if is_dangerous_command "$command"; then
        block_action "Dangerous command detected. Privileged system commands (sudo, rm -rf /, format, etc.) are forbidden."
    fi

    # Check for rm commands outside project
    if check_rm_command "$command"; then
        block_action "Deletion outside project forbidden. You can only delete files within: $PROJECT_DIR"
    fi

    # Check for access to sensitive paths in the command
    for pattern in "${SENSITIVE_PATHS[@]}"; do
        if [[ "$command" == *"$pattern"* ]]; then
            block_action "Access to sensitive system path forbidden: $pattern"
        fi
    done

    allow_action
}

# Verification for Read/Write/Edit
check_file_tool() {
    local file_path=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

    if [ -z "$file_path" ]; then
        allow_action
    fi

    # Check if the file is outside the project
    if ! is_within_project "$file_path"; then
        # Allow read-only access to ~/.claude/ (global skills, config)
        if [ "$TOOL_NAME" = "Read" ] && is_within_claude_home "$file_path"; then
            allow_action
        fi
        block_action "Access forbidden outside project. You can only access files within: $PROJECT_DIR"
    fi

    # Check for sensitive paths
    if is_sensitive_path "$file_path"; then
        block_action "Access to sensitive system path forbidden."
    fi

    # Check for sensitive files (except read for certain cases)
    if [ "$TOOL_NAME" != "Read" ] && is_sensitive_file "$file_path"; then
        block_action "Modification of sensitive files (.env, credentials, secrets, etc.) forbidden."
    fi

    allow_action
}

# Verification for Glob
check_glob_tool() {
    local path=$(echo "$INPUT" | jq -r '.tool_input.path // empty')
    local pattern=$(echo "$INPUT" | jq -r '.tool_input.pattern // empty')

    # If a path is specified, check it's within the project or ~/.claude/ (skills)
    if [ -n "$path" ] && ! is_within_project "$path" && ! is_within_claude_home "$path"; then
        block_action "File search outside project forbidden. You can only search within: $PROJECT_DIR"
    fi

    # Check for sensitive patterns
    for sensitive_pattern in "${SENSITIVE_FILES[@]}"; do
        if [[ "$pattern" == *"$sensitive_pattern"* ]]; then
            block_action "Search for sensitive files forbidden."
        fi
    done

    allow_action
}

# Verification for Grep
check_grep_tool() {
    local path=$(echo "$INPUT" | jq -r '.tool_input.path // empty')
    local pattern=$(echo "$INPUT" | jq -r '.tool_input.pattern // empty')

    # If a path is specified, check it's within the project
    if [ -n "$path" ] && ! is_within_project "$path"; then
        block_action "Search in files outside project forbidden."
    fi

    # Block search for secrets
    local sensitive_patterns=("password" "api_key" "apikey" "secret" "token" "credential" "private_key")
    local pattern_lower=$(echo "$pattern" | tr '[:upper:]' '[:lower:]')

    for sensitive in "${sensitive_patterns[@]}"; do
        if [[ "$pattern_lower" == *"$sensitive"* ]]; then
            block_action "Search for sensitive patterns (passwords, API keys, secrets) forbidden."
        fi
    done

    allow_action
}

# =============================================================================
# DISPATCH BASED ON TOOL
# =============================================================================

case "$TOOL_NAME" in
    "Bash")
        check_bash_tool
        ;;
    "Read"|"Write"|"Edit")
        check_file_tool
        ;;
    "Glob")
        check_glob_tool
        ;;
    "Grep")
        check_grep_tool
        ;;
    *)
        # For other tools, allow by default
        allow_action
        ;;
esac
