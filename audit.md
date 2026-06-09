# The Weekly OS Audit — the loop

> One scheduled task scans all five layers, weekly, and proposes specific updates.
> **Approve 2–3. Reject 1–2. Move on. Ten minutes a week. Forever.**
> Skip it and the OS rots. Run it on holiday — especially then.

## What the audit checks per layer

| Layer | Flag when… | Where to look |
|-------|-----------|---------------|
| **L1 Context** | File >30 days old, >500 words, or router >80 lines | `CLAUDE.md`, `context/` |
| **L2 Connections** | A connection unused in 30 days | `connections.md` |
| **L3 Skills** | A skill unused 30 days; a prompt typed 3+ times not yet a skill | `skills/`, recent chats |
| **L4 Automations** | Output exceeds its constraint, or unread for 14 days | `automations.md` |
| **L5 Memory** | Contradictions, or entries stale >90 days | `~/.claude/.../memory/MEMORY.md` |

## The prompt — paste this once a week

```
Run a Weekly OS Audit on my AI OS at ~/GitHub/sr-os, right now.

For each of the 5 layers, scan and report in this exact format:

L1 CONTEXT      · propose changes to CLAUDE.md and context/*.md.
                  flag any file > 30 days old or > 500 words,
                  and the router if it exceeds 80 lines.

L2 CONNECTIONS  · from connections.md, list connections used in the
                  last 30 days. flag any unused.

L3 SKILLS       · list skills invoked in the last 30 days. flag any
                  unused. scan recent chats for prompts typed 3+
                  times that should become skills (add to skills/).

L4 AUTOMATIONS  · from automations.md, list scheduled jobs. flag any
                  whose output exceeds its constraint, or that I
                  haven't opened in 14 days.

L5 MEMORY       · list entries from ~/.claude/.../memory/MEMORY.md.
                  flag contradictions and anything older than 90 days.

Output rules:
  - max 5 proposals per layer
  - 1 line each, max 20 words
  - tag every proposal:  [ ] APPROVE   [ ] REJECT   [ ] DISCUSS

End with a one-line "so what" on OS health.
```

## Where the output lands

Each run is saved to [`audits/`](audits/) as `YYYY-Www.md` (ISO week). That gives a history you can diff — and the next audit can flag a proposal that keeps reappearing un-actioned.

## Cadence

Run **every Monday morning** (~10 min). Either paste the prompt above, or rely on the scheduled routine — see [`automations.md`](automations.md). The routine writes its result into `audits/` and opens it in your editor; you still approve/reject by hand.

## Your OS is alive when…

> voice applied · context read · live data pulled · audit lands Monday — all without you asking.
