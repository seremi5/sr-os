#!/bin/bash
# Runs the project's lint command on the file just edited.
# Exit 0 = non-blocking (informational only).
#
# Reads `commands.lint` from .claude/project.json. If empty, skips silently.

FILE_PATH="${TOOL_INPUT_PATH:-${TOOL_INPUT_FILE_PATH:-}}"
[ -z "$FILE_PATH" ] && exit 0

# Resolve project root: directory containing .claude/project.json
PROJECT_ROOT=$(pwd)
while [ "$PROJECT_ROOT" != "/" ] && [ ! -f "$PROJECT_ROOT/.claude/project.json" ]; do
  PROJECT_ROOT=$(dirname "$PROJECT_ROOT")
done
[ ! -f "$PROJECT_ROOT/.claude/project.json" ] && exit 0

LINT_CMD=$(jq -r '.commands.lint // empty' "$PROJECT_ROOT/.claude/project.json")
[ -z "$LINT_CMD" ] && exit 0

# Only lint code files we'd reasonably lint
case "$FILE_PATH" in
  *.ts|*.tsx|*.js|*.jsx|*.mjs|*.cjs|*.vue|*.svelte) ;;
  *.py|*.rb|*.go|*.rs) ;;
  *) exit 0 ;;
esac

echo "→ Lint: $(basename "$FILE_PATH")"
cd "$PROJECT_ROOT" && eval "$LINT_CMD" "$FILE_PATH" 2>&1 | tail -10
exit 0
