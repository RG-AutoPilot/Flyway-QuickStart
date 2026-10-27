# Flyway Setup Sandbox

A pre-made Flyway Enterprise project for SQL Server, with an AI-guided setup. It takes you from "I have a database" to a working Flyway project (schema model, baseline, generated migration, pipelines) on **your own sandbox databases**, without needing to know the tricky parts of setting Flyway up.

> **This is a sandbox for building and testing Flyway. It is not a production setup.** Use copies of your databases, never production itself.

## What you get

- `flyway.toml` with sensible settings, and **no environments yet**
- CI/CD pipelines for GitHub Actions (`.github/workflows/`) and Azure DevOps (`AzureDevOps/`)
- Code-analysis rules (`Rules/`, `sqlfluff.cfg`), a compare filter (`Filter.scpf`) and a tSQLt test project (`UnitTests/`)
- The Flyway MCP server registered for AI tools (`.mcp.json`)
- A reference library for your AI assistant (`Documentation/FlywayAIDump/`)
- A setup skill (`.claude/skills/flyway-setup/SKILL.md`) that walks you through it

Left empty on purpose: the schema model, migrations and database connections. Your assistant builds those with you.

## Get started

1. Clone this repo.
2. Open the folder in your AI tool (Claude Code, Copilot, Gemini CLI, Kiro and others). Approve the project's Flyway MCP server when asked.
3. Say **"start"** (or "set up Flyway").

The assistant then:

1. greets you and answers any questions
2. checks your setup (Flyway, the MCP server, Git)
3. helps you get a source database with real tables in it, and agree names for Dev, Test, Prod and Flyway's scratch databases
4. updates `flyway.toml` with your environments
5. asks a few quick preferences (existence checks, objects to ignore)
6. creates the schema model from your development database
7. sets the baseline with Backup as Baseline (you run the SQL; the assistant explains it)
8. proves it works by generating a migration
9. points you at Flyway Desktop to try it yourself
10. updates the pipelines to match your environments
11. stays around for tweaks

Progress and decisions are kept in `Documentation/project-profile.md`, so you can stop and pick up later.

## Prerequisites

- Flyway Enterprise (licence), Flyway CLI and, for the Desktop step, Flyway Desktop
- A SQL Server you can create and wipe databases on
- Git, and an AI tool that can run the Flyway MCP server
- For pipelines: a GitHub (or Azure DevOps) repo and a self-hosted runner that can reach your SQL Server

## Moving to real use

When you're ready for real, don't promote this sandbox. Build the real project with your DBAs, approvals and security review. The library's design mode (file 28), proof-of-concept plan (file 05) and audit and data-policy files (03, 17, 18) are the place to start.
