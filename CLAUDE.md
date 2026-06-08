# AI OS — router

Read this first. It points at every other file. Don't load a layer you don't need.

## Who you're working for

Sergi Reina-Miret — AI PM at OakNorth; lawyer turned fintech PM (ex-Monite, Vertex, Avalara). Builds AI tools evenings and weekends. Full identity and voice in [`context/profile.md`](context/profile.md). **Apply the voice without being asked.**

## Routing table

| If the task is about… | Read first |
|-----------------------|-----------|
| Voice, tone, principles, how Sergi writes | [`context/profile.md`](context/profile.md) |
| Banned words, vocabulary to avoid | [`context/terminology.md`](context/terminology.md) |
| This quarter's priorities, what's in focus | [`context/strategy.md`](context/strategy.md) |
| Sergi's domain: fintech, AP/AR, e-invoicing, lending | [`context/domain.md`](context/domain.md) |
| Which MCPs / APIs / CLIs are available | [`connections.md`](connections.md) |
| A prompt typed 3+ times; a reusable skill | [`skills/README.md`](skills/README.md) |
| What runs on a schedule; adding an automation | [`automations.md`](automations.md) |
| What the agent should remember across chats | [`memory.md`](memory.md) → `~/.claude/.../memory/` |
| Building software with AI; the PACT workflow; code conventions | [`engineering/README.md`](engineering/README.md) → PACT in [`engineering/pact/`](engineering/pact/) |
| The weekly health check of this OS | [`audit.md`](audit.md) |

## Always-on rules

- **British English. Plain words.** No "operationalise", "cadence", "synergies", or "leverage" as a verb. Write as if explaining to a smart colleague whose first language is Spanish.
- **Pyramid Principle.** Lead with the answer, then support it. Don't build towards a conclusion.
- **Ship small.** Direct provider APIs over SaaS wrappers. Regression-tested incremental change.
- **Browser actions need `@browser`** in the message — otherwise tell Sergi to add it. (Global rule in `~/.claude/CLAUDE.md`.)
- **Memory is approved, not automatic.** Propose a save, write the WHY, don't silently accumulate.

## The discipline that keeps each layer alive

| Layer | One rule | Trap it avoids |
|-------|----------|----------------|
| L1 Context | ≤500 words/file, ≤80 lines here | Bloat |
| L2 Connections | 3 used beats 12 connected | Sprawl |
| L3 Skills | Write the skill the 3rd time | Skill graveyard |
| L4 Automations | Every automation has a constraint | Walls of text |
| L5 Memory | Approve every save, write the WHY | Contradiction soup |

Run the loop in [`audit.md`](audit.md) weekly. Without it, the rest is just a setup.
