---
description: Full agentic solve loop for a single CTF challenge.
argument-hint: <path | url | "nc host port" | description>
---

You are solving one Jeopardy CTF challenge. Target / description: $ARGUMENTS

Flag format: `flag{...}` (override by exporting FLAG_PREFIX before running scripts).

Work this loop. Narrate each step briefly. Stop the instant you have a verified flag.

1. **Triage** — use the `ctf-triage` skill. Collect every input (files, URL, nc
   endpoint, hints, point value) and classify the category.
2. **Recon** — run `${CLAUDE_PLUGIN_ROOT}/scripts/recon.sh` on any files and grep for
   the flag first. A large fraction of challenges end here.
3. **Playbook** — if no flag yet, follow the matching skill (`ctf-crypto`, `ctf-rev`,
   `ctf-pwn`, `ctf-web`, `ctf-forensics`, `ctf-misc`). Work the attack tree cheapest-first.
4. **Iterate** — write scripts to disk, run them, read the output, adapt. Keep a short
   notes file of what you've ruled out so you don't repeat work.
5. **Verify** — a candidate must literally match the flag format. Never fabricate one.
   If stuck, report exactly where and what you'd try next.

Scope: only attack the target this challenge gives you. Steps needing network to the
organiser's remote host are fine — you're on the user's machine, authorised for this
competition.
