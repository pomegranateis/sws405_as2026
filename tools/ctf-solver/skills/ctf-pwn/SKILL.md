---
name: ctf-pwn
description: Playbook for CTF binary-exploitation (pwn) challenges against the organiser's deliberately-vulnerable challenge binary. Use when given a binary plus a remote nc endpoint and the goal is to make it reveal the flag. For authorised CTF targets only.
---

# Pwn Playbook — authorised CTF targets only

> **Scope.** This is for the organiser-provided, intentionally-vulnerable challenge binary
> you are authorised to attack inside the competition. Nothing here is for systems you don't
> own or have explicit permission to test.

## 1. Enumerate
`checksec --file=./chal` → note RELRO, Canary, NX, PIE; these decide the technique.
Identify the libc version (often provided; otherwise leak it later). Run the binary and map
each input to its behaviour.

## 2. Find the bug class
Read the binary (see `ctf-rev`) to locate the vulnerability: stack overflow (unbounded
read / `gets`), format string (user data reaching `printf`), use-after-free / double-free
(heap), off-by-one, integer issues. Confirm with a crash under a controlled input.

## 3. Develop with pwntools (local, then flip to remote)
Standard CTF workflow — the generic template every writeup starts from:

```python
from pwn import *
elf = context.binary = ELF('./chal')
libc = ELF('./libc.so.6')     # if the challenge ships one
io = process('./chal')         # develop locally
# io = remote('host', 1337)    # switch once it works locally
# ... build the payload for the bug class you found ...
io.interactive()
```

- Offsets: `cyclic`, then `cyclic_find(value)` on the crash.
- No PIE / no canary + overflow → ret2win or ret2plt.
- Need libc → leak a known address (e.g. print a GOT entry), compute the base, then
  ret2libc / `one_gadget`.
- ROP: `ROPgadget` or pwntools `ROP()` to chain; `one_gadget` for a single-shot shell.
- Heap: the technique follows the glibc version (tcache / fastbin behaviour differs).

## 4. Recover the flag
A shell → `cat flag*`. Some challenges print it directly on success. Verify it matches the
flag format before submitting.

## Tooling
`pwntools`, `gdb` + pwndbg/gef, `ROPgadget`, `one_gadget`, `seccomp-tools`, `patchelf`
(to run against the provided libc).
