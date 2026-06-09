# L4 · Automations

> Work that runs while I sleep. Scheduled prompts that run without me.
> **Discipline: every automation has a tight output constraint** — or it becomes noise I stop reading. "5 bullets, 8 words each" beats "a summary of the week."

## The five types

Digests · Monitors · Audits · Briefings · Reminders.

## What's scheduled now

| When (Madrid) | Type | Job | Owner | Constraint |
|---------------|------|-----|-------|-----------|
| Daily 23:07 | Digest | Startup ideation cycle drops ideas | `startup` routine | 5 ideas/day |
| Daily 23:30 | Audit | Project Steward syncs `portfolio/<project>.md` + Notion | Steward (per project) | State diff only |
| Weekday | Creator | LinkedIn — 3 post candidates in my voice | `/linkedin-daily` | 3 cards, sources verified |
| Sunday 09:00 | Briefing | Portfolio Coordinator writes the week's decision | Coordinator | 1 decision page |
| Monday (manual) | — | `/weekly-cycle` Mon→Fri | CEO (operator-run) | Not unattended |
| **Mon 08:00** | **Audit** | **Weekly OS Audit** → `audits/<week>.md`, opened in your editor (+ a notification) | launchd → `scripts/run-audit.sh` | **max 5 proposals/layer, 1 line each** |

> The OS audit is the keystone, and now fully automatic — see "How the OS Audit runs" below.

## Limits to remember

- An agent team can't run unattended from cron — the lead must be a live session. The weekly cycle is operator-triggered.
- Posting (LinkedIn, email) is **always manual**. Automations draft and propose; they never publish.

## Health check

| Working | Rotting |
|---------|---------|
| Monday digest lands, actually read | Digest = wall of text, ignored |
| Output is tight, every line earns it | I can't remember what's scheduled |
| Downstream work runs without me triggering | I trigger work the automation should do |

## How the OS Audit runs (fully automatic)

A macOS **launchd** agent runs headless `claude` against this repo every Monday 08:00, writes the report to `audits/<ISO-week>.md`, opens it in your editor (VS Code), and fires a notification. If the Mac is asleep or off at 08:00, launchd runs the job on the next wake/login — so the report opens the next time you sit down. You still approve/reject by hand — that's the point.

- **Runner:** [`scripts/run-audit.sh`](scripts/run-audit.sh) — `claude -p` with the prompt in [`scripts/audit-prompt.md`](scripts/audit-prompt.md), `--model sonnet`, capped at `--max-budget-usd 1`.
- **Schedule:** [`scripts/com.sergi.sr-os-audit.plist`](scripts/com.sergi.sr-os-audit.plist) (install/uninstall commands are in the plist header).
- **Why local, not a cloud cron:** a remote agent can't see local memory, chats, or MCP usage. This job runs on the Mac, so it can.

Run it by hand any time: `bash scripts/run-audit.sh`. Test the schedule now: `launchctl kickstart -k gui/$(id -u)/com.sergi.sr-os-audit`.
