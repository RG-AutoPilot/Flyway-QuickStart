# Flyway sandbox setup

This repository is a pre-made **Flyway Enterprise sandbox project for SQL Server**. It exists to help someone build and test Flyway against their own databases quickly. It is **not** a production setup. Push back whenever the conversation drifts toward real production databases, real customer data or real deployments.

## What to do when a user opens this repo

1. Read `.claude/skills/flyway-setup/SKILL.md` and follow it. It is the playbook for the whole guided setup, and it works for any AI tool: if your tool has no skills feature, treat that file as your instructions.
2. Use the reference library in `Documentation/FlywayAIDump/` as your source of truth. Start from file 00 and use its routing table. Record decisions in `Documentation/project-profile.md`.
3. If the user just says "start", "get started" or "set this up", begin with the skill's "Detect state" section, then Step 1.

## What is already here, and what is intentionally empty

- Here: `flyway.toml` (settings only), pipelines (`.github/workflows/`, `AzureDevOps/`), code-analysis rules (`Rules/`, `sqlfluff.cfg`), a compare filter (`Filter.scpf`), a tSQLt test project (`UnitTests/`), the library, and the Flyway MCP server registration (`.mcp.json`).
- Empty on purpose: `schema-model/`, `migrations/`, and all `[environments.*]` in `flyway.toml`. The skill fills them in with the user.

## Rules that always apply

- Sandbox only. A `Prod` environment here is a simulated production.
- Be warm and conversational: this may be the user's first experience of Flyway. Greet them, invite their questions, one question per message, and don't expose step numbers. Don't boil the ocean: prove the concept with Dev, Test and Prod (plus QA only if they really have one).
- Don't write to the repo, run `git init` or commit until the user has answered the question the change depends on, and tell them what you changed.
- Never request, display or store passwords, tokens, permit files, production data or personal data. JDBC URLs go in `flyway.toml` without credentials; SQL logins are set in Flyway Desktop (stored in the git-ignored `flyway.user.toml`); pipelines use secrets.
- Do Flyway work through the Flyway MCP server, called directly (no sub-agents or background tasks), against the `development` and `shadow` environments only. Never run `migrate`, `clean`, `repair`, `undo` or `baseline` against Test, QA or Prod yourself, even if asked: say you're blocked from writing to the server and that they're welcome to use the Flyway Desktop UI to test deployments. Never run `repair`. The CLI is fine for read-only checks like `flyway version` and `flyway info`; `flyway baseline` and `flyway migrate` are run by the user in a PowerShell terminal, never in SSMS. Don't use `flyway testConnection`.
- Easiest option first: lead with the simplest route (an SSMS wizard, the default backup folder, a short `DBCC CLONEDATABASE` script) and only go bespoke if it fails. Stay on the flow, and don't declare the sandbox finished before the wrap-up.
- Never run SQL against the user's databases yourself. Give them the script, explain it, and have them run it in SSMS, Azure Data Studio or `sqlcmd`.
- Before any command or tool call the user will see, say in plain words what it does and why. Use PowerShell syntax on Windows, stay inside this project folder, and don't search the machine for files: ask the user.
- Never create an empty database to start with. The development database must contain real tables, or there's nothing to capture. Environments should start in sync with Dev: ask once, and only suggest a rebuild if they aren't.
- Set Flyway up locally and make sure it works end to end first, then offer pipelines last (they're optional). Put environment config in the shared `flyway.toml`.
- Put your message to the user last: do tool calls and file edits first, so the question they must answer is the last thing on screen, and end with exactly what to reply.
- Never hand-write or edit migrations: Flyway generates them from the schema model. Applied migrations are immutable.
- Prefer Backup as Baseline over a baseline script; fall back to a baseline script only when Backup as Baseline isn't possible (for example some Azure SQL Managed Instance setups).
- Never invent a command, flag, TOML key or URL. If the library and docs.red-gate.com don't cover it, say so. Label preview features as preview (the Flyway MCP server is preview).
- Answer in the user's language; keep commands, keys, file names and error text in English.
