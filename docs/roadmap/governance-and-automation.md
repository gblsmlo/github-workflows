# Governance and automation roadmap

- Status: Proposed, except where marked delivered
- Last reviewed: 2026-07-19
- Scope: `gblsmlo/github-workflows`

This document preserves the next implementation slices without adding runtime
automation before it is needed. Each proposal must receive a fresh security
review when activated because GitHub permissions, Actions, and consumer
contracts may have changed.

## Current baseline

The repository already provides:

- reusable Bun library CI at version `v1.0.0`;
- read-only permissions for validation;
- third-party Actions pinned to full commit SHAs;
- local YAML, contract, pinning, and agentic-Action validation;
- Dependabot updates for GitHub Actions;
- `CODEOWNERS` for the repository's sensitive surfaces.

### CODEOWNERS — delivered

`c145cc0 chore: define workflow code ownership` assigns `@gblsmlo` as the
default owner and explicitly covers workflows, Dependabot, validation,
security policy, and architecture decisions.

The immediate gain is automatic ownership visibility and review requests on
pull requests. It does not, by itself, prevent direct pushes or require an
approval.

#### Deferred ruleset

Do not require code-owner approval while the repository has only one
maintainer. A pull-request author cannot approve their own change, so enforcing
one approval would block legitimate maintenance.

Activate a protected `main` ruleset when a second trusted maintainer is
available. The intended rules are:

- require pull requests;
- require the workflow-validation status check;
- require one code-owner approval;
- dismiss stale approvals after new commits;
- require linear history;
- block force pushes and branch deletion;
- apply the same restrictions to administrators.

## Future slice: consumer compatibility checks

Suggested commit:

```text
feat: add consumer compatibility checks
```

### Real gain

A reusable workflow is a public execution contract. YAML can be syntactically
valid while still breaking a consumer because a required script, version file,
input, or build assumption changed. Compatibility checks provide evidence
against the real component repositories before a new workflow version is
released.

Initial consumers:

- `gblsmlo/datagrid`;
- `gblsmlo/kanban`;
- `gblsmlo/properties`.

### Proposed safe design

Use consumer-owned canary pull requests rather than a central workflow with a
broad personal access token:

1. create a candidate commit in `github-workflows`;
2. open a small PR in each consumer that pins its caller to the candidate SHA;
3. let the consumer run the candidate through its existing `pull_request`
   permissions and repository context;
4. require all consumer checks before releasing the central workflow;
5. close or update the canary PRs after the versioned release.

This tests the actual `workflow_call` boundary without giving the central
repository write access to consumer code or secrets.

If orchestration becomes necessary, prefer a narrowly scoped GitHub App over a
long-lived PAT. It should only create/update canary branches and read check
results in the approved consumer repositories.

### Non-goals

- Do not clone arbitrary repositories from workflow inputs.
- Do not accept arbitrary shell commands as reusable-workflow inputs.
- Do not inherit consumer secrets.
- Do not add deployment or npm publication to compatibility checks.
- Do not make every consumer test every other consumer.

### Activation criteria

Implement this slice when any of these becomes true:

- a second reusable workflow is introduced;
- a proposed change modifies required scripts, version files, inputs, runtime
  setup, permissions, or execution order;
- two or more consumers update the shared workflow independently;
- a compatibility regression reaches a consumer.

### Acceptance criteria

- Candidate SHA is immutable during each canary run.
- All three initial consumers exercise lint, typecheck, tests, package build,
  and Storybook according to their declared contract.
- No consumer secret is passed to the reusable validation workflow.
- Failed consumer evidence blocks the release decision.
- The compatibility process and recovery steps are documented.
- The result passes `actionlint` and an Agentic Actions Auditor review.

## Future slice: automated versioned workflow releases

Suggested commit:

```text
ci: automate versioned workflow releases
```

### Real gain

Consumers pin this repository by tag or commit SHA. Publishing an incorrect tag
can break multiple repositories and tags should be treated as immutable.
Release automation makes validation precede publication and creates a
repeatable audit trail for the exact commit exposed to consumers.

### Proposed safe design

Use a manually initiated release workflow instead of reacting to an already
created tag:

1. accept a semantic version through `workflow_dispatch`;
2. verify that the selected commit belongs to protected `main`;
3. reject an invalid or existing version/tag;
4. run repository validation and required consumer compatibility evidence;
5. require approval through a `release` environment;
6. in a separate job with `contents: write`, create the annotated tag and
   GitHub Release;
7. publish generated notes containing compatibility evidence and the immutable
   commit SHA.

The validation job remains `contents: read`. Only the final release job receives
write permission, and it must depend explicitly on every required check.

### Non-goals

- Do not publish to npm.
- Do not move an existing semantic-version tag.
- Do not release directly from a pull request or fork.
- Do not expose `contents: write` to validation or consumer jobs.
- Do not let an AI model approve or execute a release.

### Activation criteria

Implement this slice when:

- the next reusable-workflow version is ready;
- releases become frequent enough that manual tagging risks drift;
- compatibility evidence exists for the target commit;
- the repository has a protected release approval path.

### Acceptance criteria

- Invalid, duplicate, or non-main versions are rejected before mutation.
- Validation and compatibility jobs complete before the release job.
- The release job has the only write-capable token.
- The tag resolves to the validated commit and is never moved.
- Release notes identify breaking changes, inputs, permissions, consumers
  tested, and the full commit SHA.
- A failed release leaves no partial tag or GitHub Release.
- The workflow passes `actionlint`, SHA-pinning validation, and an Agentic
  Actions Auditor review.

## Explicitly deferred agentic automation

AI review, issue triage, mention bots, deployment risk assessment, automated
rebases, and AI-assisted conflict resolution remain outside this repository.
They process attacker-controlled content or require write permissions that are
not justified by the current workflow-distribution scope.

Any future exception requires:

- a separate decision record;
- explicit trigger and user allowlists;
- minimal permissions and no inherited secrets;
- isolation from release credentials;
- static Agentic Actions Auditor analysis;
- a documented response to prompt injection and output-handling risks.
