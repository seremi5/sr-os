# sr-pipeline install design

Working spec for how sr-pipeline gets distributed, installed into a target project,
and updated. Reviewed and approved before extraction work begins.

---

## 1. The install command

One canonical invocation, documented in the sr-pipeline README:

```bash
# In the target project's root directory:
git clone https://github.com/seremi5/sr-pipeline /tmp/sr-pipeline
claude "install the framework from /tmp/sr-pipeline into this project"
```

The cloned `/tmp/sr-pipeline` contains an `INSTALL.md` at its root. When Claude
sees the install request, it reads that file and follows it as a runbook.

Optional convenience: a one-liner shell wrapper (`./install.sh`) that does the
clone+invoke for non-Claude-fluent users.

---

## 2. What Claude does at install (per `INSTALL.md`)

1. Verify the target directory is the user's project root (look for git, ask if unclear).
2. Read `/tmp/sr-pipeline/INSTALL.md` for the question schema.
3. Ask the user 8 questions (see §3). Auto-detect what it can from
   `package.json` / `pyproject.toml` and confirm with the user.
4. Write `.claude/project.json` in the target project with the answers.
5. Copy framework files from `/tmp/sr-pipeline/.claude/` into the target's `.claude/`,
   *skipping* files marked irrelevant (e.g., `full-stack-awareness.md` if no
   frontend exists).
6. Render `CLAUDE.md` at the project root by filling the template in
   `/tmp/sr-pipeline/templates/CLAUDE.md.template` with the user's answers.
   This is the *only* file that uses placeholder substitution.
7. Make hook scripts executable.
8. Print a summary: what was installed, what was skipped, where to edit later.

---

## 3. Install questions

| # | Question | Auto-detect source |
|---|---|---|
| 1 | Project name? | parent dir name |
| 2 | One-line description of what you're building? | — |
| 3 | Project shape: `single-app` / `backend-frontend-monorepo` / `cli-tool` / `other`? | infer from folders |
| 4 | Backend dir (or skip): `backend/` ? | dir scan |
| 5 | Frontend dir (or skip): `frontend/` ? | dir scan |
| 6 | Primary user-facing language for copy? `English` / `Spanish` / `Catalan` / other | — |
| 7 | Quality gate commands? Will autodetect from package.json / pyproject.toml; user confirms each: `typecheck`, `test`, `lint`, `build`, `dev` | package.json scripts |
| 8 | Deployment target? `railway+vercel` / `vercel-only` / `none` / `other` | — |

Anything skipped or marked "none" → corresponding files are not copied,
corresponding rules are not installed.

---

## 4. The runtime config: `.claude/project.json`

A single file in the target project that holds everything project-specific.
Hooks and agents read from it; placeholders get substituted *only* in
human-prose files at install time.

```jsonc
{
  "name": "Lifeteen Booking System",
  "goal": "Online registration + check-in for Lifeteen retreats",
  "shape": "backend-frontend-monorepo",
  "paths": {
    "backend": "backend/",
    "frontend": "frontend/"
  },
  "language": {
    "user_facing": "Spanish",
    "code_comments": "English"
  },
  "commands": {
    "typecheck": "npm run typecheck",
    "test": "npm test",
    "lint": "npm run lint",
    "build": "npm run build",
    "dev": "npm run dev"
  },
  "deployment": {
    "frontend": "vercel",
    "backend": "railway",
    "branch_strategy": "feature -> staging -> main"
  },
  "stack_summary": "Express+TS+Drizzle+Zod (BE), React+Vite+shadcn+TanStack Query (FE)"
}
```

**Why this matters:**
- Changing the test command later? Edit one field. Hooks pick it up next run.
- Renaming the project? Edit one field. (CLAUDE.md prose still has the old name —
  acceptable trade-off; alternative is full re-render.)
- Agents that need stack details read `stack_summary` rather than having it
  baked into their prompts.

---

## 5. Placeholder rules

To avoid the "30 files with `{{PROJECT_NAME}}` going stale" problem:

- **Substitute placeholders ONLY in `CLAUDE.md`** (the orchestrator system prompt
  template), and only at install time.
- All other files (agents, rules, commands, hooks) reference `project.json`
  fields at runtime instead of having values baked in.
- Hook example: `end-of-turn.sh` does `jq -r '.commands.typecheck' .claude/project.json`
  rather than embedding the command.

