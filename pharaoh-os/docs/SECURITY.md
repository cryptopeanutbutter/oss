# Pharaoh OS Security Overview

Pharaoh OS is designed with a defense-in-depth posture combining kernel policies, sandboxing, and user tooling to minimize risk while preserving gaming performance.

## Components

### AppArmor
AppArmor is enabled by default and enforces custom profiles located in `/etc/apparmor.d/`:
- `pharaohsearch` confines the bundled browser to its configuration directories and restricts Python execution.
- `discord` and `steam` wrap Firejail launchers to ensure they only access their Flatpak sandboxes.

Reload profiles after modification with:
```bash
sudo apparmor_parser -r /etc/apparmor.d/<profile>
```

### Firejail
Firejail is used to sandbox PharaohSearch, Discord, and Steam. Toggle sandboxing per-app in the Settings application (Apps page). Custom profiles live in `/etc/firejail/` (installed during build) and can be extended to cover new binaries.

### nftables
The nftables ruleset is stored at `/etc/nftables.conf`. Pharaoh OS ships three presets:
- **Strict:** Only DNS outbound traffic; use when performing offline work.
- **Normal:** Allows web browsing, Discord, and Steam without exposing inbound ports.
- **Gaming:** Opens additional UDP ranges required for multiplayer services.

Switch presets via the Pharaoh Firewall GUI or CLI:
```bash
sudo pharaoh-firewall strict
```

### Automatic Updates
`/usr/local/bin/pharaoh-updater` wraps `apt-get upgrade` and `flatpak update`. The Settings app exposes this under the Updates page and it is safe to schedule via cron or systemd timers.

## Adding Custom Rules
1. Duplicate an existing preset file in `/usr/share/pharaoh/firewall/presets/`.
2. Edit the nftables chains with your desired ports.
3. Apply with `sudo pharaoh-firewall <preset-name>`.
4. Update `/etc/default/pharaoh-os` to set a new default preset if needed.

## Reporting Issues
Open a GitHub issue with reproduction steps, affected software versions, and logs from:
- `journalctl -u pharaoh-session.service`
- `sudo nft list ruleset`
- `sudo aa-status`
