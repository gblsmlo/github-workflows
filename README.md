# GitHub Workflows

Reusable GitHub Actions workflows for projects maintained by
[Gabriel Melo](https://github.com/gblsmlo).

This repository centralizes CI mechanics that are genuinely shared across the
React component libraries `datagrid`, `kanban`, and `properties`. Product rules,
deployment credentials, release policy, and repository-specific checks remain
owned by each consumer.

## Available workflows

### Bun library CI

`.github/workflows/bun-library-ci.yml` validates a Bun-based TypeScript library
with the shared toolchain contract:

1. check out the caller repository;
2. install Node from `.node-version`;
3. install Bun from `.bun-version`;
4. install dependencies with the frozen lockfile;
5. verify the repository toolchain;
6. lint, typecheck, test, and build;
7. optionally build Storybook.

The workflow uses read-only repository permissions, has a 20-minute timeout,
does not receive secrets, and pins third-party Actions to full commit SHAs.

## Usage

Create `.github/workflows/ci.yml` in the consumer repository:

```yaml
name: CI

on:
  pull_request:
  push:
    branches: [main]

concurrency:
  group: ci-${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

permissions:
  contents: read

jobs:
  validate:
    uses: gblsmlo/github-workflows/.github/workflows/bun-library-ci.yml@v1.0.0
    with:
      build-storybook: true
```

The caller must provide:

- `.node-version`;
- `.bun-version`;
- `bun.lock`;
- package scripts named `toolchain:check`, `lint:ci`, `typecheck`, and `build`;
- a test suite runnable with `bun test`;
- `storybook:build` when `build-storybook` is enabled.

The complete caller is also available in
[`examples/bun-library-ci.yml`](examples/bun-library-ci.yml).

## Inputs

| Input | Type | Default | Purpose |
| --- | --- | --- | --- |
| `build-storybook` | boolean | `true` | Runs `bun run storybook:build` after the package build |

The deliberately small input surface prevents consumer-specific commands from
turning the shared workflow into an untyped shell-command runner.

## Versioning

Consumers should reference an immutable semantic version such as `v1.0.0`.
Referencing a full commit SHA provides the strictest supply-chain guarantee.
References to `main` are suitable only for short-lived evaluation.

Breaking changes to required files, script names, job behavior, or permissions
require a new major release. Additive checks and dependency updates use minor or
patch releases according to their consumer impact.

## Design decisions

The initial contract incorporates the useful parts of
[`gblsmlo/tc96-ui-react`](https://github.com/gblsmlo/tc96-ui-react/tree/main/.github/workflows):

- frozen-lockfile installation;
- lint, typecheck, test, package build, and Storybook build;
- explicit runtime setup;
- read-only permissions for validation.

It intentionally does not copy:

- the duplicated `ci.yml` and `lint-type-safe.yml` pipelines;
- the undefined Node matrix reference in `lint-type-safe.yml`;
- mutation of `package.json` to remove `prepare`;
- verbose Playwright cache diagnostics;
- npm publishing before the component repositories share a release policy;
- release creation and npm publication as independent, unordered jobs.

See
[`docs/decisions/001-bun-library-ci-contract.md`](docs/decisions/001-bun-library-ci-contract.md)
for the complete rationale.

## Security

Report vulnerabilities privately as described in [SECURITY.md](SECURITY.md).
Every pull request must preserve least-privilege permissions and pass
`sh scripts/validate.sh`.

The repository currently contains no AI-agent Actions. Its workflows were
audited for Claude Code, Gemini CLI, OpenAI Codex, and GitHub AI Inference
integration paths. See the
[agentic Actions audit](docs/audits/2026-07-19-agentic-actions.md).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) before changing the reusable contract.

## Roadmap

Future governance, consumer compatibility, and versioned-release slices are
specified in
[`docs/roadmap/governance-and-automation.md`](docs/roadmap/governance-and-automation.md).
They are design-ready but intentionally not implemented until their activation
criteria are met.

## License

[MIT](LICENSE)
