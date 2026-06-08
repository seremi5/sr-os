# Quality Gates

Minimum standards that must pass before any phase is considered complete.

Project-specific commands (typecheck, test, lint, build) are read from
`.claude/project.json`. If a command is empty for this project, the
corresponding gate is skipped.

## Design Phase (before Architect, for UI features)

- Design PRD saved in `docs/design/`
- **Wireframes created in Figma** — no ASCII art, always a Figma URL
- User journey documented per section (why does this section exist?)
- Existing design system component reuse identified vs custom components needed
- Open questions listed before handing off to pact-architect

## Prepare Phase

- Requirements clearly documented in a markdown file in `docs/preparation/`
- All relevant existing code read and understood
- No ambiguities that would block architecture decisions

## Architect Phase

- Architecture document saved in `docs/architecture/` or appropriate subfolder
- Includes: data model, API endpoints, frontend component plan, migration plan
- All cross-stack impacts identified
- Reviewed for consistency with existing patterns

## Code Phase

For each layer that exists in the project:

- Backend tests pass: `jq -r '.commands.test' .claude/project.json`
- Frontend tests pass (if separate test command)
- Lint clean: `jq -r '.commands.lint' .claude/project.json`
- Typecheck passes: `jq -r '.commands.typecheck' .claude/project.json`
- No `.env` files modified (the `protect-sensitive` hook enforces this)
- All user-facing text in the project's `language.user_facing`

## Test Phase

- All existing tests still pass (no regressions)
- New tests cover: happy path, validation errors, auth failures, not-found cases
- E2E tests pass for affected user flows (if `commands.test_e2e` is set)
- Manual testing steps documented for the user

## Deployment Gate

- All code phase gates passed
- Changes deployed and verified on staging (if `deployment.branch_strategy`
  includes a staging step)
- No errors in staging logs
- Only then: promote to production
