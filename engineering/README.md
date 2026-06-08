# Engineering — how I build software with AI

> **The engineering layer of the AI OS.** Two toolkits live here:
>
> - **[`pact/`](pact/) — the PACT framework.** Portable Claude Code setup (7 agents Prepare→Architect→Code→Test, hooks, rules, templates) that installs into any project. Start here for *building software* in any stack.
> - **This folder (standards / patterns / template) — the ai-forge pipeline standards.** Python AI-pipeline conventions. Start here when *building a data/AI pipeline* in my style. Everything below is unchanged from ai-forge.

Standards, patterns, and templates I use to build AI pipelines. Every project I ship follows these conventions — and any agent building a new pipeline in my style should start here.

---

## Philosophy

- **Agents do one thing.** Each agent has a single responsibility and a single entry point: `run(...)`.
- **Data flows forward only.** No agent reaches back to modify upstream state.
- **Scoring is not AI.** Quantitative signals are computed deterministically before AI sees them. AI writes analysis, it does not decide scores.
- **Fail fast, fail loudly.** Config is validated at startup. Missing keys produce a clear message in the target language and exit with code 1.
- **Outputs are self-contained.** Reports are single HTML files with no external dependencies beyond CDN fonts.

---

## Pipeline Pattern

Every project follows the same 4-layer structure:

```
CLI entry point  (analyze.py)
    │
    ├─ 1. Data layer     → src/services/
    │       Typed wrappers around external APIs → dataclasses
    │
    ├─ 2. Scoring layer  → src/agents/scorer.py
    │       Pure functions, no AI, reproducible
    │
    ├─ 3. Agent layer    → src/agents/
    │       Multi-agent debate or sequential analysis
    │
    └─ 4. Output layer   → src/agents/report_builder.py
            Self-contained HTML report
```

Details: [patterns/pipeline.md](patterns/pipeline.md)

---

## Multi-Agent Debate Pattern

For decisions that benefit from adversarial analysis:

```
BullAgent    → makes the strongest case FOR
BearAgent    → makes the strongest case AGAINST
SkepticAgent → challenges both cases, surfaces assumptions
JudgeAgent   → synthesizes into a verdict with conviction level
```

No agent sees the others' outputs until their own is complete. The judge receives all three and produces the final synthesis. This prevents anchoring and groupthink.

Details: [patterns/debate.md](patterns/debate.md)

---

## Agent Contract

Every agent module must:

1. Export a single `run(...)` function as its public interface
2. Accept typed inputs (dataclasses, not raw dicts)
3. Return typed outputs
4. Never write to disk or call external APIs directly — use services
5. Log with the shared logger (`info` / `success` / `warn` / `error`)

```python
# Good
def run(data: MarketData, config: ScorerConfig) -> ScoreResult:
    ...

# Bad — raw dict, side effects, direct API call
def run(data: dict) -> dict:
    response = requests.get(...)  # ← belongs in a service
    open("output.json", "w")      # ← belongs in the output layer
```

Details: [standards/agent-contract.md](standards/agent-contract.md)

---

## Config & Secrets

- All secrets live in `.env` (always in `.gitignore`)
- `.env.example` ships with the repo — no real values, safe to share
- `src/config/env.py` validates all required keys at import time
- Missing key → clear error message → `sys.exit(1)`

```python
# src/config/env.py pattern
import os, sys

GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")
if not GEMINI_API_KEY:
    print("Error: GEMINI_API_KEY not set. Copy .env.example to .env and add your key.")
    sys.exit(1)
```

Details: [standards/config.md](standards/config.md)

---

## Error Handling

- **User-facing errors**: human language, actionable message, `sys.exit(1)`
- **Internal errors**: let them propagate — don't swallow exceptions silently
- **External API failures**: retry with backoff in the service layer, not in agents
- **No bare `except:`** — always catch the specific exception

---

## Logging

Use the shared logger from `src/utils/logger.py`. Five levels:

| Method | When to use |
|---|---|
| `logger.step("Fetching data...")` | Starting a named phase |
| `logger.info("Found 42 peers")` | Neutral information |
| `logger.success("Report saved")` | Completed successfully |
| `logger.warn("No insider data")` | Non-fatal, degraded output |
| `logger.error("API key invalid")` | Fatal, about to exit |

No `print()` in agents or services. No debug logging in production.

---

## File Structure

Every new project starts with this layout:

```
analyze.py              ← CLI entry point
.env.example            ← key template
.env                    ← secrets (gitignored)
requirements.txt
src/
  config/
    env.py              ← validates env vars at startup
    constants.py        ← weights, thresholds, labels
  services/
    market_data.py      ← external API wrappers
  agents/
    data_fetcher.py     ← orchestrates data retrieval
    scorer.py           ← quantitative scoring
    analyst.py          ← AI analysis / debate orchestrator
    report_builder.py   ← output generation
  utils/
    logger.py           ← colored terminal logger
    formatters.py       ← display formatting helpers
reports/                ← generated output (gitignored)
```

Template with stubs: [template/](template/)

---

## Starting a New Project

Clone this repo and copy the template:

```bash
cp -r engineering/template/ ../my-new-project
cd ../my-new-project
cp .env.example .env
pip install -r requirements.txt
```

Then implement each layer in order: services → scorer → agents → report builder.

Read [patterns/pipeline.md](patterns/pipeline.md) before writing any agent code.

---

## Quality Checklist

Before declaring a pipeline complete:

- [ ] `python analyze.py <TICKER> --no-browser` runs without errors
- [ ] All outputs appear in the target language
- [ ] No hardcoded values that should come from config
- [ ] `.env` is not tracked by git (`git status` check)
- [ ] Each agent has a single `run(...)` entry point
- [ ] No agent calls external APIs directly — only through services
- [ ] Report opens correctly in browser and all sections populate
