# Activating ctf-solver on your CTF machine

This plugin lives in the repo so it survives and travels with you. On whatever
machine you're using for the CTF (your laptop / a persistent VM — NOT a throwaway
cloud container, where it won't persist), do:

```bash
# from the repo root
cp -r tools/ctf-solver ~/.claude/plugins/
bash ~/.claude/plugins/ctf-solver/scripts/bootstrap.sh   # installs the toolchain (slow; best-effort)
```

Then in Claude Code: `/plugin` -> enable **ctf-solver**.

## Using it
- `/ctf-recon <file-or-dir>`  — automated recon dump + flag grep
- `/ctf-solve <file | url | "nc host port" | description>` — full solve loop

## Notes
- `bootstrap.sh` is best-effort and safe to re-run. It needs apt (Debian/Kali)
  or brew (macOS), plus network access. It is already patched for Kali:
  - `stegseek` installs via apt (it is NOT a pip package) and on its own line
    so a missing package can't abort the rest;
  - gmpy2 build deps (`libgmp-dev libmpfr-dev libmpc-dev`) are in the apt list;
  - `angr` and `volatility3` are on their own lines (slow/optional) so they
    can't block pwntools, and pip errors are no longer hidden.
  - Run it tonight while you have network — RsaCtfTool clones from GitHub.
- Default flag format is `flag{...}`. Override per-event:
  `export FLAG_PREFIX=picoCTF` (or whatever the organiser uses) before running.
- The scripts and skills work on their own even without the full toolchain —
  recon.sh just skips whatever isn't installed.
