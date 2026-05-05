# Context Management

Long sessions accumulate context. These rules keep the main orchestrator session lean.

## Sub-Agent Return Format

ALWAYS instruct sub-agents to return a concise summary only:
- What was done (1–2 sentences)
- Which files were created or modified (list)
- What to test manually (2–3 steps)

Full implementation detail lives in the files. It does not need to come back into the orchestrator's context.

## Phase Boundaries

- Run `/compact` between phases — do not wait for auto-compression
- For long PACT cycles, start a fresh session at each phase boundary
- The previous phase's output lives in `docs/` — point the next agent at those files with `@` references, do not summarise them into the conversation

## The @ Reference Pattern

Instead of asking agents to explain things back:
- ✅ "Read `@docs/architecture/01_system_architecture.md` and implement..."
- ❌ "Based on what the architect told us, implement..."

The first uses zero tokens in the main context until the agent actually needs it. The second copies everything into the conversation.

## Teams vs Single Session

For long or parallel workstreams, Claude Code Teams gives each specialist its own fresh context window. Each instance reads from and writes to the shared task list without accumulating each other's context. Consider Teams when:
- A single PACT cycle is consistently hitting context limits
- Two features need to be developed simultaneously
- Combined with worktrees for fully isolated parallel execution
