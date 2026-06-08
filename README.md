# Sergi's AI OS

> Formerly `ai-forge` / `sr-pipeline`. Two things merged here: the personal operating system (the five layers below) and the **PACT** framework, which is now the OS's engineering layer ([`engineering/pact/`](engineering/pact/)).

A personal operating model for working with AI. Not a better model — a better setup. Five layers the agent reads so it knows who I am, what it can reach, what to reuse, what runs without me, and what to remember. One loop keeps it from rotting.

Built once. Portable across tools (Claude, Codex, Cursor, whatever's next). The system decays the moment the loop stops running.

> **This is not an AI problem. It's an operating-model problem.** — adapted from the CraftMatters AI-OS masterclass (Ines Lourenço, 2026).

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

## The engineering layer

How I build software with AI. Two toolkits, both in [`engineering/`](engineering/):

| | | |
|---|---|---|
| **PACT** | Portable Claude Code framework — 7 agents (Prepare→Architect→Code→Test), hooks, rules, templates. Installs into any project. | [`engineering/pact/`](engineering/pact/) |
| **Pipeline standards** | Python AI-pipeline conventions: agent contract, debate pattern, config, starter template (the old ai-forge). | [`engineering/`](engineering/) |

---

## How to use it

**Working *in* the OS** — open this repo in Claude Code. `CLAUDE.md` loads first and routes the agent to the right context file before it answers anything.

```bash
cd ~/GitHub/ai-os
claude
```

**Installing PACT into a project** — point Claude at the PACT subfolder:

```bash
git clone https://github.com/seremi5/ai-os /tmp/ai-os
claude "install the framework from /tmp/ai-os/engineering/pact into this project"
```

**Making the OS govern *every* session** — add one routing line to the global `~/.claude/CLAUDE.md` so it points here for product/startup/writing work. (Editing the global config needs your explicit OK — see Status.)

**Running the loop** — once a week the audit runs (see [`automations.md`](automations.md)); you approve 2–3 changes, reject 1–2, move on. Skip it and the OS rots.

---

## Folder map

```
ai-os/                       # the repo (was sr-pipeline / ai-forge)
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
    ├── pact/                #   the PACT framework (agents, hooks, rules, templates)
    ├── standards/           #   ai-forge: agent contract, config
    ├── patterns/            #   ai-forge: pipeline, debate
    └── template/            #   ai-forge: Python starter
```

---

## Status

- ✅ Renamed `sr-pipeline → ai-os` (folder + GitHub `seremi5/ai-os`; old name redirects).
- ✅ PACT framework merged in as the engineering layer (`engineering/pact/`); nothing lost.
- ⏳ Route the global `~/.claude/CLAUDE.md` into this OS — **needs your explicit OK** (it's the agent's own startup config).
- ⏳ Fully-auto weekly audit (background job) — being wired; see [`automations.md`](automations.md).
- ⚠️ Set the quarter's outcome metric in [`context/strategy.md`](context/strategy.md) — only you can.
- ℹ️ PACT's own install docs (`engineering/pact/INSTALL.md`) still say "clone sr-pipeline" at root — update them to point at `engineering/pact/` when convenient.
