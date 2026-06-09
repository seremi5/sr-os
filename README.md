# SR-OS

> SR Operating System — a reusable setup that gives any AI assistant the context, tools, memory, and routines to do the work properly, without being re-briefed every time.

Without a setup like this, you re-explain yourself to the AI every session: who you are, what you're building, how you like things done. SR-OS writes that down once — five layers the assistant reads at the start of every task — and a weekly check keeps them current.

## What it does

- **Starts every task already in context.** The assistant applies the right voice, domain knowledge, and house rules automatically — no re-briefing. It's wired globally, so this holds in any session, not only inside this repo.
- **Keeps itself current — the weekly loop.** Every Monday a background job reviews all five layers and proposes a short list of changes: context that's gone stale, tools you've stopped using, prompts you've typed often enough to save as a reusable shortcut, automations producing noise you ignore, and memories that contradict each other. You approve a few and reject a few — about ten minutes. Without it, the setup quietly rots. (The exact checklist lives in [`audit.md`](audit.md).)
- **Builds software through [AItelier](engineering/aitelier/)** — its engineering layer, a composable framework you set up per project (see *Building software*).

---

## The five layers + one loop

| Layer | What it is | File |
|-------|-----------|------|
| **L1 · Context** | Who I am, my domain, and the rules — read first, every task | [`CLAUDE.md`](CLAUDE.md) (router) + [`context/`](context/) |
| **L2 · Connections** | The tools and APIs it can reach — Gmail, Notion, Calendar, git | [`connections.md`](connections.md) |
| **L3 · Skills** | Saved prompts you trigger by name instead of retyping | [`skills/`](skills/) |
| **L4 · Automations** | Jobs that run on a schedule without me | [`automations.md`](automations.md) |
| **L5 · Memory** | Facts it keeps between conversations | [`memory.md`](memory.md) → `~/.claude/.../memory/` |
| **The loop** | The weekly check that keeps all five current | [`audit.md`](audit.md) |

---

## Building software — AItelier

The engineering layer is **[AItelier](engineering/aitelier/)**: a composable framework you set up once per project. It asks what you need (stack, phases, agents, guardrails, power modules) and renders a project-local `.claude/`. Two ways in:

**Start a brand-new project**

```bash
mkdir my-app && cd my-app && git init && claude
```
Then tell Claude:
> *Set up AItelier in this project. Follow `~/GitHub/sr-os/engineering/aitelier/init/aitelier-init.md`.*

It asks a few questions (preset, phases, agents, power modules), then scaffolds `aitelier.json` + `.claude/`. Restart Claude Code and describe your first task.

**Add it to an existing project**

```bash
cd ~/code/my-existing-app && claude
```
Then tell Claude the same line. It **auto-detects** your stack and build/test/lint commands, proposes a fitting module set, and sets up **without touching your code** (it backs up any existing `.claude/`). Restart Claude Code and carry on.

Full guide, module menu, and the "make it a `/command`" shortcut: **[engineering/aitelier/README.md](engineering/aitelier/README.md)**.

---

## Running it day to day

- **Open it:** `cd ~/GitHub/sr-os && claude` — `CLAUDE.md` loads first and routes the assistant to the right context before it answers.
- **Everywhere else:** nothing to do. The global `~/.claude/CLAUDE.md` points here, so the context applies in any project you open.
- **The Monday loop is automatic** ([`automations.md`](automations.md)) — it writes `audits/<week>.md` and **opens it in your editor** (if the Mac was asleep at 08:00, the next time you open it). Approve a few changes, reject a few. That ten minutes is what keeps the whole thing from rotting.

---

## Folder map

```
sr-os/                       # the repo (was sr-pipeline / ai-forge)
├── README.md                # this file
├── CLAUDE.md                # L1 router — read first, ≤80 lines
├── context/                 # L1 Context (profile, strategy, domain, terminology)
├── connections.md           # L2 Connections inventory
├── skills/                  # L3 Skills catalog
├── automations.md           # L4 Automations registry
├── memory.md                # L5 — pointer to ~/.claude memory (not duplicated)
├── audit.md                 # the Weekly OS Audit (the loop)
├── audits/                  # dated audit outputs (YYYY-Www.md)
└── engineering/             # how I build software with AI
    └── aitelier/            #   AItelier — the composable framework
```

