#!/usr/bin/env bash
set -euo pipefail

if [[ $EUID -ne 0 ]]; then
  echo "This script must be run as root" >&2
  exit 1
fi

ROOTFS_DIR=${1:-build/rootfs}
UBUNTU_RELEASE="jammy"
MIRROR_URL="http://archive.ubuntu.com/ubuntu"

mkdir -p "${ROOTFS_DIR}"

if [[ ! -e "${ROOTFS_DIR}/etc/os-release" ]]; then
  echo "[build-rootfs] Bootstrapping Ubuntu ${UBUNTU_RELEASE}..."
  debootstrap --arch=amd64 "${UBUNTU_RELEASE}" "${ROOTFS_DIR}" "${MIRROR_URL}"
else
  echo "[build-rootfs] Reusing existing rootfs at ${ROOTFS_DIR}"
fi

mountpoint -q "${ROOTFS_DIR}/proc" || mount --bind /proc "${ROOTFS_DIR}/proc"
mountpoint -q "${ROOTFS_DIR}/sys" || mount --bind /sys "${ROOTFS_DIR}/sys"
mountpoint -q "${ROOTFS_DIR}/dev" || mount --bind /dev "${ROOTFS_DIR}/dev"

cat <<PKG | chroot "${ROOTFS_DIR}" /usr/bin/env bash
set -e
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends \\
  linux-image-generic systemd-sysv sudo vim nano curl wget git ca-certificates \\
  network-manager network-manager-gnome nftables apparmor apparmor-utils firejail flatpak iwd \\
  sway wlroots xwayland grim slurp wayland-protocols \\
  gnome-terminal dbus-user-session pipewire wireplumber policykit-1-gnome \\
  fonts-dejavu fonts-noto-color-emoji
apt-get clean
rm -rf /var/lib/apt/lists/*
PKG

cat <<'CHROOT' | chroot "${ROOTFS_DIR}" /usr/bin/env bash
set -e
useradd -m -s /bin/bash pharaoh || true
echo "pharaoh ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/99-pharaoh
passwd -d pharaoh || true
CHROOT

umount -lf "${ROOTFS_DIR}/proc" || true
umount -lf "${ROOTFS_DIR}/sys" || true
umount -lf "${ROOTFS_DIR}/dev" || true

echo "[build-rootfs] Rootfs ready at ${ROOTFS_DIR}"
