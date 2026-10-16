---
name: ctf-rev
description: Playbook for CTF reverse-engineering challenges — understanding a compiled program to recover a flag or satisfy a check. Use when given an ELF/PE/Mach-O executable, bytecode, or any "reverse this" task.
---

# Reversing Playbook

## 1. Static first pass (free)
`file`, `checksec`, `strings -n 6` (and `-e l` for wide strings). A flag or a revealing
format string is often right there. Note the language / runtime (Go, Rust, .NET,
frozen-Python, packed with UPX → `upx -d`).

## 2. Decompile
- **Ghidra** (headless: `analyzeHeadless`), **Rizin / radare2** (`aaa`, then `pdf @ main`),
  or Binary Ninja / IDA if you have them.
- Find `main`, follow the flag check. Common patterns: compare input to a hardcoded string;
  transform input (XOR / add / shuffle) then compare; byte-by-byte checks.

## 3. Dynamic
- `ltrace` / `strace` to watch libc calls and comparisons (e.g. `strcmp(input, "secret")`).
- `gdb` (with pwndbg / gef): break at the comparison and read the expected value straight
  out of memory / registers.

## 4. Symbolic execution (when the check is a constraint)
`angr`: set the success address as the goal, failure addresses to avoid, and let it solve
stdin. Ideal for char-by-char or arithmetic checks that are tedious by hand.

## 5. Language-specific
- **Go / Rust**: large static binaries — recover symbols (`GoReSym`, Ghidra scripts).
- **.NET**: `dnSpy` / ILSpy give near-source decompilation.
- **Python (frozen)**: `pyinstxtractor`, then `decompyle3` / `uncompyle6`.

## Tooling
`ghidra`, `rizin`/`radare2`, `gdb`+pwndbg, `ltrace`/`strace`, `angr`, `upx`,
`dnSpy`/ILSpy, `pyinstxtractor`.
