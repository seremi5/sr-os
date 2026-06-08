# Full-Stack Awareness Rules

Every agent working on this codebase MUST consider the entire stack when making changes.

This rule applies when the project has more than one layer (e.g., backend + frontend, or app + database). For single-layer projects, this rule is moot — install removes it.

## Cross-Stack Impact Rules

- **Database changes** → Require migration scripts for ALL environments (local, staging, production)
- **Backend changes** → Check if frontend needs corresponding updates (UI, validation, error messages)
- **Frontend changes** → Verify backend API contracts are met
- **Schema changes** → Update validators, types, and UI to match

## Verification Checklist Before Marking Done

### For Backend Changes:
1. Migration scripts created and tested locally
2. Migration commands documented for staging/production
3. API error responses have user-friendly messages in the project's user-facing language
4. Frontend displays appropriate messages for all error codes
5. All environments have required schema changes

### For Frontend Changes:
1. UI reflects current backend validation rules (min lengths, required fields, etc.)
2. Error messages match backend error codes
3. Loading, error, and empty states handled
4. Accessibility maintained
5. Mobile layout tested (if mobile is in scope)

### For Security Changes:
1. Backend validation implemented
2. Frontend validation matches backend (don't show outdated requirements)
3. Error messages are user-friendly in the project's language
4. All affected user flows tested

## Consistency Requirements

- **Validation rules**: If backend requires a field, frontend MUST reflect that requirement
- **Error codes**: Backend error codes MUST have corresponding frontend UI handling
- **Database columns**: New columns MUST be added to ALL environments before deployment
- **Language**: ALL user-facing text in the project's user-facing language

## The Five Questions Before Saying Done

1. "If I were a user, would I see the correct behaviour?"
2. "Did I update ALL places that reference this feature?"
3. "Did I check every layer (DB / BE / FE) for consistency?"
4. "Are there any hardcoded values that need updating?"
5. "Did I provide the user with manual testing steps?"

## Completion Report Format

When finishing any task, provide:
1. **What changed**: list all files modified
2. **What to test manually**: step-by-step user flows
3. **Expected behaviour**: what the user should see
4. **Potential issues**: known edge cases or limitations
