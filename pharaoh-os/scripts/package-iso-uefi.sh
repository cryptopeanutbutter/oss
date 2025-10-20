#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" >&2
  exit 1
fi

ROOTFS_DIR=${1:-build/rootfs}
ISO_PATH=${2:-out/PharaohOS-uefi.iso}
WORK_DIR=$(mktemp -d)
ESP_SIZE=100

cleanup() {
  rm -rf "${WORK_DIR}"
}
trap cleanup EXIT

mkdir -p "${WORK_DIR}/iso/live" "${WORK_DIR}/esp/EFI/BOOT"

mksquashfs "${ROOTFS_DIR}" "${WORK_DIR}/iso/live/filesystem.squashfs" -comp xz -e boot
cp -a "${ROOTFS_DIR}/boot" "${WORK_DIR}/iso/boot"
cp iso/boot/grub/grub.cfg "${WORK_DIR}/iso/boot/grub/grub.cfg"

grub-mkstandalone -O x86_64-efi -o "${WORK_DIR}/esp/EFI/BOOT/BOOTX64.EFI" \
  "boot/grub/grub.cfg=iso/boot/grub/grub.cfg"

truncate -s ${ESP_SIZE}M "${WORK_DIR}/esp.img"
mkfs.vfat "${WORK_DIR}/esp.img"
mcopy -s -i "${WORK_DIR}/esp.img" "${WORK_DIR}/esp"/* ::

xorriso -as mkisofs -U -A "PharaohOS" -V "PharaohOS" -volset "PharaohOS" \
  -e EFI/BOOT/BOOTX64.EFI -no-emul-boot -isohybrid-gpt-basdat \
  -append_partition 2 0xef "${WORK_DIR}/esp.img" \
  -o "${ISO_PATH}" "${WORK_DIR}/iso"

echo "[package-iso-uefi] Created ${ISO_PATH}"
