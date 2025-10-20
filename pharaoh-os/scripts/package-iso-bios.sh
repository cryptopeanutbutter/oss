#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" >&2
  exit 1
fi

ROOTFS_DIR=${1:-build/rootfs}
ISO_PATH=${2:-out/PharaohOS-bios.iso}
WORK_DIR=$(mktemp -d)

cleanup() {
  rm -rf "${WORK_DIR}"
}
trap cleanup EXIT

mkdir -p "${WORK_DIR}/iso/live"

mksquashfs "${ROOTFS_DIR}" "${WORK_DIR}/iso/live/filesystem.squashfs" -comp xz -e boot
cp -a "${ROOTFS_DIR}/boot" "${WORK_DIR}/iso/boot"
cp iso/boot/grub/grub.cfg "${WORK_DIR}/iso/boot/grub/grub.cfg"

grub-mkrescue -o "${ISO_PATH}" "${WORK_DIR}/iso"

echo "[package-iso-bios] Created ${ISO_PATH}"
