# Flyway Sandbox

Set up Flyway Enterprise on your own database, with a backup as the baseline, guided by the AI assistant you already use. You don't need any Flyway or pipeline experience.

In about an hour you'll have a working Flyway project and a migration that Flyway wrote for you. Then you can try deploying, checking, catching drift and rolling back yourself, and add a pipeline if you like.

Already have a Flyway Enterprise project? Skip the sandbox and go straight to a pipeline for it.

> **Sandbox only.** Use a server where you can create and delete databases, such as your own machine or a dev/test server, never production. The setup copies only your database's structure, no data, into new databases that are used for nothing else.

## Start

1. Clone this repo and open the folder in your AI assistant (GitHub Copilot, Claude Code, Cursor, Gemini CLI, Codex and others).
2. Type **start** in the assistant's chat, not in a terminal. (In PowerShell, `start` is a different command. If you see a `FilePath:` prompt, press Ctrl+C.) For a command-line assistant, launch it first (for example `claude`, `gemini` or `codex`), then type **start** at its prompt.
3. Answer its first question: set up a new sandbox, or go straight to a pipeline for a project you already have.

Your assistant asks one question at a time and writes the configuration. It gives you anything you need to run yourself (a SQL script and a few Flyway commands) and explains each one first. When you've run something, just reply **done**. Paste the output only if something goes wrong. Reports open in your browser by themselves. If the assistant doesn't pick up the instructions on its own, say **"Read AGENTS.md and start."**

Handy replies at any point: **done**, **where am I**, **desktop** (open the project in Flyway Desktop), **pipeline**, **problem** and **end**.

## You'll need

- Flyway Enterprise and a Redgate account. Your assistant can help install the Flyway command line, and can download [Flyway Desktop](https://documentation.red-gate.com/fd/installers-172490864.html) for you and open your project in it.
- Your database, on SQL Server, Oracle, PostgreSQL or MySQL: on the sandbox server already, or as a backup file (`.bak`, a Data Pump dump, or a schema-only dump). A sample such as AdventureWorks works too. On other platforms, the assistant tells you what Flyway supports there.
- A sandbox server where you're an administrator. A free local install is ideal: SQL Server Developer Edition, PostgreSQL or MySQL.
- An AI assistant that can read this folder. If it can't run commands, it gives them to you to run.
- For the optional pipeline: nothing yet. The assistant can help you install GitHub Actions, Azure DevOps, Jenkins or GitLab on your machine, or use the tool your team already has.

## What happens

1. **You answer a few questions:** which server, how to bring in your database (by name or from a backup file), and whether it's large or complex.
2. **You run one script.** It makes a [dataless backup](https://documentation.red-gate.com/flyway/learn-more-about-flyway/how-to-articles/use-a-sql-server-backup-to-baseline-a-database) of your database (structure only, no data) as the baseline, and restores it as Dev, Test and Prod. It also creates scratch databases for Flyway.
3. **The assistant connects Flyway**, captures your schema and proves Flyway can restore your baseline. This is Backup as Baseline on SQL Server, or a Data Pump dump on Oracle (preview). On PostgreSQL, MySQL and Azure SQL, Flyway writes the baseline as a script instead. You mark Test and Prod as starting from the baseline.
4. **You change Dev, and Flyway generates** the migration and its undo script. The assistant checks they rebuild Dev exactly.
5. **You try the workflows** with Redgate's [POC workflow](https://documentation.red-gate.com/fd/flyway-poc-worfkflow-325421946.html): a sequence of commands to deploy, undo, cherry-pick and check for drift. The assistant opens your project in Flyway Desktop, already set up, or downloads Desktop for you first.
6. **Optional: a pipeline.** A basic one builds a report on a scratch Check database (changes, drift, code review and the SQL to run), then deploys each new migration to Test. Prod stays manual. You choose:
   - **Set it up on your machine:** the assistant sets the whole thing up for you, out of the box. It writes the pipeline, prepares the repo and walks you through installing GitHub Actions, Azure DevOps, Jenkins or GitLab.
   - **Use your team's tool:** it fits the pipeline to the tool you already have, including when the pipeline lives in a different repo from the code.

### If you already have a Flyway project

The assistant reads your project's `flyway.toml` (never your passwords) and asks which test environment the pipeline should deploy to. If the report has no scratch database to rebuild, it helps you add one. Then it writes the pipeline into your project, with your environment names. It won't set up deployments to production.

## What the assistant does and doesn't do

- It writes the configuration and pipeline files, and runs Flyway commands that only read Dev or rebuild the scratch Shadow database.
- It never runs SQL against your databases, and never deploys to Test or Prod for you.
- It never asks for passwords or tokens. You enter those in Flyway Desktop or as pipeline secrets.
- It commits only when you agree. You run the installers, register any runner and push your code.

Progress is saved in `Documentation/project-profile.md`, so you can stop and pick up later.

## What's in here

| Path | What it is |
|---|---|
| `AGENTS.md` | Instructions your AI assistant reads. `CLAUDE.md`, `GEMINI.md` and `.github/copilot-instructions.md` point to it |
| `.claude/skills/` | The guided setup and troubleshooting playbooks |
| `flyway.toml` | Flyway project settings. Your environments are added during setup |
| `schema-model/`, `migrations/` | Empty until the setup fills them |
| `Scripts/` | The create-databases scripts (SQL Server, PostgreSQL, MySQL) and the Flyway CLI installer |
| `Rules/`, `sqlfluff.cfg`, `Filter.scpf` | Code-review rules and the comparison filter |
| `pipelines/` | Optional pipelines, one folder per tool, each with a setup guide: GitHub Actions and Azure DevOps (based on Flyway AutoPilot), Jenkins, GitLab, and a script for any other tool |
| `Documentation/` | The progress file and a Flyway reference library for your assistant |
| `reports/`, `backups/` | Created as you go (Flyway reports, schema-only dumps). Git ignores them |

## After the sandbox

For real use, build the project with your DBAs and your Redgate contact. Redgate's guides:
- [POC checklist](https://documentation.red-gate.com/fd/poc-checklist-317493040.html)
- [POC workflow](https://documentation.red-gate.com/fd/flyway-poc-worfkflow-325421946.html)
- [Flyway AutoPilot](https://documentation.red-gate.com/flyway/getting-started-with-flyway/first-steps-flyway-autopilot-a-beginners-guide)
- [Sample pipelines](https://github.com/red-gate/Flyway-Sample-Pipelines)
