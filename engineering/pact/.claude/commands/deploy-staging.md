---
description: Run the staging deployment checklist and deploy the current branch to staging
---

I'm deploying to staging. Please walk me through the deployment checklist.

Reference: `@.claude/rules/deployment-checklist.md`

Read `.claude/project.json` to confirm the deployment configuration:
```bash
jq -r '.deployment' .claude/project.json
```

If `deployment.branch_strategy` is not set or the project has no staging environment, surface this and stop — production-only projects need a different flow.

Steps to follow:
1. Confirm all tests pass locally (use `/run-tests`)
2. Confirm no `.env` files are staged (`git diff --cached --name-only | grep -E '\.env'`)
3. Show the git commands to merge the current branch to `staging` and push
4. Remind me what to verify in staging after deployment (per `deployment-checklist.md`)
5. Ask me to confirm staging is working before suggesting production deployment
