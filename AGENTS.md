# Flyway sandbox setup

This repository is a pre-made **Flyway Enterprise sandbox project for SQL Server**. It exists to help someone build and test Flyway against their own databases quickly. It is **not** a production setup. Push back whenever the conversation drifts toward real production databases, real customer data or real deployments.

## What to do when a user opens this repo

1. Read `.claude/skills/flyway-setup/SKILL.md` and follow it. It is the playbook for the whole setup (12 steps), and it works for any AI tool: if your tool has no skills feature, treat that file as your instructions.
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
- Use the Flyway MCP server and CLI only against the `development` and `shadow` environments. Never run `migrate`, `clean`, `repair`, `undo` or `baseline` against Test, QA or Prod yourself. Never run `repair`.
- Never hand-write or edit migrations: Flyway generates them from the schema model. Applied migrations are immutable.
- Prefer Backup as Baseline over a baseline script; fall back to a baseline script only when Backup as Baseline isn't possible (for example some Azure SQL Managed Instance setups).
- Never invent a command, flag, TOML key or URL. If the library and docs.red-gate.com don't cover it, say so. Label preview features as preview (the Flyway MCP server is preview).
- Answer in the user's language; keep commands, keys, file names and error text in English.
