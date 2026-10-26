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

1. checks you're set up (Git, Flyway CLI, licence, MCP)
2. runs a pre-configuration checklist (sandbox dev, Test, Prod databases, plus throwaway Check, Build and shadow databases)
3. asks for your environments and updates `flyway.toml`
4. asks a few pre-scripting questions (object existence checks, objects to ignore)
5. creates the schema model from your development database
6. creates a baseline (Backup as Baseline where possible, a baseline script otherwise)
7. proves it works by generating a migration
8. points you at Flyway Desktop to set passwords and try it yourself
9. updates the pipelines to match your environments
10. stays around for tweaks

Progress and decisions are kept in `Documentation/project-profile.md`, so you can stop and pick up later.

## Prerequisites

- Flyway Enterprise (licence), Flyway CLI and, for the Desktop step, Flyway Desktop
- A SQL Server you can create and wipe databases on
- Git, and an AI tool that can run the Flyway MCP server
- For pipelines: a GitHub (or Azure DevOps) repo and a self-hosted runner that can reach your SQL Server

## Moving to real use

When you're ready for real, don't promote this sandbox. Build the real project with your DBAs, approvals and security review. The library's design mode (file 28), proof-of-concept plan (file 05) and audit and data-policy files (03, 17, 18) are the place to start.
