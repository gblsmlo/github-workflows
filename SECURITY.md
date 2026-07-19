# Security Policy

## Supported versions

Only the latest release in the current major line receives security updates.
Consumers should pin an immutable semantic version or a full commit SHA.

## Reporting a vulnerability

Do not open a public issue for a suspected workflow vulnerability. Use GitHub's
private vulnerability reporting for this repository.

Include the affected workflow and version, the trigger path, required
permissions, possible attacker-controlled input, and the expected impact.

## Security invariants

- Validation uses `contents: read`.
- Reusable CI receives no secrets.
- Third-party Actions are pinned to full commit SHAs.
- No workflow uses `pull_request_target`.
- No workflow executes AI coding agents.
- Release and deployment capabilities require a separate design and review.
