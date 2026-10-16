---
name: ctf-web
description: Playbook for CTF web-exploitation challenges against the organiser's provided web target. Use when given a URL / web app and the goal is to recover a flag. For authorised CTF targets only.
---

# Web Playbook — authorised CTF target only

> **Scope.** The organiser's challenge URL you are authorised to test in the competition.
> Not for third-party or production sites.

## 1. Recon
View page source + JS, `robots.txt`, `/sitemap.xml`, HTML comments, cookies, response
headers. Probe obvious paths (`/flag`, `/admin`, `/.git/`, backups `*.bak`, `*.old`).
Decode any JWT (check `alg:none`, a weak/guessable secret). Map every input and parameter.

## 2. Classic bug classes (test cheapest-first)
- **IDOR / broken access control** — change an id, reach another user's or the admin's object.
- **SQL injection** — `'`, `" OR 1=1 -- `, UNION-based extraction; `sqlmap` for blind/time-based.
- **SSTI** — `{{7*7}}` / `${7*7}`; if it renders `49`, escalate per engine (Jinja2, Twig, …).
- **Command injection** — `; id`, `| id`, `$(id)` in anything reaching a shell.
- **Path traversal / LFI** — `../../etc/passwd`; log-poisoning / wrappers for RCE.
- **XSS** — reflected / stored, mainly for challenges with a bot "admin" that visits your
  payload (exfiltrate its cookie or the flag).
- **SSRF, insecure deserialization, upload bypasses** — depending on the stack.

## 3. Recover the flag
Usually in a protected page, a DB row, a file on disk (`/flag.txt`), or an admin-only
response. Pull it and verify the format.

## Tooling
`curl` / `httpie`, Burp Suite (manual), `sqlmap`, `ffuf` / `gobuster` (dir & param fuzzing),
`jwt_tool`, browser devtools.
