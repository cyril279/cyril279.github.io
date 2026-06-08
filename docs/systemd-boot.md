# Systemd-boot
A lightweight, UEFI-only bootloader that offers simplicity, faster boot times, and easier configuration maintenance via plain text files, making it ideal for single-OS or straightforward multi-boot EFI systems.  

### Boot Menu Shortcuts

Key	| Action
--:|:--
**Up/Down**	| Select menu entry
**Enter**	| Boot selected entry
**d**	| Set default entry (stored in NVRAM)
**t/T**	| Adjust timeout (stored in NVRAM)
**e**	| Edit kernel command line for current boot
**Space**	| Show menu (if timeout is 0)
**Q**	| Quit
**v**	| Show systemd-boot and UEFI version
**P**	| Print current configuration
**h**	| Show key mapping

### Add Windows entry to systemd-boot
Should generally avoid this, but some systems do not allow selection of second disk through UEFI  
In such cases, a systemd-boot entry is required to access `windows boot manager`  
- Copy contents of `EFI/Microsoft/boot/` (of windows installation) to `EFI/Windows/` of ESP partition
  (typically mounted as `/boot/efi` or similar)  
- verify entries:  
  ```sh
  sudo bootctl --path=/boot/efi list
  ```
