# INSTALL.md

This is the runbook Claude follows when the user invokes:

```
claude "install the framework from /tmp/sr-pipeline into this project"
```

(or any equivalent invocation pointing to a clone of this repo).

If you (Claude) are reading this because the user asked you to install sr-pipeline, follow the steps below in order. Do not skip steps. Do not improvise without checking with the user when explicitly instructed to confirm.

---

## Step 0 — Sanity check

Confirm:
1. The current working directory is the user's project root (look for `.git/`, `package.json`, `pyproject.toml`, etc. — if unclear, ask the user).
2. The path the user gave you (e.g. `/tmp/sr-pipeline`) actually contains this `INSTALL.md` and a `.claude/` folder. If not, stop and tell the user.
3. There is no existing `.claude/` folder in the target project. If there is, ask: *"You already have a `.claude/` folder. Should I (a) abort, (b) merge (keep your existing files, add only the missing ones), or (c) overwrite?"*

---

## Step 1 — Gather project information

Auto-detect what you can from the target project, then ask the user to confirm or correct each value. Where auto-detection is empty, ask plainly.

| # | Field | How to detect | Fallback question |
|---|---|---|---|
| 1 | Project name | git remote name, parent dir name | "What's the project name?" |
| 2 | Goal (one line) | — | "In one sentence, what are you building?" |
| 3 | Project shape | infer from folder layout: `backend/` + `frontend/` → `backend-frontend-monorepo`; single `src/` → `single-app`; `*.py` only → `cli-tool`; otherwise `other` | "Project shape: `backend-frontend-monorepo` / `single-app` / `cli-tool` / `other`?" |
| 4 | Backend dir | scan for `backend/`, `server/`, `api/` | "Path to backend code? (or 'none')" |
| 5 | Frontend dir | scan for `frontend/`, `web/`, `client/`, `app/` | "Path to frontend code? (or 'none')" |
| 6 | User-facing language | — | "What language for user-facing copy? (English / Spanish / Catalan / German / …)" |
| 7 | Test command | read `package.json` `scripts.test`, `pyproject.toml`, `Makefile` | "Test command? (e.g. `npm test`, `pytest`)" |
| 8 | Typecheck command | `tsc --noEmit` if TS detected, `mypy .` if Python+mypy, etc. | "Typecheck command? (or 'none')" |
| 9 | Lint command | `eslint .` / `ruff check .` etc. | "Lint command? (or 'none')" |
| 10 | Build command | `package.json` `scripts.build`, etc. | "Build command? (or 'none')" |
| 11 | Dev command | `package.json` `scripts.dev` etc. | "Dev command? (or 'none')" |
| 12 | E2E test command | optional | "E2E test command? (or 'none')" |
| 13 | Frontend hosting | — | "Frontend hosting? (vercel / netlify / cloudflare / none / other)" |
| 14 | Backend hosting | — | "Backend hosting? (railway / fly / render / heroku / none / other)" |
| 15 | Branch strategy | — | "Branch strategy? (`feature -> staging -> main` / `feature -> main` / `none`)" |
| 16 | Stack summary | — | "One-line stack summary, e.g. 'Express+TS+Drizzle+Zod (BE), React+Vite+shadcn (FE)'" |

For "none" answers, pass empty string `""` into the corresponding `project.json` field.

---

## Step 2 — Decide which files to copy

Based on the answers, determine which framework files apply:

| File | Copy when |
|---|---|
| All 7 agents in `.claude/agents/` | Always |
| All 4 commands in `.claude/commands/` | Always |
| `.claude/rules/quality-gates.md` | Always |
| `.claude/rules/context-management.md` | Always |
| `.claude/rules/async-questions.md` | Always |
| `.claude/rules/full-stack-awareness.md` | Only if backend AND frontend dirs are both set |
| `.claude/rules/deployment-checklist.md` | Only if `branch_strategy` is set (not "none") |
| All 3 hooks in `.claude/hooks/` | Always |
| `.claude/settings.json` | Always |
| `.claude/templates/prd-template.md` | Always |

