---
name: flyway-setup
description: Guided setup of a Flyway project on the user's own SQL Server, Oracle, PostgreSQL or MySQL database, starting from a dataless (structure-only) backup (Backup as Baseline on SQL Server, a Data Pump dump on Oracle, a schema-only dump plus a Flyway-written baseline script on PostgreSQL and MySQL), then hands-on tests of deploy, check, drift and undo. Use when the user says "start", "get started", "set up Flyway", "next" or "where am I", or asks to continue the setup.
---

# Flyway sandbox setup

Goal: someone new to Flyway sets up a Flyway project on **their own database**, using a **backup as the baseline**. Then they deploy, check, catch drift and roll back a change themselves. About an hour. The shape follows Redgate's Flyway AutoPilot (Backup & Running) and POC checklist, cut to the minimum. All rules in `AGENTS.md` apply throughout.

How it fits together (explain only when it helps):
- A dataless backup of their database (structure only, no data) is the **baseline**: the starting point Flyway builds on.
- Dev, Test and Prod are restored from it, so they start identical.
- Shadow, Check and Build are scratch databases. Flyway restores them from the same backup whenever it needs a clean start.
- Their changes in Dev become migrations on top of the baseline.

## Detect state first

Read `Documentation/project-profile.md`, the `[environments.*]` in `flyway.toml`, `schema-model/` and `migrations/`.
- Fresh: go to Welcome.
- Partway: welcome them back, say in one line what's done and what's next, ask to carry on.
- Invoked again mid-conversation: continue from the last unanswered question. Don't greet again.

Never call a step done because a file exists. At the end of each phase, update `project-profile.md`: edit rows in place, record true facts only, no secrets.

**PowerShell:** wrap every Flyway argument that contains a dot in double quotes (`"-diff.source=development"`), or Windows PowerShell splits it. Run commands from this project folder.

## 1. Welcome

Short and warm. Cover:
- We'll set up Flyway on a copy of **your own database's structure** (no data), on a server you control. Nothing touches your real databases.
- By the end, you'll have a Flyway project and a migration Flyway wrote for you. You'll also have deployed it, checked it, caught drift and rolled it back yourself. A pipeline is an optional extra.
- Progress is saved, so you can stop any time.

Ask: "Any questions before we start, or ready to go? (Ask away, or say *ready*.)" Don't mention pipelines again until the end.

## 2. Check Flyway (quietly)

Say you're checking Flyway is installed, then run `flyway --version`.
- **Not found:** ask them to run this in PowerShell in this folder. It installs the Flyway CLI to `C:\FlywayCLI` for their user. Then restart the terminal and the AI tool:
  `$env:FLYWAY_PATH_LOCATION='User'; .\Scripts\Flyway_DownloadAndInstallCLI.ps1`
- **Says Community, or asks to sign in:** they run `flyway auth -IAgreeToTheEula`. It opens a browser to sign in with the Redgate account that holds their Enterprise licence. Backup as Baseline needs Enterprise (library file 04).
- **Complains about a setting in `flyway.toml`:** their Flyway is too old. They update it. Don't edit the file.

Suggest Flyway Desktop if they don't have it (https://documentation.red-gate.com/fd/installers-172490864.html). It's needed for SQL logins and handy for trying things in a UI. If everything's fine, just say "Flyway's installed and ready" and move on.

## 3. About your database (one question per message)

Accept bundled answers and skip anything already answered.

