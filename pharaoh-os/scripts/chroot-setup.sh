#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" >&2
  exit 1
fi

ROOTFS_DIR=${1:-build/rootfs}

mountpoint -q "${ROOTFS_DIR}/proc" || mount --bind /proc "${ROOTFS_DIR}/proc"
mountpoint -q "${ROOTFS_DIR}/sys" || mount --bind /sys "${ROOTFS_DIR}/sys"
mountpoint -q "${ROOTFS_DIR}/dev" || mount --bind /dev "${ROOTFS_DIR}/dev"

cat <<'CHROOT' | chroot "${ROOTFS_DIR}" /usr/bin/env bash
set -e
systemctl enable NetworkManager.service
systemctl enable apparmor.service
systemctl enable nftables.service
systemctl enable pharaoh-session.service
systemctl enable pharaoh-network-online.service || true

mkdir -p /etc/flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

update-initramfs -c -k all
CHROOT

umount -lf "${ROOTFS_DIR}/proc" || true
umount -lf "${ROOTFS_DIR}/sys" || true
umount -lf "${ROOTFS_DIR}/dev" || true

echo "[chroot-setup] Services configured"
