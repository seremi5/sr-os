# SR-OS

> SR Operating System — a portable layer of context, memory, skills, automations, and a weekly audit that makes any AI work like me, across everything I build.

Not a better model. A better setup. Five layers the agent reads so it knows who I am, what it can reach, what to reuse, what runs without me, and what to remember. One loop keeps it from rotting.

> **This is not an AI problem. It's an operating-model problem.** — adapted from the CraftMatters AI-OS masterclass (Ines Lourenço, 2026).

## What it does for me

- **Every session sounds like me.** The global `~/.claude/CLAUDE.md` routes here, so my voice, domain, and rules apply everywhere — not only in this repo.
- **It audits itself weekly.** A Monday-morning job checks all five layers and proposes fixes, so the setup never rots.
- **It builds software through [AItelier](engineering/aitelier/)** — its engineering layer, a composable framework I set up per project (see *Building software*).

---

## The five layers + one loop

| Layer | Purpose | File |
|-------|---------|------|
| **L1 · Context** | What the agent reads first | [`CLAUDE.md`](CLAUDE.md) (router) + [`context/`](context/) |
| **L2 · Connections** | Reach beyond the workspace | [`connections.md`](connections.md) |
| **L3 · Skills** | Prompts I reuse, not retype | [`skills/`](skills/) |
| **L4 · Automations** | Work that runs while I sleep | [`automations.md`](automations.md) |
| **L5 · Memory** | What survives every conversation | [`memory.md`](memory.md) → `~/.claude/.../memory/` |
| **The loop** | Weekly OS Audit — the keystone | [`audit.md`](audit.md) |

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

> The engineering folder also keeps the older **ai-forge** Python AI-pipeline standards (`standards/`, `patterns/`, `template/`) — reference material for building data/AI pipelines.

---

## Running the OS itself

- **Open it:** `cd ~/GitHub/sr-os && claude` — `CLAUDE.md` loads first and routes to the right context before answering.
- **It governs every session** through the global router (already wired).
- **The loop runs itself** every Monday 08:00 → `audits/<week>.md` + a notification ([`automations.md`](automations.md)); you approve 2–3 changes, reject 1–2, move on. Skip it and the OS rots.

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
    ├── README.md            #   index for this layer
    ├── aitelier/            #   AItelier — the composable framework
    ├── standards/           #   ai-forge: agent contract, config
    ├── patterns/            #   ai-forge: pipeline, debate
    └── template/            #   ai-forge: Python starter
```

---

## Status

- ✅ Renamed `sr-pipeline → sr-os` (folder + GitHub `seremi5/sr-os`; old name redirects).
- ✅ **AItelier** is the engineering layer — composable, file-based ([`engineering/aitelier/`](engineering/aitelier/)).
- ✅ Global `~/.claude/CLAUDE.md` routes here for product/startup/writing work.
- ✅ Weekly OS Audit is fully automatic — a macOS LaunchAgent runs headless `claude` every Monday 08:00 → `audits/<week>.md` + a notification.
- ⚠️ Set the quarter's outcome metric in [`context/strategy.md`](context/strategy.md) — only you can.
