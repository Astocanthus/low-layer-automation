---
description: Build and push Docker image to ghcr.io for the latest release
argument-hint: <project> - e.g., "low-layer-website", "low-layer-cdn"
allowed-tools: Bash, Read
---

# Docker Release Command

Build a Docker image for a project and push it to GitHub Container Registry (ghcr.io), then update the GitHub release with the image reference.

**You need to always ULTRA THINK.**

## Usage

```bash
/docker-release <project>
```

**Examples:**
```bash
/docker-release low-layer-website
```

## Workflow Context

This command runs AFTER `/release` completes:

```
1. /release low-layer-website          # Create release, tag, GitHub release
2. /docker-release low-layer-website   # ← THIS COMMAND (build & push image)
```

## Instructions

When the user invokes `/docker-release <project>`, execute the following steps:

### Step 0: Identify Project and Validate

**Project path resolution:**
- Input: `low-layer-website`
- Full path: `/mnt/e/Taff/low-layer/low-layer-website/`

**Validation:**
1. Check Dockerfile exists in project root
2. Check git remote is configured
3. Check at least one git tag exists

```bash
PROJECT_PATH="/mnt/e/Taff/low-layer/$ARGUMENTS"

# Validate Dockerfile
ls -la "$PROJECT_PATH/Dockerfile"

# Get git info
cd "$PROJECT_PATH"
git remote get-url origin
git describe --tags --abbrev=0
```

### Step 1: Extract Repository Info

Parse the GitHub remote URL to get owner and repo name:

```bash
cd "$PROJECT_PATH"

# Get remote URL and extract owner/repo
REMOTE_URL=$(git remote get-url origin)
echo "Remote: $REMOTE_URL"

# Get latest tag
VERSION=$(git describe --tags --abbrev=0)
echo "Version: $VERSION"

# Get commit SHA for labels
COMMIT_SHA=$(git rev-parse HEAD)
echo "Commit: $COMMIT_SHA"
```

**Expected output example:**
```
Remote: git@github.com:low-layer/low-layer-website.git
Version: v0.3.0
Commit: abc123...
```

### Step 2: Authenticate to ghcr.io

Use `gh` CLI to authenticate Docker:

```bash
# Check gh is authenticated
gh auth status

# Login Docker to ghcr.io using gh token
gh auth token | docker login ghcr.io -u $(gh api user -q .login) --password-stdin
```

### Step 3: Build Docker Image

Build the image with proper tags and OCI labels:

```bash
cd "$PROJECT_PATH"

# Extract values (remove 'v' prefix for Docker tag)
OWNER="low-layer"  # From Step 1
REPO="low-layer-website"  # From Step 1
VERSION_TAG="0.3.0"  # From Step 1, without 'v'
COMMIT_SHA="..."  # From Step 1

# Build with tags and labels
docker build \
  --label "org.opencontainers.image.source=https://github.com/${OWNER}/${REPO}" \
  --label "org.opencontainers.image.version=${VERSION_TAG}" \
  --label "org.opencontainers.image.revision=${COMMIT_SHA}" \
  --label "org.opencontainers.image.created=$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
  --tag "ghcr.io/${OWNER}/${REPO}:${VERSION_TAG}" \
  --tag "ghcr.io/${OWNER}/${REPO}:latest" \
  .
```

### Step 4: Push to ghcr.io

Push both the version tag and latest:

```bash
docker push "ghcr.io/${OWNER}/${REPO}:${VERSION_TAG}"
docker push "ghcr.io/${OWNER}/${REPO}:latest"
```

### Step 5: Update GitHub Release

Append Docker image info to the release notes:

```bash
# Get current release body
CURRENT_BODY=$(gh release view "v${VERSION_TAG}" --json body -q .body)

# Check if Docker info already present
if [[ ! "$CURRENT_BODY" =~ "Docker Image" ]]; then
  # Append Docker section
  gh release edit "v${VERSION_TAG}" --notes "${CURRENT_BODY}

---

### 📦 Docker Image

\`\`\`bash
docker pull ghcr.io/${OWNER}/${REPO}:${VERSION_TAG}
\`\`\`

Or use \`latest\`:
\`\`\`bash
docker pull ghcr.io/${OWNER}/${REPO}:latest
\`\`\`"
fi
```

### Step 6: Summary

Display final summary with useful links:

```
✅ Docker Release Complete!

   Image:   ghcr.io/low-layer/low-layer-website:0.3.0
   Release: https://github.com/low-layer/low-layer-website/releases/tag/v0.3.0
   Package: https://github.com/low-layer/low-layer-website/pkgs/container/low-layer-website
```

## Error Handling

| Error | Cause | Solution |
|-------|-------|----------|
| "No Dockerfile found" | Missing Dockerfile | Create Dockerfile in project root |
| "No git tags found" | No releases yet | Run `/release` first |
| "gh not authenticated" | gh CLI not logged in | Run `gh auth login` |
| "Docker build failed" | Build error | Check Dockerfile and dependencies |
| "Permission denied" | Package visibility | Set package to public on GitHub |

## Notes

- Images are pushed to `ghcr.io/low-layer/<project>:<version>`
- Both versioned tag and `latest` are pushed
- OCI labels enable GitHub to link package to repository
- Release notes are updated with pull command

User: $ARGUMENTS