#!/usr/bin/env bash
# flaggrep.sh — recursively grep for CTF flags.
# Default prefix "flag"; override with FLAG_PREFIX (e.g. FLAG_PREFIX=picoCTF).
set -uo pipefail

PREFIX="${FLAG_PREFIX:-flag}"
TARGET="${1:-.}"
RE="${PREFIX}\{[^}]{1,256}\}"

# -r recurse, -a treat binary as text, -o only match, -n line, -i case-insensitive, -E extended
grep -raoniE "$RE" "$TARGET" 2>/dev/null | sort -u
