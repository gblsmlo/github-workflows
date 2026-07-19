#!/bin/sh

set -eu

workflow_directory=".github/workflows"
reusable_workflow="$workflow_directory/bun-library-ci.yml"

for file in "$workflow_directory"/*.yml "$workflow_directory"/*.yaml examples/*.yml examples/*.yaml; do
  if [ ! -e "$file" ]; then
    continue
  fi

  ruby -e 'require "yaml"; YAML.parse_file(ARGV.fetch(0))' "$file"
done

for marker in \
  "workflow_call:" \
  "permissions:" \
  "contents: read" \
  "bun install --frozen-lockfile" \
  "bun run toolchain:check" \
  "bun run lint:ci" \
  "bun run typecheck" \
  "bun test" \
  "bun run build"
do
  if ! grep -Fq "$marker" "$reusable_workflow"; then
    echo "Missing required marker in $reusable_workflow: $marker" >&2
    exit 1
  fi
done

if grep -En 'uses: [^#]+@(main|master|v[0-9]+)([[:space:]]|$)' "$workflow_directory"/*.yml; then
  echo "Actions must be pinned to full commit SHAs" >&2
  exit 1
fi

if grep -ERn \
  'anthropics/claude-code-action|google-github-actions/run-gemini-cli|google-gemini/gemini-cli-action|openai/codex-action|actions/ai-inference' \
  "$workflow_directory"
then
  echo "AI-agent Actions require a dedicated security review" >&2
  exit 1
fi

if command -v actionlint >/dev/null 2>&1; then
  actionlint
fi

echo "Workflow validation passed"
