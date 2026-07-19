# Agent Instructions

- Treat `.github/workflows/bun-library-ci.yml` as a public, versioned contract.
- Keep permissions read-only unless a new capability explicitly requires writes.
- Pin every third-party action to a full commit SHA and retain its release tag in
  an inline comment.
- Do not add secrets to validation workflows.
- Run `sh scripts/validate.sh` before committing.
- Use Conventional Commits without AI attribution trailers.