This means: agent system prompts, rule docs, hooks, and slash commands are
**100% stack-agnostic**. They work for any project. The customization lives
in `project.json` + `CLAUDE.md`.

---

## 6. sr-pipeline repo structure

```
sr-pipeline/
├─ README.md                ← what it is, install command, philosophy
├─ INSTALL.md               ← the runbook Claude follows
├─ .claude/                 ← portable framework (copied to target on install)
│  ├─ agents/               ← 7 PACT agents (stack-agnostic prompts)
│  ├─ commands/             ← /pact-start, /daily-sync, /run-tests, etc.
│  ├─ rules/                ← context-management, async-questions, quality-gates,
│  │                          full-stack-awareness, deployment-checklist, etc.
│  ├─ hooks/                ← protect-sensitive.sh, post-edit.sh, end-of-turn.sh
│  └─ templates/            ← prd.md, etc.
└─ templates/
   ├─ CLAUDE.md.template    ← the only file with {{placeholders}}
   ├─ project.json.template ← starter project.json filled at install
   └─ backend-CLAUDE.md.template, frontend-CLAUDE.md.template
                              (rendered only if those dirs exist)
```

---

## 7. Edge cases & how they're handled

| Scenario | Behaviour |
|---|---|
| Project has no tests yet | `test` command in `project.json` is `""`; hooks check for empty and skip. |
| Project has no frontend | Frontend dir blank in config; `pact-frontend-coder.md` not copied; `full-stack-awareness.md` not copied; `frontend/CLAUDE.md` not rendered. |
| Tiny script / weekend project | User can answer "skip PACT for trivial changes" via a `quality_gates_strict: false` flag; orchestrator CLAUDE.md mentions this opt-out. |
| Windows user | README says explicitly: "Mac/Linux only. WSL works." Hooks remain bash. |
| User on Cursor/Copilot, not Claude Code | README says: "This framework is Claude Code specific. For other tools, the agents/rules markdown is still useful as reference." |
| Update sr-pipeline after install | Re-run install with `--update` flag → re-copies `.claude/` framework files but **never** overwrites `project.json` or `CLAUDE.md`. |
| Install fails halfway | Idempotent install: re-running the install command picks up where it left off. Track install state in `.claude/.install-state`. |

---

## 8. Update story

```bash
cd /tmp/sr-pipeline && git pull
cd ~/path/to/my-project
claude "update the framework from /tmp/sr-pipeline"
```

Claude:
1. Reads sr-pipeline `INSTALL.md` for `--update` semantics.
2. Re-copies `.claude/agents/`, `.claude/commands/`, `.claude/rules/`, `.claude/hooks/`,
   `.claude/templates/` — but never `.claude/project.json`.
3. Diffs the local `CLAUDE.md` against the latest template — shows the user
   any structural changes and asks before applying.
4. Done.

---

## 9. Locked decisions

- **Source of truth:** Lifeteen's `.claude/` is primary. Cherry-pick from Expense
  and Product-prototype yielded nothing universal (Expense is older patterns;
  Prototype is OakNorth-employer-specific HTML prototyping).
- **`pact-designer`:** kept (Figma MCP, harmless if unconfigured).
- **No strict/lite mode.** One framework. Users delete what they don't want.
- **PRD template:** English only.
- **No language rule file.** User-facing language lives in `project.json`,
  referenced from `CLAUDE.md` orchestrator.
- **No versioned-artifacts rule.** Git already tracks artifact history.
- **Final anatomy of `.claude/`:**
  - `agents/`: 7 PACT agents
  - `commands/`: pact-start, daily-sync, run-tests, deploy-staging
  - `rules/`: async-questions, context-management, quality-gates,
    full-stack-awareness (conditional), deployment-checklist (conditional)
  - `hooks/`: protect-sensitive.sh, post-edit.sh, end-of-turn.sh
  - `templates/`: prd-template.md (English)

---

## 10. Acceptance criteria

This design is "done" when:

- [ ] User can clone sr-pipeline, run one Claude command, and get a working
  framework in their project in under 3 minutes.
- [ ] No file in `.claude/` references a specific tech stack by name.
- [ ] All project-specific values live in one file (`project.json`).
- [ ] Re-running install is safe (idempotent).
- [ ] `--update` doesn't clobber project customizations.
- [ ] Skipping irrelevant pieces (no FE, no DB) leaves a clean install — no
  dead references to missing things.
