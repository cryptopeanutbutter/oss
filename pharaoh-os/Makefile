SHELL := /bin/bash
ROOTFS_DIR := build/rootfs
OUT_DIR := out
ISO_NAME_BIOS := $(OUT_DIR)/PharaohOS-bios.iso
ISO_NAME_UEFI := $(OUT_DIR)/PharaohOS-uefi.iso
SCRIPTS_DIR := scripts
FLUTTER_PROJECTS := pharaoh-shell pharaohsearch pharaoh-firewall pharaoh-store

.PHONY: all deps rootfs overlay shell flatpaks iso-bios iso-uefi run-qemu clean

all: iso-bios

deps:
@echo "[deps] Ensuring host dependencies are present"
sudo apt-get update
sudo apt-get install -y \
  debootstrap grub-pc-bin grub-efi-amd64-bin xorriso mtools squashfs-tools \
  nasm build-essential flutter dart flatpak

rootfs:
@echo "[rootfs] Building Ubuntu minimal rootfs"
sudo $(SCRIPTS_DIR)/build-rootfs.sh $(ROOTFS_DIR)

overlay:
@echo "[overlay] Applying overlay content and systemd units"
sudo rsync -a overlay/ $(ROOTFS_DIR)/
sudo rsync -a systemd/ $(ROOTFS_DIR)/etc/systemd/system/
sudo chown -R root:root $(ROOTFS_DIR)/etc/systemd/system
sudo $(SCRIPTS_DIR)/chroot-setup.sh $(ROOTFS_DIR)

shell:
@for project in $(FLUTTER_PROJECTS); do \
pushd $$project >/dev/null; \
sudo flutter pub get; \
sudo flutter build linux --release; \
popd >/dev/null; \
done
@echo "[shell] Installing Flutter builds into rootfs"
sudo mkdir -p $(ROOTFS_DIR)/usr/local/pharaoh
@for project in $(FLUTTER_PROJECTS); do \
sudo rm -rf $(ROOTFS_DIR)/usr/local/pharaoh/$$project; \
sudo mkdir -p $(ROOTFS_DIR)/usr/local/pharaoh/$$project; \
sudo cp -r $$project/build/linux/x64/release/bundle/* $(ROOTFS_DIR)/usr/local/pharaoh/$$project/; \
done

flatpaks:
@echo "[flatpaks] Installing required Flatpaks into rootfs"
sudo FLATPAK_ROOT=$(ROOTFS_DIR) bash flatpak/install-flatpaks.sh

iso-bios:
@mkdir -p $(OUT_DIR)
sudo $(SCRIPTS_DIR)/package-iso-bios.sh $(ROOTFS_DIR) $(ISO_NAME_BIOS)

iso-uefi:
@mkdir -p $(OUT_DIR)
sudo $(SCRIPTS_DIR)/package-iso-uefi.sh $(ROOTFS_DIR) $(ISO_NAME_UEFI)

run-qemu:
qemu-system-x86_64 -m 4096 -enable-kvm -cdrom $(ISO_NAME_BIOS)

clean:
sudo rm -rf $(ROOTFS_DIR) $(OUT_DIR)
for project in $(FLUTTER_PROJECTS); do \
rm -rf $$project/build; \
done