1. **Platform:** "Which platform is your database on?
   1. SQL Server (default), including Azure SQL, Amazon RDS and Google Cloud
   2. Oracle, including Autonomous Database, RAC/Exadata and Amazon RDS
   3. PostgreSQL or compatible: Aurora, Azure, Google Cloud, Amazon RDS, EnterpriseDB, YugabyteDB, TimescaleDB, CockroachDB, Aurora DSQL
   4. MySQL or compatible: MariaDB, Aurora, Azure, Google Cloud, Amazon RDS, Percona, SkySQL, SingleStore, TiDB, OceanBase
   5. Data warehouse or analytics: Snowflake, Databricks, Redshift, BigQuery, Azure Synapse, Microsoft Fabric, ClickHouse
   6. Another relational database: Db2 (LUW or z/OS), SAP HANA, Sybase ASE, Informix, Firebird, Google Cloud Spanner, SQLite, H2, HSQLDB, Derby, Ignite
   7. NoSQL: MongoDB or Atlas, Amazon DocumentDB, Cassandra, Couchbase"
   - **1:** carry on.
   - **2:** also read `oracle.md` in this folder and follow it alongside these steps.
   - **3 or 4:** also read `postgresql-mysql.md` in this folder and follow it alongside these steps; it replaces parts of steps 3 to 7. On EnterpriseDB Extended Server, say first that Flyway's support there is preview. CockroachDB, Aurora DSQL, SingleStore, TiDB and OceanBase are Foundational only, so treat them as 5 to 7.
   - **5 to 7:** if it isn't clear which product, ask. Then say kindly that this sandbox's guided setup covers SQL Server, Oracle, PostgreSQL and MySQL, and tell them what Flyway offers on theirs, per Redgate's supported databases page (https://documentation.red-gate.com/flyway/getting-started-with-flyway/system-requirements/supported-databases-and-versions; check their version there):
     - **Advanced** (Flyway compares databases and writes the migrations, plus checks and drift): Snowflake and Databricks. Preview: Couchbase. In development: Fabric SQL Database.
     - **Foundational only** (Flyway deploys migrations that people write; it doesn't write them or catch drift): everything else on the list.

     Offer two ways on: their Redgate SE can set up a proof of concept on their platform, or they learn the workflows here first on a free SQL Server Developer Edition with a sample database, since the ideas carry over. For the second, record the platform as "SQL Server, for learning (real platform: <theirs>)" and use option 4 under "Your database".
2. **Sandbox server:** "Which SQL Server should the sandbox databases go on? Pick one where you're an administrator and can create and delete databases. SQL Server Developer Edition on your own machine is ideal, and free; a dev/test server is fine too. Never production. What's its name, and do you sign in with Windows or a SQL login?" Note the kind. Azure SQL Database and Managed Instance can't back up to disk, so use "If a backup isn't possible" at the end. Amazon RDS and Google Cloud SQL don't give the sysadmin rights the script needs, so suggest Developer Edition on their own machine, with a backup of their database (option 3 below).
3. **Your database:** "Which existing database should the sandbox start from? It's only the source: Flyway reads its structure once and never changes it. The setup copies that structure, never the data, into a new **Dev** database: the development database, where you make changes and Flyway picks them up. How shall we bring it in?
   1. It's already on that server
   2. I have a backup file (`.bak`) of it
   3. It's on another server
   4. I'd rather use a sample database"
   - **1:** ask for its name, calling it the source database, never the dev database. For example: "What's the name of the database to copy from? It's only read. Your dev database will be a new copy of it."
   - **2:** ask for the full path of the `.bak` as the sandbox server sees it. That means a folder on that server, not their PC, unless their PC is the server. The server's default backup folder always works.
   - **3:** they back it up the usual way (in SSMS: right-click the database, Tasks, Back Up), or ask their DBA. Then they copy the `.bak` to a folder on the sandbox server and continue as in 2. If the data is sensitive, a DBA can make a dataless backup on the source server instead, following Redgate's guide (https://documentation.red-gate.com/flyway/learn-more-about-flyway/how-to-articles/use-a-sql-server-backup-to-baseline-a-database). The script treats it the same.
   - **4:** they download a sample `.bak` (AdventureWorks or Chinook), then continue as in 2.

   It must have real tables. Never create an empty Dev database.
4. **Size:** "Is it large or complex? For example thousands of objects, several filegroups, or references to other databases or linked servers. (1 yes, 2 no, 3 not sure)" Backup as Baseline handles both; it's built for this. Use the answer to set expectations:
   - **Large:** copying and restoring take longer.
   - **Complex:** after the capture, look for objects that depend on other databases or linked servers, and ask whether to leave them out.
   - If they mention a simpler database too, say it makes an easier first run (Redgate's POC advice), but don't push.
5. **Names:** propose `<Name>_Dev`, `_Test`, `_Prod`, `_Shadow`, `_Check` and `_Build`, and ask whether those are OK. One line each: Dev is the development database, a copy of their source database: developers make changes there, and Flyway reads those changes to write migrations. Test and Prod are pretend deployment targets. Shadow, Check and Build are scratch databases Flyway restores from your baseline.

## 4. Create the sandbox databases (they run it)

Fill in the values at the top of `Scripts/CreateSandboxDatabases.sql`:
- `@SourceDatabase` **or** `@SourceBackupFile`
- `@Prefix`
- `@BaselineBackupFile` (default `<Prefix>_FlywayBaseline.bak`, which lands in the server's default backup folder)

Tell them you did. Then ask them to open it in SSMS or Azure Data Studio, connect to the sandbox server and run it. Explain in a few lines:
- It makes a **dataless backup** of their database: a structure-only copy made with `DBCC CLONEDATABASE`, backed up to a file. That's the baseline Flyway restores whenever it needs a clean starting point. Point them to Redgate's guide to using a backup as a baseline, which this step follows: https://documentation.red-gate.com/flyway/learn-more-about-flyway/how-to-articles/use-a-sql-server-backup-to-baseline-a-database
- It restores the baseline as Dev, Test and Prod, and creates empty Shadow, Check and Build.
- Starting from a `.bak` with data, it restores that temporarily, copies the structure, then drops it.
- It never changes their database or backup file, and never overwrites an existing database.

Ask them to say *done* and paste the baseline path it prints, or the error. If it fails, start with the simplest cause:
- **Needs sysadmin:** use a server where they're an administrator, or a DBA runs it.
- **Can't read the `.bak`:** it must be in a folder on the server that the SQL Server service account can read.
- **"Cannot open backup device" on the baseline:** use a file name alone, or a folder the service account can write to.
- **Backup from a newer SQL Server version:** they need a sandbox server of the same version or newer.
- **Encrypted (TDE) backup, or not enough disk space for the temporary restore:** ask a DBA for a dataless backup instead.

## 5. Connect Flyway

Say: "I'll add your databases to `flyway.toml` so Flyway knows where they are." Replace the commented template at the bottom with all six environments in one go, then list what you added. SQL Server URL: `jdbc:sqlserver://<server>;databaseName=<db>;encrypt=optional;integratedSecurity=true;trustServerCertificate=true` (leave out `integratedSecurity=true` for SQL logins).

| Environment | Database | Settings |
|---|---|---|
| `development` | Dev | none |
| `shadow`, `Check`, `Build` | Shadow, Check, Build | `provisioner = "backup"` plus the block below |
| `Test`, `Prod` | Test, Prod | none, ever |

Add this under each of shadow, Check and Build. Use single quotes so Windows paths need no escaping:
```toml
[environments.shadow.resolvers.backup]
backupFilePath = '<the baseline path the script printed>'
backupVersion = "001"
sqlserver.generateWithMove = true
```
Keep these environment names, because the pipelines use them.

**SQL login:** say no passwords go in project files, and ask: "Do you use the same login for all these databases? (1 yes, 2 no)". Then give these steps, in exactly these words:
1. Open **Flyway Desktop** and click **Open project**. Choose this folder (the one containing `flyway.toml`).
2. **Ignore "Start here".** Click **Environments** in the left-hand menu.
3. Click **development**, enter the username and password, and save. If they answered 2, repeat for every environment.

If they answered 1, once development is saved, copy its `user` and `password` lines in `flyway.user.toml` (git-ignored) under each other environment there. The password line is only a reference to Desktop's secret store. Tell them you did.

## 6. Capture your database (the schema model)

Say: "I'll read your Dev database and save its structure as files in `schema-model/`. It only reads Dev and takes a minute or two." Run:
```powershell
flyway diff model "-diff.source=development" "-diff.target=schemaModel"
```
Summarise in plain words: roughly how many tables, views and procedures, and anything odd (for complex databases, objects that reference other databases or linked servers). Ask: "Does that look right? Anything Flyway should ignore, like another team's schema?" If yes, add it to `Filter.scpf` and run it again. If nothing was captured, Dev has no tables, so go back and fix the source. Never create objects yourself.

(If the Flyway MCP server is connected, you may use its develop-migrations tools for this and step 8 instead.)

## 7. Set the baseline

Explain in one line: "Your baseline backup is the starting point, so Flyway only deploys changes from here on."
1. **Prove Flyway can use the backup.** Say: "I'll ask Flyway to restore your baseline into the Shadow database. It only touches Shadow and takes a minute or two." Run `flyway info -environment=shadow`. It should show Shadow at version 001. If it fails, the usual causes are a `backupFilePath` the SQL Server can't read (it's a path on the server) or a login that can't restore databases. See the troubleshoot skill.
2. **Mark Test and Prod.** They were restored from the same backup, so they're already at the starting point and only need marking. Ask them to run this in PowerShell in this folder, not SSMS. "It records that each database is at the baseline. It changes no tables."
   ```powershell
   flyway baseline -environment=Test -baselineVersion=001
   flyway baseline -environment=Prod -baselineVersion=001
   ```
   When they say *done*, carry on.

## 8. Your first migration

Ask them to make one small, harmless change in **Dev**, such as adding a nullable column or a new table. Offer to write the SQL for them to run. When they say done:
1. **Capture:** run `flyway diff model "-diff.source=development" "-diff.target=schemaModel"` and show the change.
2. **Generate:** say "Flyway now restores the shadow from your baseline, compares it with your schema model, and writes the migration and its undo script. It takes a couple of minutes." Run:
   ```powershell
   flyway diff generate "-diff.source=schemaModel" "-diff.target=migrations" "-diff.buildEnvironment=shadow" "-generate.types=versioned,undo" "-generate.description=<short_name>"
   ```
   If `migrations/` has no `V` scripts yet, add `"-generate.version=002"` so it lands above the baseline (001).
3. **Show** the new `V` and `U` files and explain each in a sentence: "Flyway wrote these, not us."
4. **Self-check:** run `flyway diff "-diff.source=schemaModel" "-diff.target=migrations" "-diff.buildEnvironment=shadow"`. It should find no differences. That proves the baseline plus the migration rebuild Dev's structure. It shows the script runs, not that it's safe at production volume.
5. **Review in Flyway Desktop (optional).** Ask: "Would you like to see this in Flyway Desktop, Redgate's app for Flyway? 1 Open it in Flyway Desktop (default), 2 Install Flyway Desktop first, 3 Not now."
   - **2:** they download and install it from https://documentation.red-gate.com/fd/installers-172490864.html, then open it and sign in with their Redgate account. Never run the installer yourself. When they say *installed*, carry on as 1.
   - **1:** give these steps: open Flyway Desktop, click **Open project** and choose this folder (the one containing `flyway.toml`). Ignore "Start here". In the left-hand menu:
     - **Schema model** compares Dev with the schema model. It should show no new changes, because the change is already captured.
     - **Generate migrations** should show nothing left to generate, because V002 already covers the change. Opening it may rebuild Shadow first; that's expected, because Shadow is scratch.

     Desktop and the command line share this project's files, so they can switch between them at any time. Ask them to say *back* when they've finished looking.
   - **3:** carry on.

If something fails, follow the troubleshoot skill. Common causes: invalid objects, or objects that depend on another database or a filtered object.

## 9. Try the workflows yourself

This is the heart of the proof of concept. The user runs each command in PowerShell in this folder (or the terminal Flyway Desktop opens, or Desktop's UI). Go one at a time: say what it does, they run it and paste the summary, and you explain the result.

Every command that writes a report ends with `; Invoke-Item <report>`, so the report opens in their default browser as soon as Flyway finishes. On macOS use `; open <report>`, and on Linux `; xdg-open <report>`. Do the same for any other report command you give them.
1. **What's pending:** `flyway info -environment=Test`
2. **Pre-deployment report:** `flyway check -changes -drift -code -dryrun -environment=Test "-reportFilename=reports/Test-check.html"; Invoke-Item reports\Test-check.html`. The report opens in their browser. It shows what will change, code-review findings, drift, and the exact SQL that would run. (The first drift check warns that there's no snapshot yet. That's expected.)
3. **Deploy:** `flyway migrate -environment=Test "-migrate.saveSnapshot=true"`, then `flyway info -environment=Test`.
4. **Roll back:** `flyway undo -environment=Test "-undo.saveSnapshot=true"`. `info` now shows the migration as Undone. Then they run step 3 again.
5. **Catch drift:** they make a manual change in the Test database in SSMS (give them a one-line `ALTER TABLE … ADD`). Then they run `flyway check -drift -environment=Test "-reportFilename=reports/Test-drift.html"; Invoke-Item reports\Test-drift.html`, and the report shows the change. Then they remove the change.
6. **Promote:** the report from step 2 for Prod: `flyway check -changes -drift -code -dryrun -environment=Prod "-reportFilename=reports/Prod-check.html"; Invoke-Item reports\Prod-check.html`. Then `flyway migrate -environment=Prod "-migrate.saveSnapshot=true"`.

Optional, if they want more: make two further changes, generate a migration for each, and deploy only one with `"-cherryPick=<version>"`, or stop at a version with `"-target=<version>"`.

Celebrate properly. Then offer the pipeline.

## 10. Pipeline (optional)

Only start this once steps 6 to 9 work. Ask: "Would you like to automate this in a pipeline? 1 GitHub Actions, 2 Azure DevOps, 3 not now." If 3, go to the wrap-up.

The pipeline reads everything from `flyway.toml`, so there's nothing to edit in it. Explain in plain words:
- **Pull request** that changes `migrations/`: restores Build from the baseline, applies every migration, then runs code review and a change report against Test. Nothing is deployed.
- **Merge to `main`:** the same, then a report and deployment to Test, then Prod. Prod waits for approval if they add one.

Files: `.github/workflows/flyway.yml` or `AzureDevOps/flyway-pipeline.yml`. The setup steps are listed at the top of each file. Walk them through those one at a time:
1. Push this folder to a GitHub repo, or to Azure Repos.
2. A self-hosted **Windows** runner (GitHub) or agent (Azure DevOps) on a machine that can reach the database server. With Windows authentication, the runner's service account needs access to the databases and permission to restore the baseline.
3. Secrets `FLYWAY_EMAIL` and `FLYWAY_TOKEN`. The token is a Redgate personal access token; they create and paste it themselves, and you never see it: https://documentation.red-gate.com/flyway/flyway-cli-and-api/tutorials/tutorial-personal-access-tokens. Add `DB_USERNAME` and `DB_PASSWORD` only for SQL logins.
4. Environments `test` and `prod`, with an approval on `prod`.
5. First run: open a pull request with a new migration, and look at the report before merging.

The baseline backup must be readable by the SQL Server the pipeline connects to. On the same server, that's already the case.

## 11. Wrap-up

Congratulate them. Summarise what they have in a few lines: a Flyway project on their own database, a baseline backup, the migrations, what they tested and the pipeline. Update `project-profile.md`. Remind them kindly that this was a sandbox. For real use, they build the project with their DBAs and their Redgate SE, taking the baseline from their real production structure. Offer follow-ups: another change, a filter, reference data tables, a QA stage, or the pipeline if they skipped it.

## If a backup isn't possible (Azure SQL Database or Managed Instance)

Use a baseline script instead and say so in one line: "Your platform can't back up to a file, so Flyway will write the starting point as a SQL script instead." The changes:
- **Step 4:** they create Dev, Test and Prod as copies of their database in their usual way (for example the portal's Copy), plus empty Shadow, Check and Build. Copies include data, so the source must hold nothing sensitive.
- **Step 5:** shadow, Check and Build get `provisioner = "clean"` and no resolver block.
- **Step 7, item 1:** instead, say "I'll write the baseline script into `migrations/`. It only reads Dev." Then run:
  ```powershell
  flyway diff generate "-diff.source=development" "-diff.target=empty" "-generate.types=baseline" "-generate.description=Baseline" "-generate.version=001"
  ```
  Show the `B001…` file and summarise it. If Flyway added a timestamp to its version, use that full version, quoted, in the `baseline` commands. Item 2 is unchanged.

## Commands the user can type

`where am I`, `next`, `back`, `skip`, `problem` (switch to the troubleshoot skill), `more` (fuller detail), `end`.

## Where to look for detail

- Library `Documentation/FlywayAIDump/` (SQL Server): concepts 02, install and licence 04, POC plan 05, baselines and Backup as Baseline 07, developer workflows 08, `flyway.toml` 10, pipelines 11 and 12, checks 13, drift and undo 14, MCP server 20, errors 22 and 23.
- Redgate: Backup as Baseline (https://documentation.red-gate.com/flyway/learn-more-about-flyway/how-to-articles/use-a-sql-server-backup-to-baseline-a-database) and the POC checklist (https://documentation.red-gate.com/fd/poc-checklist-317493040.html).
- Oracle: `oracle.md`. PostgreSQL and MySQL: `postgresql-mysql.md`. Each lists the Redgate pages it relies on.
