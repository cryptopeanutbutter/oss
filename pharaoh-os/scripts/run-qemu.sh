#!/usr/bin/env bash
set -euo pipefail

ISO_PATH=${1:-out/PharaohOS-bios.iso}

if [[ ! -f "${ISO_PATH}" ]]; then
  echo "ISO not found at ${ISO_PATH}" >&2
  exit 1
fi

exec qemu-system-x86_64 -m 4096 -enable-kvm -smp 4 -cdrom "${ISO_PATH}" -boot d -display default,show-cursor=on
