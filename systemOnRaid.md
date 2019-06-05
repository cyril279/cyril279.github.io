# Fix (understand?) the bogus raid boot issue

## Update
not sure what the actual issue is, but now (2019/06/10) it works.  
Three things that may have been incorrect:
1. `/boot` partition stored on different disk than ESP partition  #this is the only one that seems viable to me
2. firmware/grub unable to consistently parse `md/name` (vs md/no)
2. incorrect `/boot` volume size

## Issue
Recent switch to a RAID0 system config.

The openSUSE generated `opensuse-secureboot` UEFI option does not boot the system consistently.

1. The failed boots drop to a grub promp, where `ls` does return the target boot volume
2. Booting from the firmware boot-menu usually results in a complete boot
2. Each kernel/bootloader update is what breaks the boot process, resulting in a grub prompt upon reboot
2. I am able to boot from the bios-generated entry (DELL boot-menu)

## Fundamentals
Research has shown that if the root is on soft-raid0, then /boot (may) need to be on a separate partition.  
EFI and /boot cannot share a partition because EFI needs to have a 'FAT' filesystem, and '/boot' needs a posix compliant filesystem (which 'FAT' is NOT).  

Action (summary):  
- Create (& populate) a separate /boot partition on the same disk as the ESP partition
- delete subvolumes `i386-pc` and `x86_64-efi`
- adjust fstab to use new partition
- re-establish subvolumes? <- no, not the /boot/grub2 ones anyway

partition	| sdX	| sdY	| raid-0
-:	| :-:	| :-:	| :-:
1	|260M [FAT] /boot/efi	| 260M	| -
3	|500M [XFS] /boot	| 500M	| -
4	| 20G ->	| 20G ->	| [Btrfs]  /
5	| remainder ->	| remainder ->	| [XFS]  /home/storage
2	| 2G ->	| 2G ->	| [swap]

# None of the following bootloader stuff should matter, aside from helping me to sort the issue.  
Information is preserved for later use, in some other document

## EFI entry generation
1. Firmware, Automatically: `pciroot (0x0)/Pci...AMBO`
2. Firmware, via UI: `pciroot (0x0)/Pci...file\\shim.efi`
2. OS Software (ex. efibootmgr): `HD(1,GPT,7667d...file\\shim.efi`

bootctl shows us all kids of useful information, but is not much for manipulation (see bootctl entry below) 

## EFI manipulation
This is the easy one. efibootmgr.

**Show us the current config** (verbosely)  
`efibootmgr -v`  

output:
```
BootCurrent: 0003
Timeout: 0 seconds
BootOrder: 0003,0004,0000
Boot0000* opensuse-secureboot HD(1,GPT,7667db86-1370-4fa7-ba7a-9177ac4bf7f3,0x800,0x80000)/File(\EFI\opensuse\shim.efi)
Boot0003* UEFI: ADATA SX900 PciRoot(0x0)/Pci(0x1f,0x2)/Sata(4,65535,0)/HD(1,GPT,7667db86-1370-4fa7-ba7a-9177ac4bf7f3,0x800,0x80000)AMBO
Boot0004* UEFI: SanDisk SDSSDA120G PciRoot(0x0)/Pci(0x1f,0x2)/Sata(0,65535,0)/HD(2,GPT,a7457fa7-ea3d-4a4f-ae23-9d6161087137,0xe1800,0x32000)AMBO
Boot001A* UEFI: HP SSD M700 120GB PciRoot(0x0)/Pci(0x1f,0x2)/Sata(4,65535,0)/HD(1,GPT,7667db86-1370-4fa7-ba7a-9177ac4bf7f3,0x800,0x80000)AMBO
Boot001B* UEFI: IP4 Realtek PCIe GBE Family Controller(Ipv4) PciRoot(0x0)/Pci(0x1c,0x4)/Pci(0x0,0x0)/MAC(a41f727b87ef,0)/IPv4(0.0.0.00.0.0.0,0,0)AMBO
Boot001C* UEFI: IP6 Realtek PCIe GBE Family Controller(Ipv6) PciRoot(0x0)/Pci(0x1c,0x4)/Pci(0x0,0x0)/MAC(a41f727b87ef,0)/IPv6([::]:<->[::]:,0,0)AMBO
```

**Delete a boot entry**  
`efibootmgr -b 0003 -B`

**Create a boot entry**
```
efibootmgr --create --disk /dev/sdx --part n --label "UEFI: openSUSE" --loader \\EFI\\opensuse\\grubx64.efi
efibootmgr --create --disk /dev/sdx --part n --label "UEFI: openSUS3" --loader \\EFI\\opensuse\\shimx64.efi #for secureboot
efibootmgr -c -d /dev/sdx -p n -L "UEFI: openSUS3" -l \\EFI\\opensuse\\shimx64.efi #for secureboot
```
Yields an entry similar to:  
`Boot0000* UEFI: openSUS3 HD(1,GPT,7667db86-1370-4fa7-ba7a-9177ac4bf7f3,0x800,0x80000)/File(\EFI\opensuse\shim.efi)`


```
cyril@kodi12:~> bootctl
systemd-boot not installed in ESP.
System:
     Firmware: n/a (n/a)
  Secure Boot: enabled
   Setup Mode: user

Current Boot Loader:
      Product: n/a
     Features: ✗ Boot counting
               ✗ Menu timeout control
               ✗ One-shot menu timeout control
               ✗ Default entry control
               ✗ One-shot entry control
          ESP: n/a
         File: └─n/a

Available Boot Loaders on ESP:
          ESP: /boot/efi (/dev/disk/by-partuuid/7667db86-1370-4fa7-ba7a-9177ac4bf7f3)
         File: └─/EFI/BOOT/bootx64.efi

Boot Loaders Listed in EFI Variables:
        Title: opensuse-secureboot
           ID: 0x0000
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/7667db86-1370-4fa7-ba7a-9177ac4bf7f3
         File: └─/EFI/opensuse/shim.efi

        Title: UEFI: openSUS3
           ID: 0x0001
       Status: active, boot-order
    Partition: /dev/disk/by-partuuid/7667db86-1370-4fa7-ba7a-9177ac4bf7f3
         File: └─/EFI/opensuse/shim.efi

Boot Loader Entries:
        $BOOT: /boot/efi (/dev/disk/by-partuuid/7667db86-1370-4fa7-ba7a-9177ac4bf7f3)

snippet of blkid:
/dev/sdc1: SEC_TYPE="msdos" UUID="6C08-1833" TYPE="vfat" PARTUUID="7667db86-1370-4fa7-ba7a-9177ac4bf7f3"
```

