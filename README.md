# sr-pipeline

A portable [Claude Code](https://claude.com/claude-code) framework: a complete set of agents, hooks, rules, and conventions for building software with AI assistance — extracted from real, shipped projects and parametrised so any project can adopt it.

## What it gives you

- **PACT** — a four-phase workflow (**P**repare → **A**rchitect → **C**ode → **T**est) executed by 7 specialist sub-agents.
- **Hooks** — automatic guardrails that protect secrets, lint after edits, and typecheck before claiming "done".
- **Rules** — codified conventions for quality gates, async question handling, full-stack awareness, deployment checklists.
- **Templates** — a PRD scaffold and CLAUDE.md orchestrator that adapts to your stack.

Everything is stack-agnostic. Project-specific values (test commands, paths, language, deployment) live in a single `.claude/project.json` file the framework reads at runtime.

## Install

In the target project's root:

```bash
git clone https://github.com/seremi5/sr-pipeline /tmp/sr-pipeline
claude "install the framework from /tmp/sr-pipeline into this project"
```

Claude reads `INSTALL.md` from the cloned repo and follows it as a runbook. It autodetects what it can from your `package.json` / `pyproject.toml` and asks you to confirm or correct each value, then installs the framework into your project's `.claude/` folder.

After install, restart Claude Code so the hooks register, then try:

```
/pact-start "build a hello-world endpoint"
```

## Update

```bash
cd /tmp/sr-pipeline && git pull
cd <your-project>
claude "update the framework from /tmp/sr-pipeline"
```

The update re-copies the universal pieces (agents, commands, rules, hooks) but never touches your `project.json` or `CLAUDE.md`.

## Anatomy

```
sr-pipeline/
├─ INSTALL.md                ← runbook Claude follows
├─ .claude/                  ← the portable framework
│  ├─ agents/                ← 7 PACT agents
│  ├─ commands/              ← /pact-start, /daily-sync, /run-tests, /deploy-staging
│  ├─ rules/                 ← quality-gates, context-mgmt, async-questions,
│  │                            full-stack-awareness, deployment-checklist
│  ├─ hooks/                 ← protect-sensitive.sh, post-edit.sh, end-of-turn.sh
│  ├─ templates/             ← prd-template.md
│  └─ settings.json          ← hook wiring
└─ templates/                ← install-time templates (not copied verbatim)
   ├─ CLAUDE.md.template     ← orchestrator, parametrised by project.json
   └─ project.json.template  ← runtime config schema
```

## How agents stay stack-agnostic

Every agent's system prompt says *"follow the conventions in CLAUDE.md"* rather than *"write Express+Drizzle code"*. Project-specific stack details live in your `CLAUDE.md` (rendered at install from your stack summary). Hooks and commands read commands (test, lint, typecheck) from `.claude/project.json`.

This means:
- Changing your test command later → edit one field in `project.json`
- Same framework works for a TypeScript webapp, Python CLI, Go service — anything

## What's not included

- **Stack-specific code templates.** sr-pipeline doesn't generate boilerplate apps. It installs the meta-layer (how to develop with AI), not the application skeleton. Use the framework to develop in your existing project, or scaffold an empty project and let the agents build it from scratch.
- **Language-specific rules.** User-facing language is a `project.json` field referenced from CLAUDE.md.
- **Versioned-artifact tracking.** Use git.

## Requirements

- macOS or Linux (hooks are bash; WSL works on Windows)
- [`jq`](https://stedolan.github.io/jq/) for hooks to read `project.json`
- [Claude Code](https://claude.com/claude-code) (the agents/hooks/commands are Claude-Code-specific)

## Status

Single-author project. Lives at the speed Sergi's two reference implementations (Lifeteen booking system, Expense management) evolve. Treat it as opinionated, not authoritative.

## License

MIT.
