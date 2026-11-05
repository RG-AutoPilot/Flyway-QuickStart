# Project profile and decision log

The setup skill (`.claude/skills/flyway-setup/SKILL.md`) fills this in as you go, so the setup survives a restart and the assistant knows your choices. Newest decisions first in the log. Roles, not people. **Never put passwords, tokens or data here.** This file is committed to Git.

## Setup progress

| Step | Status | Notes |
|---|---|---|
| Welcome and questions | not started | |
| Quick checks (Flyway, MCP, Git) | not started | |
| Groundwork (server, source database, names) | not started | |
| Connecting Flyway (environments) | not started | |
| Quick preferences | not started | |
| Schema model | not started | |
| Baseline (Backup as Baseline) | not started | |
| Generate and test a migration | not started | |
| Trying it in Flyway Desktop | not started | |
| Pipelines | not started | |
| Wrap-up and personalise | not started | |

## Setup choices

| Question | Answer |
|---|---|
| AI tool | |
| Pipeline platform (GitHub Actions / Azure DevOps) | |
| SQL Server platform (on-premises / Azure SQL Database / Azure SQL MI) | |
| Environments (names, in promotion order) | development, Test, Prod |
| Extra stage (QA)? | no |
| Authentication (Windows / SQL) | |
| Source database (own copy / sample) | |
| Baseline method (Backup as Baseline / baseline script) | |
| Baseline backup (taken from the Prod database) and file location | |
| Baseline version | |
| Object existence checks | |
| Filtered objects or schemas | |
| Static data tables | |
| Schemas covered | dbo |
| Runner (label) | self-hosted |

## Decision log

Format: `YYYY-MM-DD - Decision - Why - Owner role - Revisit when`

- (none yet)

## Deferred ("later, after the proof of concept")

- (none yet)
