# Flyway Sandbox

Set up Flyway Enterprise on your own database, with a backup as the baseline, guided by the AI assistant you already use. You don't need any Flyway or pipeline experience.

In about an hour you'll have a working Flyway project and a migration that Flyway wrote for you. You'll also have deployed it, checked it, caught drift and rolled it back yourself. A pipeline is an optional extra at the end.

> **Sandbox only.** Use a server where you can create and delete databases, such as your own machine or a dev/test server, never production. The setup copies only your database's structure, no data, into new databases that are used for nothing else.

## Start

1. Clone this repo and open the folder in your AI assistant (GitHub Copilot, Claude Code, Cursor, Gemini CLI, Codex and others).
2. Type **start** in the assistant's chat, not in a terminal. (In PowerShell, `start` is a different command. If you see a `FilePath:` prompt, press Ctrl+C.) For a command-line assistant, launch it first (for example `claude`, `gemini` or `codex`), then type **start** at its prompt.

Your assistant asks one question at a time and writes the configuration. It gives you anything you need to run yourself (a SQL script and a few Flyway commands) and explains each one first. If it doesn't pick up the instructions on its own, say **"Read AGENTS.md and start."**

## You'll need

- Flyway Enterprise and a Redgate account. [Flyway Desktop](https://documentation.red-gate.com/fd/installers-172490864.html) is recommended, and your assistant can help install the Flyway command line.
- Your database, on SQL Server, Oracle, PostgreSQL or MySQL: on the sandbox server already, or as a backup file (`.bak`, a Data Pump dump, or a schema-only dump). A sample such as AdventureWorks works too. On other platforms, the assistant tells you what Flyway supports there.
- A sandbox server where you're an administrator. A free local install is ideal: SQL Server Developer Edition, PostgreSQL or MySQL.
- An AI assistant that can read this folder. If it can't run commands, it gives them to you to run.

## What happens

1. **You answer a few questions:** which server, how to bring in your database (by name or from a backup file), and whether it's large or complex.
2. **You run one script.** It makes a [dataless backup](https://documentation.red-gate.com/flyway/learn-more-about-flyway/how-to-articles/use-a-sql-server-backup-to-baseline-a-database) of your database (structure only, no data) as the baseline, and restores it as Dev, Test and Prod. It also creates scratch databases for Flyway.
3. **The assistant connects Flyway**, captures your schema and proves Flyway can restore your baseline. This is Backup as Baseline on SQL Server, or a Data Pump dump on Oracle (preview). On PostgreSQL, MySQL and Azure SQL, Flyway writes the baseline as a script instead.
4. **You change Dev, and Flyway generates** the migration and its undo script.
5. **You run the workflows:** a pre-deployment report, deploy, undo, catching drift, and promoting to Prod.
6. **Optional:** a GitHub Actions or Azure DevOps pipeline.

The assistant never runs SQL against your databases, never deploys to Test or Prod for you, and never asks for passwords. Progress is saved in `Documentation/project-profile.md`.

## What's in here

| Path | What it is |
|---|---|
| `AGENTS.md` | Instructions your AI assistant reads. `CLAUDE.md`, `GEMINI.md` and `.github/copilot-instructions.md` point to it |
| `.claude/skills/` | The guided setup and troubleshooting playbooks |
| `flyway.toml` | Flyway project settings. Your environments are added during setup |
| `schema-model/`, `migrations/` | Empty until the setup fills them |
| `Scripts/` | The create-databases scripts (SQL Server, PostgreSQL, MySQL), the Flyway CLI installer and a pipeline helper |
| `Rules/`, `sqlfluff.cfg`, `Filter.scpf` | Code-review rules and the comparison filter |
| `.github/workflows/flyway.yml`, `AzureDevOps/flyway-pipeline.yml` | Optional pipelines |
| `Documentation/` | The progress file and a Flyway reference library for your assistant |

## After the sandbox

For real use, build the project with your DBAs and your Redgate contact. Redgate's guides: [POC checklist](https://documentation.red-gate.com/fd/poc-checklist-317493040.html), [POC workflow](https://documentation.red-gate.com/fd/flyway-poc-worfkflow-325421946.html) and [Flyway AutoPilot](https://documentation.red-gate.com/fd/first-steps-flyway-autopilot-a-beginners-guide-254152325.html).
