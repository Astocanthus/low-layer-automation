# Testing Standards

**Context**: Rules for writing and maintaining tests across all LOW-LAYER projects. Language-agnostic core, with per-stack conventions below.

---

## When Tests Are Required

| Trigger | Test required? | Type |
|---------|---------------|------|
| New feature / user-facing behavior | **MANDATORY** | Unit + Integration or E2E |
| Bug fix | **MANDATORY** | Regression test covering the fix |
| Refactor (no behavior change) | Recommended | Existing tests must still pass |
| Config / infra change | Case-by-case | Smoke test or build verification |
| Documentation only | No | — |

> **Rule**: No feature or bugfix merges without at least one test proving it works.

---

## Test Pyramid

### Unit Tests (TU)

- **What**: Pure logic, transformations, utilities, models, validators
- **When**: Always — this is the default test level
- **Properties**: Fast (<100ms), no I/O, no network, deterministic
- **Isolation**: Mock/stub external dependencies
- **Guideline**: Test behavior through public API, not implementation details

### Integration Tests (TI)

- **What**: Component + service interactions, API endpoints, DB queries, CRD reconciliation
- **When**: Whenever units cross boundaries (HTTP, DB, message bus, Kubernetes API)
- **Properties**: May use test containers, in-memory DB, envtest, or HTTP mocks
- **Scope**: Test the contract between two layers, not the full stack

### End-to-End Tests (TE2E)

- **What**: Critical user flows through real UI or API surface
- **When**: Core business flows only (login, create org, provision node, deploy service)
- **Properties**: Slower, may be flaky — keep the suite small and stable
- **Scope**: Top 5-10 user journeys per project, not exhaustive coverage
- **Guideline**: If it breaks and nobody notices for a week, it doesn't need E2E

---

## Test Structure

Every test follows **Arrange → Act → Assert** (AAA):

1. **Arrange**: Set up preconditions and inputs
2. **Act**: Execute the behavior under test
3. **Assert**: Verify the expected outcome

**Rules**:
- Group tests by unit/function/method
- Descriptions state expected behavior (not implementation)
- One logical assertion per test case (multiple checks on same outcome is fine)
- No test interdependence — each test runs independently

---

## What NOT to Test

- Framework internals (Angular lifecycle, Go stdlib, Helm templating engine)
- Trivial getter/setter logic
- Third-party library behavior
- Private/unexported methods directly — test through public API
- Exact styling (unless critical for accessibility)

---

## Coverage

- **No hard coverage target** — quality over percentage
- **Minimum expectation**: Every public function/method with non-trivial logic has at least one test
- **CI gate**: Build fails if existing tests break — never skip failing tests (`skip`, `xit`, `t.Skip` without reason)

---

## Stack-Specific Conventions

### Go (API, CLI, Operator, Terraform Provider, Agent)

| Convention | Rule |
|------------|------|
| Framework | Standard `testing` package + `testify` for assertions |
| Unit test file | `<name>_test.go` (same package) |
| Integration test | Build tag `//go:build integration` |
| Table-driven tests | **Preferred** for functions with multiple input/output cases |
| Test helpers | `testdata/` directory for fixtures, `t.Helper()` for shared setup |
| HTTP mocking | `httptest.NewServer` or interface-based mocks |
| K8s controller tests | `envtest` (controller-runtime) for CRD reconciliation |
| Terraform provider | Acceptance tests with `resource.Test()` + `TF_ACC=1` |
| Race detection | Run with `-race` flag in CI |

```go
func TestCreateOrganization(t *testing.T) {
    tests := []struct {
        name    string
        input   CreateOrgInput
        wantErr bool
    }{
        {"valid org", CreateOrgInput{Name: "acme"}, false},
        {"empty name", CreateOrgInput{Name: ""}, true},
    }
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            // Arrange
            svc := NewOrgService(mockRepo)
            // Act
            _, err := svc.Create(tt.input)
            // Assert
            if tt.wantErr {
                assert.Error(t, err)
            } else {
                assert.NoError(t, err)
            }
        })
    }
}
```

### TypeScript / Angular (Console)

| Convention | Rule |
|------------|------|
| Unit framework | Vitest |
| E2E framework | Playwright |
| Unit test file | `<name>.spec.ts` (co-located with source) |
| E2E test file | `<name>.e2e.spec.ts` |
| Mocking | MSW (Mock Service Worker) for HTTP, `vi.mock()` for modules |
| Component tests | Avoid importing heavy plugins (rete-angular-plugin) — mock them |
| Coverage | Vitest built-in coverage reporter |

### TypeScript / Astro (Website)

| Convention | Rule |
|------------|------|
| Unit framework | Vitest |
| E2E framework | Playwright |
| Unit test file | `<name>.spec.ts` |
| Focus | Form validation, pricing logic, SEO metadata |

### Helm (Charts)

| Convention | Rule |
|------------|------|
| Template validation | `helm template` + `helm lint` |
| Schema validation | `kubeval` or `kubeconform` against K8s schemas |
| Value variations | Test with default values AND production overrides |
| Chart testing | `helm test` hooks for smoke tests post-install |

### Keycloak (Theme)

| Convention | Rule |
|------------|------|
| Visual testing | Screenshot comparison or manual review |
| Functional testing | E2E through login/registration flows (Playwright) |
| Template testing | Verify FreeMarker template rendering with test realm |
| Scope | Login, registration, error pages, email templates |

---

## Test Doubles

| Double | Use when |
|--------|----------|
| **Stub** | Returning fixed data (mock HTTP response, fake config) |
| **Spy** | Verifying a function was called with expected args |
| **Mock** | Replacing a dependency entirely (services, APIs) |
| **Fake** | Lightweight in-memory implementation (in-memory DB, envtest) |

> **Rule**: Prefer stubs over mocks. Over-mocking makes tests pass but miss real bugs.

---

## Quick Reference

| Question | Answer |
|----------|--------|
| New feature → test? | Yes — unit at minimum |
| Bug fix → test? | Yes — regression test first |
| Refactor → test? | Existing tests must pass |
| Where do tests live? | Next to the source file |
| Go naming? | `*_test.go` |
| TS naming? | `*.spec.ts`, `*.e2e.spec.ts` |
| Helm? | `helm lint` + `kubeconform` |
| Pattern? | Arrange → Act → Assert |
| Coverage target? | No number, but all public non-trivial logic |