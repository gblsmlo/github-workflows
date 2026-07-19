# Contributing

Changes to reusable workflows affect every pinned consumer when it upgrades.
Keep pull requests small and describe the compatibility impact.

## Local validation

```sh
sh scripts/validate.sh
```

If `actionlint` is installed, the script runs it automatically. Otherwise it
still validates YAML syntax, required contract markers, SHA pinning, and the
absence of known AI-agent Actions.

## Compatibility

- Do not rename existing inputs in a minor or patch release.
- Do not weaken permissions or introduce implicit secrets.
- Add consumer-specific behavior only when at least two repositories need the
  same stable contract.
- Keep repository-specific triggers and concurrency in caller workflows.
- Update the decision record when changing ownership boundaries.

Use Conventional Commits and do not append coding-agent attribution trailers.
