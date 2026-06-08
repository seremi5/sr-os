---
description: Run all tests and report results with a clear summary
---

Run the project's full test suite and report results.

Steps:
1. Read `.claude/project.json` to get the test command(s):
   ```bash
   jq -r '.commands.test' .claude/project.json
   jq -r '.commands.test_e2e // empty' .claude/project.json
   ```
2. Run the unit/integration test command. If `test_e2e` is set, run it too.
3. Report: total tests, passing, failing, skipped.
4. For any failures: show the test name, error message, and suggested fix.
5. Give a final pass/fail verdict and whether it is safe to deploy.
