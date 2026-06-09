#!/usr/bin/env bash
#
# Weekly OS Audit — fully automated.
# Runs Claude headless against the OS, writes audits/<ISO-week>.md, and notifies.
# Scheduled by launchd (see com.sergi.sr-os-audit.plist). Also runnable by hand:
#     bash ~/GitHub/sr-os/scripts/run-audit.sh
#
set -euo pipefail

REPO="$HOME/GitHub/sr-os"
CLAUDE="$(command -v claude || echo "$HOME/.local/bin/claude")"
WEEK="$(date +%G-W%V)"
TODAY="$(date '+%Y-%m-%d')"
OUT="$REPO/audits/${WEEK}.md"
PROMPT_FILE="$REPO/scripts/audit-prompt.md"
LOG="$REPO/audits/.last-run.log"

cd "$REPO"
mkdir -p "$REPO/audits"
echo "=== run ${TODAY} $(date '+%H:%M:%S') · week ${WEEK} ===" >"$LOG"

notify() { osascript -e "display notification \"$1\" with title \"SR-OS Weekly Audit\"" 2>/dev/null || true; }
# Open the finished report in VS Code (by bundle id, wherever the app lives); fall back to the default .md app.
open_report() { open -b com.microsoft.VSCode "$1" 2>/dev/null || open "$1" 2>/dev/null || true; }

FULL_PROMPT="Today is ${TODAY}. The ISO week is ${WEEK}.

$(cat "$PROMPT_FILE")"

# Read-only audit. The model reads the OS files + memory and prints the report;
# the script captures stdout, so no write or arbitrary-shell access is needed.
# The allowlist keeps it non-interactive WITHOUT disabling permission gates;
# anything outside the list is auto-denied. --max-budget-usd caps the cost.
if "$CLAUDE" -p "$FULL_PROMPT" \
      --add-dir "$HOME/.claude" \
      --allowedTools "Read,Grep,Glob,Bash(ls:*),Bash(wc:*),Bash(stat:*),Bash(date:*)" \
      --model sonnet \
      --max-budget-usd 1 \
      --output-format text >"${OUT}.tmp" 2>>"$LOG" && [ -s "${OUT}.tmp" ]; then
  mv "${OUT}.tmp" "$OUT"
  echo "OK -> $OUT" >>"$LOG"
  open_report "$OUT"
  notify "Ready: audits/${WEEK}.md — approve 2–3, reject 1–2."
else
  rm -f "${OUT}.tmp"
  echo "FAILED — see $LOG" >>"$LOG"
  notify "Audit failed — see audits/.last-run.log"
  exit 1
fi

# Optional: keep a tracked history on GitHub. Off by default to avoid an
# unattended push. Uncomment to enable.
# git -C "$REPO" add "audits/${WEEK}.md" \
#   && git -C "$REPO" commit -q -m "Weekly OS Audit ${WEEK}" \
#   && git -C "$REPO" push -q origin main
