# Pharaoh OS

Pharaoh OS is a privacy-first desktop operating system focused on gaming and communications. It layers a custom Flutter-based Wayland shell on top of an Ubuntu minimal root filesystem and packages a live ISO experience that autologins into an immersive desktop session.

## Highlights
- **Custom Flutter shell** (`pharaoh-shell`) delivering a dark theme with deep purple accents, smooth taskbar animations, and an integrated launcher/search experience.
- **Built-in apps** including PharaohSearch (secure browser with tracker blocking), Terminal with full Ubuntu CLI compatibility, Discord, Steam, and the Pharaoh Store for managing both APT and Flatpak packages.
- **Security-first defaults** with nftables firewall presets, Firejail sandboxing for key apps, and AppArmor confinement profiles.
- **Live-session ready**: boots straight into the `pharaoh` user without credentials and automatically starts NetworkManager for connectivity.
- **Multi-target ISO tooling**: build BIOS and UEFI images with reproducible scripts and test quickly in QEMU or VirtualBox.

## Repository structure
```
pharaoh-os/
├── docs/                  # Additional documentation and guides
├── flatpak/               # Flatpak installation helpers
├── iso/                   # GRUB configuration for ISO generation
├── overlay/               # Files layered into the live rootfs
├── pharaoh-firewall/      # Flutter GUI for nftables presets
├── pharaoh-shell/         # Flutter desktop shell
├── pharaoh-store/         # Simple app center (APT + Flatpak)
├── pharaohsearch/         # Privacy-focused browser
├── scripts/               # Rootfs build & ISO packaging scripts
├── systemd/               # Systemd unit definitions
├── themes/                # GTK and icon themes
└── Makefile               # High-level automation entrypoints
```

## Quick start
These instructions assume an Ubuntu 22.04+ host with sudo access.

```bash
sudo make deps
sudo make rootfs
sudo make overlay
sudo make shell
sudo make flatpaks
sudo make iso-bios  # or make iso-uefi
```

The resulting ISO images are placed in `out/`. Launch a quick validation run with:

```bash
make run-qemu
```

For detailed virtualization guidance see [docs/VIRTUALBOX.md](docs/VIRTUALBOX.md).

## Known issues
- The Flutter shell requires GPU acceleration for the smoothest animations. Software rendering is supported but may stutter in some virtualized environments.
- Discord and Steam are delivered via Flatpak. Initial launch requires network access to finalize runtime downloads.
- When testing inside containers the Wayland compositor will not start; use a full VM environment instead.

## License
Pharaoh OS is released under the MIT License. See [LICENSE](LICENSE) for details.
