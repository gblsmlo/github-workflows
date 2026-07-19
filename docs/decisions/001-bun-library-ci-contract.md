# 001. Standardize CI for Bun component libraries

- Status: Accepted
- Date: 2026-07-19

## Context

The `datagrid`, `kanban`, and `properties` repositories use the same runtime
files and validation scripts. Copying their full CI definition creates drift
without giving each repository meaningful autonomy.

The `tc96-ui-react` workflows demonstrate the desired validation stages but
also contain duplicated pipelines, inconsistent branch policies, an undefined
matrix value, package mutation during CI, and release jobs without explicit
ordering.

## Decision

Publish one reusable workflow for Bun-based component libraries.

The reusable workflow owns:

- runtime installation from version files;
- frozen-lockfile dependency installation;
- toolchain verification;
- lint, typecheck, tests, package build, and optional Storybook build;
- read-only permissions and a finite timeout;
- SHA-pinned third-party Actions.

The caller owns:

- push and pull-request triggers;
- concurrency and branch policy;
- whether Storybook is part of required validation;
- repository-specific checks;
- deployment, release, and publication credentials.

The workflow exposes only the `build-storybook` boolean. Commands are fixed by
the repository script contract instead of accepting arbitrary shell strings.

## Consequences

- Shared validation changes are reviewed and versioned once.
- Consumers retain visible control over when CI runs.
- Every consumer must keep the agreed script names and version files.
- A new validation need is not centralized until it is stable across at least
  two consumers.
- npm publishing remains deferred until package visibility, provenance,
  registry authentication, and release ordering are agreed.

## Revisit triggers

Revisit this decision when:

- two consumers need the same additional validation stage;
- the libraries adopt npm publication;
- a monorepo consumer needs configurable working directories;
- GitHub changes reusable-workflow permission or pinning behavior;
- runtime versions stop being repository-owned.
