---
name: ctf-triage
description: Entry point for any CTF challenge. Use to classify a challenge (crypto, rev, pwn, web, forensics/stego, osint, misc), run first-pass recon, and route to the right playbook. Trigger on any mention of a CTF challenge, a flag{...} to find, or an uploaded challenge file / URL / nc endpoint.
---

# CTF Triage & Routing

## 0. Collect every input
- Run `file` on each provided file; note type, size, anything odd.
- A URL → web. A `nc host port` plus a binary → pwn or rev. Ciphertext / keys / `n,e,c` →
  crypto. pcap / image / memdump / disk image → forensics/stego. A handle or photo → osint.
- Read the title, description, and point value. They leak the intended category and
  technique constantly ("Baby RSA", "Can you read my mind?", point weight = difficulty).

## 1. Always recon first
Run `${CLAUDE_PLUGIN_ROOT}/scripts/recon.sh <file>` on every file before any clever work.
It greps for the flag across the file and everything it carves out. Easy/medium flags are
frequently sitting in `strings`, EXIF, an appended archive, or a base64 blob.

## 2. Classify

| Signal | Category | Skill |
|---|---|---|
| ciphertext, keys, n/e/c, hashes, encodings | crypto | `ctf-crypto` |
| ELF/PE/Mach-O, "reverse", license/key check | rev | `ctf-rev` |
| binary + nc endpoint, "overflow", checksec | pwn | `ctf-pwn` |
| URL, login, cookie, JWT, "admin" | web | `ctf-web` |
| pcap, png/jpg/wav, memory/disk image | forensics/stego | `ctf-forensics` |
| handle, photo, "find the place" | osint | web search + exiftool |
| jail, esolang, QR, odd format | misc | `ctf-misc` |

## 3. Route & loop
Hand off to the category skill and work cheapest / most-common attacks first. Keep a scratch
notes file of what's been ruled out. A reported flag must **literally** match the format —
never invent, pad, or "reconstruct" one.
