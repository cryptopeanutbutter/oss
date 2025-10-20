#!/usr/bin/env bash
set -euo pipefail

ROOT=${FLATPAK_ROOT:-}
if [[ -z "$ROOT" ]]; then
  echo "FLATPAK_ROOT not set" >&2
  exit 1
fi

if [[ ! -d "$ROOT" ]]; then
  echo "Rootfs directory $ROOT missing" >&2
  exit 1
fi

if [[ ! -d "$ROOT/var/lib/flatpak" ]]; then
  mkdir -p "$ROOT/var/lib/flatpak"
fi

cat <<'CHROOT' | chroot "$ROOT" /usr/bin/env bash
set -e
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.valvesoftware.Steam
CHROOT

echo "[flatpak] Discord and Steam installed into rootfs"
