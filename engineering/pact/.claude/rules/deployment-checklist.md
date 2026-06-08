# Deployment Workflow

ALWAYS follow the staging-first deployment workflow. NEVER deploy directly to production.

This rule is installed only when `.claude/project.json` → `deployment.branch_strategy` is set. For projects with no staging, the deploy flow is project-specific and lives elsewhere.

## Environments

Read from `.claude/project.json`:
```bash
jq -r '.deployment' .claude/project.json
```

Typical setup: `staging` and `main` branches map to platform environments.

## Deployment Steps

### 1. Development
- Work on a feature branch locally
- Test all changes locally
- Commit with descriptive messages

### 2. Staging (REQUIRED before production)
```bash
git checkout staging
git merge feature-branch
git push origin staging
```
After pushing, verify in staging:
- All functionality works end-to-end
- Check platform logs for errors (backend & frontend)
- Test against the staging database
- Ensure no auth, CORS, or routing errors

### 3. Production (only after staging passes)
```bash
git checkout main
git merge staging
git push origin main
```
After pushing:
- Monitor production logs
- Smoke-test the critical flows
- Verify any database migrations were applied correctly

## NEVER

- NEVER push directly to `main` without going through `staging` first
- NEVER use schema-push tools (`drizzle-kit push`, `prisma db push`, etc.) against staging or production databases
- NEVER commit `.env` files
- NEVER deploy without running the test suite first

## Database Migrations in Production

Migrations must be run manually via the platform's shell or migration scripts. Document every migration command in the deployment PR description.
