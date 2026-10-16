# ctf-solver — Claude Code plugin

An agentic toolkit for Jeopardy-style CTFs. Gives Claude Code a triage router, per-category
playbooks, a recon-and-flag-grep core, and a one-shot toolchain installer.

**Flag format:** `flag{...}` by default. Override per challenge: `export FLAG_PREFIX=picoCTF`.

## Install

Copy the `ctf-solver/` folder into a location Claude Code reads plugins from, then enable it.
Quickest route during a competition:

```bash
mkdir -p ~/.claude/plugins
cp -r ctf-solver ~/.claude/plugins/
```

In Claude Code, run `/plugin` and enable **ctf-solver** (or restart so it auto-discovers
`skills/*/SKILL.md`). Confirm with `/help`: you should see the `ctf-recon` and `ctf-solve`
commands. The skills activate on their own when a challenge matches their description.

> Layout follows the standard: manifest at `.claude-plugin/plugin.json`, components
> (`commands/`, `skills/`) at the plugin root.

## One-time setup

```bash
bash ~/.claude/plugins/ctf-solver/scripts/bootstrap.sh
```

Best-effort install of the standard toolchain via apt or brew + pip + gem. Safe to re-run;
it prints which core tools are present or missing at the end.

## Use

- `/ctf-solve <file | url | "nc host port" | description>` — the full solve loop.
- `/ctf-recon <file-or-dir>` — just the recon dump + flag grep.
- Or simply describe or upload a challenge and let `ctf-triage` pick it up and route.

## What clears on its own vs. needs you

Recon plus the easy/medium tier — encodings, metadata/stego, appended files, simple crypto,
string-check reversing — clears largely unattended. Hard pwn / rev / crypto still needs your
judgement: the playbooks give Claude the attack tree and the tools; you steer the hard calls.
Treat it as a strong force-multiplier, not an autopilot.

## Scope

For **authorised CTF competition targets only**. The web and pwn playbooks are scoped to the
organiser's deliberately-vulnerable challenges you are permitted to attack.

## Layout

```
ctf-solver/
├── .claude-plugin/plugin.json
├── commands/   ctf-recon.md   ctf-solve.md
├── skills/     ctf-triage  ctf-crypto  ctf-rev  ctf-pwn  ctf-web  ctf-forensics  ctf-misc
└── scripts/    bootstrap.sh   recon.sh   flaggrep.sh
```
