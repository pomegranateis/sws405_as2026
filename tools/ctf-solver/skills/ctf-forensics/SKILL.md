---
name: ctf-forensics
description: Playbook for CTF forensics and steganography — network captures, disk/memory images, documents, and hidden data in images/audio. Use for pcap/pcapng, .png/.jpg/.wav, memory dumps, disk images, or any "something is hidden in this file" task.
---

# Forensics & Stego Playbook

## Always start with recon.sh
`file`, `binwalk` (appended / embedded files are the #1 forensics trick), `foremost` to
carve, `exiftool` for metadata, and a `flag{` grep. Many challenges end right here.

## Network (pcap / pcapng)
- `tshark` / Wireshark: Statistics → Protocol Hierarchy; follow TCP / HTTP streams.
- Export transferred files: `tshark --export-objects http,outdir` (also smb, ftp-data, tftp).
- Hunt for credentials, base64 in parameters, DNS exfil (data in subdomains), ICMP payloads.
  USB-HID captures decode to keystrokes.

## Images (stego)
- **PNG / BMP**: `zsteg -a` (LSB bit-planes); StegSolve to browse planes visually.
- **JPEG**: `steghide extract -sf img.jpg -p ''`, then common/empty passwords; `stegseek`
  brute-forces against rockyou.
- Check for appended data after the image EOF (`binwalk`), palette tricks, and text in metadata.

## Audio
- Spectrogram (Audacity / `sox`) hides text, SSTV, or Morse. Inspect channels separately;
  check for DTMF tones.

## Memory dumps
`volatility3`: `windows.pslist`, `windows.cmdline`, `windows.filescan` + `dumpfiles`,
`windows.hashdump`, plus clipboard / notepad / lsass plugins. Linux images similarly.

## Disk images
`mount -o ro,loop`, or Sleuth Kit (`fls`, `icat`) / Autopsy. Recover deleted files, check
slack space, browser history, `$Recycle.Bin`.

## Office / PDF
Macros: `oletools` (`olevba`). PDFs: `pdf-parser` / `peepdf` — extract streams and embedded JS.

## Tooling
`binwalk`, `foremost`, `exiftool`, `zsteg`, `steghide`, `stegseek`, `tshark`/Wireshark,
`volatility3`, `sleuthkit`, `oletools`, `sox` / Audacity.
