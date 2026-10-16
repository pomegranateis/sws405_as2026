#!/usr/bin/env bash
# bootstrap.sh — one-time, best-effort toolchain install for ctf-solver.
# Installs what the local package manager has; skips the rest. Safe to re-run.
# Supports apt (Debian/Ubuntu/Kali) and brew (macOS).
set -uo pipefail

SUDO=""
[ "$(id -u)" -ne 0 ] && command -v sudo >/dev/null && SUDO="sudo"

echo "[*] Detecting package manager..."
if command -v apt-get >/dev/null; then
  $SUDO apt-get update -y
  $SUDO apt-get install -y \
    file binutils xxd libimage-exiftool-perl binwalk foremost steghide \
    tshark tcpdump nmap sqlmap ffuf gobuster \
    radare2 gdb ltrace strace upx-ucl \
    python3-pip pipx git curl wget jq unzip p7zip-full zbar-tools ruby-full || true
elif command -v brew >/dev/null; then
  brew install binutils exiftool binwalk foremost steghide \
    wireshark nmap sqlmap ffuf gobuster radare2 gdb jq p7zip zbar upx pipx ruby || true
else
  echo "[!] No apt/brew found — install the tools listed in the README manually."
fi

echo "[*] Python libraries..."
BSP=""
python3 -m pip install --help 2>/dev/null | grep -q break-system-packages && BSP="--break-system-packages"
python3 -m pip install --upgrade $BSP \
  pwntools pycryptodome gmpy2 sympy requests z3-solver angr volatility3 stegseek 2>/dev/null || \
  echo "  [!] some pip packages failed — angr/volatility3 are heavy; install individually if needed."

echo "[*] Ruby gems (zsteg, one_gadget, seccomp-tools)..."
if command -v gem >/dev/null; then
  $SUDO gem install zsteg one_gadget seccomp-tools 2>/dev/null || echo "  [skip] gem install failed"
else
  echo "  [skip] gem not available"
fi

echo "[*] RsaCtfTool (RSA attack swiss-army)..."
if [ ! -d "$HOME/tools/RsaCtfTool" ]; then
  mkdir -p "$HOME/tools"
  git clone --depth=1 https://github.com/RsaCtfTool/RsaCtfTool "$HOME/tools/RsaCtfTool" 2>/dev/null \
    && python3 -m pip install $BSP -r "$HOME/tools/RsaCtfTool/requirements.txt" 2>/dev/null \
    || echo "  [skip] RsaCtfTool clone/deps failed"
fi

echo
echo "[*] Verifying core tools:"
for t in file strings exiftool binwalk foremost zsteg steghide radare2 gdb tshark python3; do
  if command -v "$t" >/dev/null; then echo "  ok      $t"; else echo "  MISSING $t"; fi
done
echo "[*] Done."
