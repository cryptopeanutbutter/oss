# Pharaoh OS Settings Overview

The Settings interface centralizes system configuration categories with clear mappings to underlying services.

## Display
- **Resolution, Refresh Rate, Scaling:** Uses `wlr-randr` commands underneath to adjust Sway/Wayland outputs.
- **Night Mode:** Toggles `gammastep` integration (optional future addition).

## Network
- **Wi-Fi Toggle:** Calls `nmcli radio wifi`.
- **Connection List:** Mirrors `nmcli connection show` and allows activation/deletion.
- **Hotspot:** Creates a shared connection via NetworkManager.

## Sound
- **Output/Input Selection:** Interfaces with PipeWire over DBus to select nodes.
- **Volume Sliders:** Control `wpctl set-volume` for sinks and sources.
- **Mute toggles:** Direct `wpctl set-mute` operations.

## Appearance
- **Theme Selection:** Reads `/usr/share/pharaoh/themes/*.json` and applies via the shell's `ThemeLoader`.
- **Accent Color:** Updates dynamic accent in the Flutter shell.
- **Wallpaper:** Updates Sway background configuration.

## Keyboard
- **Layouts:** Modifies `/etc/default/keyboard` and triggers `localectl set-x11-keymap`.
- **Shortcuts:** Binds to Sway configuration (`~/.config/sway/config`).

## Apps
- **Default Apps:** Uses `xdg-mime` to set handlers.
- **Sandboxing:** Toggles Firejail wrappers by enabling/disabling `.desktop` overrides in `/usr/share/applications`.

## Privacy
- **Screen Sharing / Camera / Microphone:** Manages PipeWire session permissions through `xdg-desktop-portal` requests.
- **Telemetry:** Remains disabled by default. Users may opt in by enabling metrics upload (no service by default).

## Firewall
- Launches the Pharaoh Firewall GUI via `/usr/local/bin/pharaoh-firewall` for interactive preset control.

## Updates
- **System Updates:** Runs `/usr/local/bin/pharaoh-updater` and shows progress output.
- **Flatpak Remotes:** Lists enabled remotes using `flatpak remotes`.

Each page persists preferences to `$HOME/.config/pharaoh/settings.json` so that the live session can restore them on subsequent boots or installations.
