#!/usr/bin/env bash
# recon.sh — first-pass CTF recon: run cheap identify/extract tools over an
# artifact, carve embedded data, then grep everything for the flag.
#
# Usage:   recon.sh <file-or-dir> [workdir]
# Flag:    default prefix "flag"; override with FLAG_PREFIX=picoCTF
set -uo pipefail

TARGET="${1:?usage: recon.sh <file-or-dir> [workdir]}"
WORK="${2:-ctf-recon-$(basename "$TARGET")-$(date +%s)}"
PREFIX="${FLAG_PREFIX:-flag}"
FLAG_RE="${PREFIX}\{[^}]{1,256}\}"

mkdir -p "$WORK"
OUT="$WORK/recon.txt"
: > "$OUT"

have(){ command -v "$1" >/dev/null 2>&1; }
sec(){ printf '\n\n========== %s ==========\n' "$1" >>"$OUT"; }
cap(){ # cap <label> <cmd> [args...]
  local label="$1"; shift
  sec "$label"
  if have "$1"; then
    "$@" >>"$OUT" 2>&1 || echo "[$1 exited nonzero]" >>"$OUT"
  else
    echo "[skip: $1 not installed]" >>"$OUT"
  fi
}

echo "[*] target : $TARGET" | tee -a "$OUT"
echo "[*] workdir: $WORK"    | tee -a "$OUT"
echo "[*] flag re: $FLAG_RE" | tee -a "$OUT"

if [ -d "$TARGET" ]; then
  sec "directory tree"; find "$TARGET" -maxdepth 4 >>"$OUT" 2>&1
  sec "per-file type"; find "$TARGET" -type f -exec file {} \; >>"$OUT" 2>&1
else
  cap "file"              file "$TARGET"
  cap "xxd (head)"        bash -c "xxd '$TARGET' | head -n 40"
  cap "strings ascii"     bash -c "strings -n 6 '$TARGET'"
  cap "strings utf16le"   bash -c "strings -e l -n 6 '$TARGET'"
  cap "exiftool"          exiftool "$TARGET"
  cap "binwalk (scan)"    binwalk "$TARGET"
  cap "7z (list)"         7z l "$TARGET"

  # --- extraction / carving ---
  if have binwalk; then
    sec "binwalk extract"
    binwalk -e --run-as=root -C "$WORK/_binwalk" "$TARGET" >>"$OUT" 2>&1 \
      || binwalk -e -C "$WORK/_binwalk" "$TARGET" >>"$OUT" 2>&1
  fi
  if have foremost; then
    sec "foremost carve"
    foremost -i "$TARGET" -o "$WORK/_foremost" >>"$OUT" 2>&1
  fi

  # --- quick stego wins by image type ---
  MIME="$(file -b --mime-type "$TARGET" 2>/dev/null || echo unknown)"
  case "$MIME" in
    image/png|image/bmp) cap "zsteg -a" zsteg -a "$TARGET" ;;
    image/jpeg)          cap "steghide (empty pw)" \
                           steghide extract -sf "$TARGET" -p "" -xf "$WORK/_steghide.out" ;;
  esac
fi

# --- always: flag search over original + everything extracted ---
sec "FLAG SEARCH"
HITS="$( { grep -raoiE "$FLAG_RE" "$TARGET" 2>/dev/null
           grep -raoiE --exclude=recon.txt "$FLAG_RE" "$WORK" 2>/dev/null; } | sort -u )"
echo "$HITS" >>"$OUT"

echo
echo "[*] full log: $OUT"
if [ -n "$HITS" ]; then
  echo "[+] POSSIBLE FLAGS:"
  echo "$HITS"
else
  echo "[-] no flag matched yet — escalate to the matching category playbook."
fi
