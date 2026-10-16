---
name: ctf-misc
description: Playbook for CTF miscellaneous challenges — sandbox/jail escapes, esoteric languages, QR/barcodes, scripting puzzles over nc, and anything that doesn't fit the main categories. Use as the fallback when triage can't place a challenge.
---

# Misc Playbook

## Jails / sandbox escapes
- **Python jail**: route around blacklists via `getattr`, `__import__`, `__builtins__`,
  subclass walking (`().__class__.__base__.__subclasses__()`), f-strings, `breakpoint()`.
  Read what's filtered first, then pick a path that avoids it.
- **Bash jail (rbash)**: `$()`, env tricks, `/*/bin/*` globbing, abuse of allowed commands.
- **calc / eval challenges**: usually reach `os.system` or a file read indirectly.

## Encodings & odd formats
- **QR / barcodes**: `zbarimg`. DataMatrix / Aztec likewise.
- **Hidden-in-text**: whitespace stego (`stegsnow`), zero-width characters, homoglyphs,
  braille, base-anything.
- **Esolangs**: Brainfuck, Ook, Malbolge, Piet (image-based) — use a CLI / online interpreter.

## Scripting puzzles over nc
- "Solve 1000 problems in 10 s": write a `pwntools` client that parses each prompt,
  computes, sends, and loops until the flag appears.
- Proof-of-work gates: implement the stated hashcash-style loop first, then the real logic.

## Logic / recon
- **Git repos**: `git log --all`, inspect old commits / branches / stash for removed secrets.
- **Mystery file**: search the magic bytes — it may be a known format with a renamed extension.

## Tooling
`python3` (+ `pwntools` for interactive nc), `zbar-tools`, `stegsnow`, `git`, standard unix
text tools.