Do NOT copy:
- `INSTALL.md` (this file)
- `INSTALL_DESIGN.md` (design spec, internal)
- `README.md` (sr-pipeline's own README)
- `templates/` directory (those are install-time templates, not runtime)

---

## Step 3 — Copy and write files

1. Create `.claude/` in the target project (and subdirectories: `agents/`, `commands/`, `rules/`, `hooks/`, `templates/`).
2. Copy each applicable file from `<sr-pipeline-path>/.claude/` to the target's `.claude/`.
3. `chmod +x` on each `.sh` file in `.claude/hooks/`.
4. Render `.claude/project.json` from `<sr-pipeline-path>/templates/project.json.template`, substituting all `{{...}}` placeholders with the user's answers.
5. Render `CLAUDE.md` at the project root from `<sr-pipeline-path>/templates/CLAUDE.md.template`. For the conditional rule lines:
   - `{{FULL_STACK_RULE_LINE}}` → `- Full-stack awareness: \`@.claude/rules/full-stack-awareness.md\`` if that rule was copied, else empty string
   - `{{DEPLOYMENT_RULE_LINE}}` → `- Deployment workflow: \`@.claude/rules/deployment-checklist.md\`` if that rule was copied, else empty string
6. Write `.claude/.install-state` recording the sr-pipeline version (or commit SHA), install date, and which optional files were skipped. Format:
   ```json
   {
     "sr_pipeline_version": "<commit sha>",
     "installed_at": "<ISO date>",
     "skipped_files": ["full-stack-awareness.md", ...]
   }
   ```

---

## Step 4 — Verify

Run a quick smoke test:
1. `cat .claude/project.json | jq .` → should be valid JSON.
2. `ls -la .claude/hooks/*.sh` → all three files present and executable.
3. `cat .claude/agents/*.md | head -1` → should not error.
4. If `commands.typecheck` is set: try running it to confirm it works (`eval "$(jq -r '.commands.typecheck' .claude/project.json)"`). Don't worry about errors at this stage — just confirm the command exists in PATH.

---

## Step 5 — Summary

Print a clear summary to the user:

```
✅ sr-pipeline installed.

Installed files:
  .claude/agents/       (7 PACT agents)
  .claude/commands/     (4 slash commands)
  .claude/rules/        (N rules — list which)
  .claude/hooks/        (3 hooks: protect-sensitive, post-edit, end-of-turn)
  .claude/templates/    (PRD template)
  .claude/settings.json (hook wiring)
  .claude/project.json  (your project's runtime config)
  CLAUDE.md             (orchestrator system prompt)

Skipped:
  - <list any conditional files that were skipped>

Next steps:
  1. Restart Claude Code so hooks pick up.
  2. Try: /pact-start "build a simple hello-world endpoint"
  3. Edit .claude/project.json any time to change commands/paths.
  4. Edit CLAUDE.md to refine the project-specific orchestrator brief.
```

---

## Update mode

If the user invokes:
```
claude "update the framework from /tmp/sr-pipeline"
```

Follow the same steps as install with these differences:
1. Skip Step 1 (no questions).
2. In Step 3: re-copy `agents/`, `commands/`, `rules/`, `hooks/`, `templates/`, and `settings.json`. **Never overwrite `project.json`. Never overwrite `CLAUDE.md`.**
3. For `CLAUDE.md`: diff the existing one against the latest template (filled with the existing `project.json` values). Show the user any *structural* changes (new sections, renamed sections). Ask before applying.
4. Update `.claude/.install-state` with the new version SHA.

---

## Edge cases

- **`jq` not installed:** detect with `command -v jq`. If missing, install it via the system package manager (`brew install jq` on macOS) or warn the user that hooks won't work without it.
- **No git repo in target:** still install. Hooks don't depend on git. Just warn the user that without git, history-based features (deployment checklist) are less useful.
- **User on Windows (no WSL):** the bash hooks won't run. Detect this with `[[ "$OSTYPE" == "msys" ]] || ...` style. If detected, install everything except `.claude/hooks/` and `.claude/settings.json`, and warn the user.
- **Install fails halfway:** `.claude/.install-state` lets a re-run pick up where it left off. If the file lists `partial: true` and lists which files were copied, skip those on retry.
