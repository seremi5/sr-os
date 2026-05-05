#!/bin/bash
# End-of-turn quality gate: runs typecheck if code files were modified this turn.
# Exit 1 = non-blocking warning (Claude sees it but conversation continues).
#
# Reads `commands.typecheck` from .claude/project.json. If empty, skips silently.

# Resolve project root
PROJECT_ROOT=$(pwd)
while [ "$PROJECT_ROOT" != "/" ] && [ ! -f "$PROJECT_ROOT/.claude/project.json" ]; do
  PROJECT_ROOT=$(dirname "$PROJECT_ROOT")
done
[ ! -f "$PROJECT_ROOT/.claude/project.json" ] && exit 0

TYPECHECK_CMD=$(jq -r '.commands.typecheck // empty' "$PROJECT_ROOT/.claude/project.json")
[ -z "$TYPECHECK_CMD" ] && exit 0

MARKER="$PROJECT_ROOT/.claude/.turn-marker"

# Look for code files modified since the last turn
EXTENSIONS=(ts tsx js jsx mjs cjs vue svelte py rb go rs)
FIND_NAMES=()
for ext in "${EXTENSIONS[@]}"; do
  FIND_NAMES+=(-o -name "*.$ext")
done
# Drop leading -o
FIND_NAMES=("${FIND_NAMES[@]:1}")

if [ -f "$MARKER" ]; then
  MODIFIED=$(find "$PROJECT_ROOT" \
    -type d \( -name node_modules -o -name .git -o -name dist -o -name build -o -name .next -o -name venv -o -name __pycache__ \) -prune -o \
    -type f \( "${FIND_NAMES[@]}" \) -newer "$MARKER" -print 2>/dev/null | head -1)
else
  MODIFIED=""
fi

# Always update the marker for next turn
touch "$MARKER"

# No code changes this turn — skip
[ -z "$MODIFIED" ] && exit 0

echo "🔍 Code files changed — running typecheck..."
cd "$PROJECT_ROOT" && eval "$TYPECHECK_CMD" 2>&1 | tail -10
RC=$?

if [ $RC -ne 0 ]; then
  echo "" >&2
  echo "⚠️  Type errors detected. Fix before marking work complete." >&2
  exit 1
fi

echo "✅ Typecheck passed."
exit 0
