---
description: Run the automated recon dump + flag grep over a CTF artifact.
argument-hint: <path-to-file-or-dir>
allowed-tools: Bash, Read, Glob, Grep
---

Run first-pass recon on the artifact at: $ARGUMENTS

1. Run `bash ${CLAUDE_PLUGIN_ROOT}/scripts/recon.sh "$ARGUMENTS"`.
2. Read the `POSSIBLE FLAGS` section it prints. If a `flag{...}` matched, check it
   fits the challenge's expected format and report it.
3. If nothing matched, open the full log it wrote (`recon.txt` in the workdir),
   say what the artifact actually is (type, embedded/appended data, anything odd),
   and recommend which category playbook to escalate to.

Do not guess or "reconstruct" a flag. Only report strings that literally match the format.
