---
name: flyway-troubleshoot
description: Diagnose a Flyway problem in this sandbox project and, if it can't be fixed quickly, write a clean support report the user can send to their Redgate SE or Support. Use when something fails, errors, hangs or looks wrong, when a setup step has failed twice, or when the user says "problem", "it broke", "error", "stuck", "not working", "help me fix this" or "write this up for my SE".
---

# Flyway troubleshoot skill

You help someone work out why something in their **sandbox** Flyway project isn't working. Either you find the cause and they fix it, or you give them a short, safe-to-share report so a Redgate SE or Support can take over. This skill is separate from `flyway-setup` so that setup stays a calm guided flow and this one can be methodical.

## Ground rules

1. **All the rules in `AGENTS.md` and the `flyway-setup` skill still apply.** In particular:
   - Diagnose read-only. Never run `migrate`, `clean`, `repair`, `undo` or `baseline` yourself, and never suggest `clean` as a fix. Never run `repair`; if one might be needed, explain what it changes and let the user decide.
   - Never run SQL against their databases. Give them a script, explain it, and ask for the result (error text, never data).
   - Never ask for, echo or store passwords, tokens or permit files.
   - Never use `flyway testConnection`. To see whether a connection works, load the project through the Flyway MCP server or use `flyway info` on `development` or `shadow`. **Library file 23 mentions `testConnection`; ignore that line here.**
   - Say in plain words what a command or tool call does before you run it.
2. **Simplest likely cause first** (rule 11 of `flyway-setup`): wrong folder, old Flyway, signed out, MCP not approved, a typo in a database name, a login that can't create databases.
3. **Calm and clear.** The user is probably already stuck. One question per message, say what you're checking and why, and end with exactly what to reply.
4. **Two attempts, then stop.** If a fix hasn't worked after two tries, stop trying variations and go to "Hand over". Don't keep guessing.
5. **Never invent** a flag, TOML key, error name or fix. If the library and docs.red-gate.com don't cover it, say so.

## Method

1. **Collect the five facts** (library file 23, section 1). Take what you can from the conversation and from read-only checks first, then ask only for what's missing, one at a time:
   1. The exact error text, copied (no data, no passwords).
   2. The exact command, tool call or Desktop page and button that produced it.
   3. Where it ran (this machine, Desktop, a pipeline run).
   4. `flyway version` from that same place. If it says Community, licensing is the problem whatever the error says.
   5. Whether it worked anywhere else (SSMS, another machine, an earlier step).
2. **Route by symptom** and open the file, don't answer from memory:

   | Symptom | Go to |
   |---|---|
   | `migrate`, `validate`, checksum, ignored or failed migration, baseline mismatch, drift | Library file 22 (match the scenario card) |
   | Install, sign-in, licence, Git, Desktop, proxy, SQL Server connection, runner | Library file 23 |
   | Backup as Baseline, baseline script, restore, existing databases | Library file 07 |
   | `flyway.toml`, environments, filters, shadow database, secrets | Library file 10 |
   | Flyway MCP server not responding or tools missing | Library file 20, section 7 |
   | `flyway version` complains about a parameter in `flyway.toml` | Their Flyway is too old for this project. Don't edit `flyway.toml`. Update Flyway (`Scripts/Flyway_DownloadAndInstallCLI.ps1` or the Redgate installer, file 04) and re-check |
   | Pipeline or workflow failure | Library files 11, 12 and 13 |
   | A limit or "can Flyway do X?" | Library file 24 |

3. **Match, check, fix.** Find the matching row or card, run its read-only check, and give the fix. Explain it in a sentence. If the fix is something they have to run (a script, a command, a Desktop click), give it to them and ask them to say when it's done.
4. **Verify.** Ask for the same check again to confirm it worked. Never say it's fixed because a command ran.
5. **Go back.** If this came from setup, say what was fixed and return to where they were: "Shall we pick up where we left off?" and carry on the setup flow.

## Hand over (when it isn't fixed, or they asked for a report)

Write one report as a copyable block in chat. Remove everything that identifies the environment before you show it: no passwords, tokens, permit contents, server names, database names or schema names (use `<server>`, `<dev-db>` and so on), and no table data. Tell the user you've done that, and ask them to glance over it before sending.

```
Flyway support report
What I was trying to do: <one sentence>
What happened: <one or two sentences>
Exact command / tool / Desktop action: <...>
Error text (redacted): <...>
flyway version: <output>
Desktop version: <if relevant, else n/a>
SQL Server kind and version: <local, Azure SQL MI, Azure SQL DB, version>
Where it ran: <this machine / Desktop / pipeline>
Worked elsewhere?: <yes/no, where>
Already tried: <the one or two fixes and what happened>
Last 20 lines of output (redacted, -X if available): <...>
```

- If they want it saved, write it to `support-report.md` in the project root. It's git-ignored, so it won't be committed by accident.
- Say where to send it: their Redgate SE, or Redgate Support (https://productsupport.red-gate.com/). Include the `check` report file only if a `check` was involved. Never send data.
- Record the unresolved issue as one short line under "Decision log" in `Documentation/project-profile.md`, only if the user wants it kept.
- Remind them once, kindly, that the sandbox is safe to carry on with in the meantime, and offer to continue with any step that doesn't depend on the problem.

## Commands the user can type

`where am I` (what's failing, what's been tried), `report` (write the support report now), `back` (return to setup), `end`.
