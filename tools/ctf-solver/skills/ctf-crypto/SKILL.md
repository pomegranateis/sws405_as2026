---
name: ctf-crypto
description: Playbook for CTF cryptography challenges — encodings, classical ciphers, XOR, hash cracking, and RSA/AES attacks. Use when a challenge gives ciphertext, keys, RSA parameters (n, e, c), hashes, or encoded blobs.
---

# Crypto Playbook (cheapest-first)

## 1. Encodings (seconds — try before assuming encryption)
base64 / base32 / base58 / base85, hex, URL, ROT13 / Caesar (all 25), Atbash, Morse,
binary, decimal-ASCII. Chain them — nested encodings are common. CyberChef's "Magic" is
the manual analogue.

## 2. XOR
- Single-byte: brute all 256 keys, score by printable / English frequency.
- Repeating-key: recover key length (Hamming distance / Kasiski), then solve each column as
  single-byte XOR. `xortool` automates this.
- Known-plaintext: `cipher XOR known = key`.

## 3. Hashes
Identify with `hashid`; check length. Crack with a wordlist (`hashcat` / `john` + rockyou)
or an online lookup. Unsalted fast hashes of short inputs usually fall quickly.

## 4. RSA (the most common "hard" crypto)
Dump `n, e, c`, then try in rough order:
- **factordb** — `n` may already be publicly factored.
- **Small e** (e=3) with small message → integer e-th root of `c`.
- **Fermat** — `p, q` close together.
- **Wiener** — small private `d` (very large `e`).
- **Common modulus** — same `n`, two `e` with gcd 1.
- **Håstad broadcast** — same message to `e` recipients with `e` moduli.
- **LSB / parity oracle** when the service leaks it.
`RsaCtfTool --publickey key.pub --uncipher c` (or `-n -e -c`) chains most of these; reach
for it early, then understand which attack actually hit.

## 5. AES / block ciphers
- **ECB**: repeated 16-byte ciphertext blocks → cut-and-paste or byte-at-a-time decryption.
- **CBC**: bit-flipping; padding-oracle decryption recovers plaintext without the key.
- **Nonce reuse** in CTR/GCM leaks keystream and enables forgery.

## Tooling
`python3` + `pycryptodome`, `gmpy2`, `sympy`, `z3-solver`; `RsaCtfTool`; `xortool`;
`hashcat` / `john`; `sage` (if available) for lattice / ECC work.
