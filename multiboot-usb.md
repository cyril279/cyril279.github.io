# Multi-boot usb
let's have our standard util-iso's on one usb.  
clonezilla, gparted, etc...  

## [MultiBoot USB](https://mbusb.aguslr.com/):  
git clone the project, then from within the folder, prepare the usb.  
per [using the script](https://mbusb.aguslr.com/install.html#using-the-script):  
`./makeUSB.sh -b -e /dev/sdc ext4`

**Get bootable files**  
>Once you have a bootable USB drive, it only remains to copy the bootable files (ISO or kernel) to the pendrive. [...] save them into $mntusb/boot/isos.  

## Windows USB:
WoeUSB (gui tool)  
Windows USB installation media creator for the gnu/linux platform  
`sudo zypper in WoeUSB`  
commandline usage example:
`sudo woeusb --workaround-bios-boot-flag -d Windows1809ALL.iso /dev/sdc`  
workaround flag ensures that the boot flag is set, because many legacy bios will skip the device if the flag is not set.  
It is unclear why [this is not enabled by default](https://github.com/slacka/WoeUSB/issues/193).  

## Bootable USB issues:
- GPT not recognised  

## Volume label:
https://www.tecmint.com/change-modify-linux-disk-partition-label-names/  
https://superuser.com/questions/1022992/how-to-change-a-usb-stick-name  

ext2,3,4  
`sudo e2label /dev/sdb3 multiboot-repo`  

ntfs  
`ntfslabel /dev/sda5 NTFS_DIR`  

exfat  
`exfatlabel /dev/sda3 EX_PART`

