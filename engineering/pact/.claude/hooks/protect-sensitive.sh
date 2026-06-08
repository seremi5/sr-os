#!/bin/bash
# Blocks writes to sensitive files before the tool executes.
# Exit 2 = blocking: Claude must reconsider the action.

FILE_PATH="${TOOL_INPUT_PATH:-${TOOL_INPUT_FILE_PATH:-}}"

if echo "$FILE_PATH" | grep -qE "\.env$|\.env\.|\.key$|\.pem$|secrets\.|credentials\.|private\."; then
  echo "🔒 Blocked: modification of sensitive file not allowed: $FILE_PATH" >&2
  exit 2
fi

exit 0
