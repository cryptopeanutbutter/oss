# Running Pharaoh OS in VirtualBox

1. Install VirtualBox 7.0 or newer on your host.
2. Create a new virtual machine:
   - Type: **Linux**
   - Version: **Ubuntu (64-bit)**
   - Memory: **4096 MB**
   - CPUs: **2** (or more for better performance)
3. Enable EFI if you plan to boot the UEFI ISO (`make iso-uefi`). For BIOS testing leave EFI disabled.
4. Create a virtual disk (20 GB dynamically allocated is sufficient).
5. Attach the generated ISO from `out/PharaohOS-bios.iso` or `out/PharaohOS-uefi.iso` to the optical drive.
6. Under Display settings, raise Video Memory to at least 128 MB and enable 3D acceleration for smoother animations.
7. Boot the VM. Pharaoh OS will autologin to the live session with the Flutter shell.
8. Use `Right Ctrl` to release the mouse pointer when needed.

> **Tip:** For gaming verification, install the VirtualBox guest additions after booting to access higher resolutions and clipboard sharing.
