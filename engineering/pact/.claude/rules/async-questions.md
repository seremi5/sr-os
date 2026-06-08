# Async Question Handling

Agents NEVER stop work to ask a clarifying question mid-task. Instead, questions are queued and resolved at the next sync point.

## The Pattern

When you hit an ambiguity:
1. Make the most reasonable assumption you can based on existing patterns in the codebase
2. Log the question in `QUESTIONS.md` at the project root
3. Continue working on everything that doesn't depend on the answer
4. Mark clearly in your code/docs where the assumption was applied

## When to Queue vs When to Truly Block

**Queue the question and continue if:**
- The answer is a preference or style choice
- You can make a reasonable assumption and easily reverse it later
- The ambiguity affects one isolated part of the work

**Truly block (stop and surface immediately) only if:**
- You cannot proceed at all without the answer
- Making the wrong assumption would cause data loss or security issues
- The decision would require rewriting more than 50% of the work done so far

## QUESTIONS.md Format

```md
## [Date] — [Agent Name]

### Q1: [Short question title]
**Context:** What you were trying to do and why the question arose
**Question:** The specific question
**My assumption:** What you assumed in order to continue
**Where applied:** Which files/functions use this assumption
**Blocking remaining work:** Yes / No / Partially
```

## For the Orchestrator

- Check `QUESTIONS.md` at the start of every session
- Run `/daily-sync` to review and resolve all pending questions
- After resolving, instruct the relevant agent to revisit the assumption if it was wrong
- Archive resolved questions by moving them to `QUESTIONS_RESOLVED.md`
