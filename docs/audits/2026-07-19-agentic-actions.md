# Agentic Actions security audit

- Date: 2026-07-19
- Method: static analysis with the Agentic Actions Auditor methodology
- Scope: root-level `.github/workflows/*.yml` and `.yaml`

## Remote analysis: `gblsmlo/tc96-ui-react` (`main`)

**Analyzed 3 workflows containing 0 AI action instances. Found 0 findings: 0
High, 0 Medium, 0 Low, 0 Info.**

### Workflows scanned

| Workflow file | AI action instances |
| --- | ---: |
| `.github/workflows/ci.yml` | 0 |
| `.github/workflows/lint-type-safe.yml` | 0 |
| `.github/workflows/release.yml` | 0 |

### AI Actions found

| Action type | Count |
| --- | ---: |
| Claude Code Action | 0 |
| Gemini CLI | 0 |
| OpenAI Codex | 0 |
| GitHub AI Inference | 0 |

No security findings identified.

The remote workflows were read through the GitHub Contents API and treated only
as data. No referenced local composite Actions or reusable workflows required
cross-file resolution.

## Local analysis: `gblsmlo/github-workflows`

**Analyzed 2 workflows containing 0 AI action instances. Found 0 findings: 0
High, 0 Medium, 0 Low, 0 Info.**

### Workflows scanned

| Workflow file | AI action instances |
| --- | ---: |
| `.github/workflows/bun-library-ci.yml` | 0 |
| `.github/workflows/validate.yml` | 0 |

### AI Actions found

| Action type | Count |
| --- | ---: |
| Claude Code Action | 0 |
| Gemini CLI | 0 |
| OpenAI Codex | 0 |
| GitHub AI Inference | 0 |

No security findings identified.

The repository validator rejects known AI-agent Action references so their
introduction cannot happen without changing the security contract and receiving
a dedicated review.
