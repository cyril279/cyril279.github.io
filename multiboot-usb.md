# Multi-boot usb
Arch-wiki shows two methods:  
1. Using GRUB and loopback devices  
2. Using Syslinux and memdisk  <- not works for uefi

[live-grub-stick](https://github.com/cyberorg/live-fat-stick)  

## [MultiBoot USB](https://mbusb.aguslr.com/)  
git clone the project, then from within the folder, prepare the usb.  
per [using the script](https://mbusb.aguslr.com/install.html#using-the-script):  
`./makeUSB.sh -b -e /dev/sdc ext4`

**Get bootable files**  
Once you have a bootable USB drive, it only remains to copy the bootable files (ISO or kernel) to the pendrive. [...] save them into $mntusb/boot/isos.  

*so. much. win.  
*there is still a specific list that this works with, but this list includes the stuff I'm after, and uses downloads from original source.  

## [multibootusb](http://multibootusb.org)
http://multibootusb.org/page_faq/#does-multibootusb-support-efi-or-uefi-booting  
get pre-packaged version from:  
http://multibootusb.org/page_download/  
install it  
'zypper in multibootusb-9.2.0-1suse.noarch.rpm'  
run it  
'multibootusb-pkexec'  

error 'Could not find resource 'data/tools/gptmbr.bin''  
[issue](https://github.com/mbusb/multibootusb/issues/336)  
> Somehow 'gptmbr.bin' is missing. Please download the file from  
> 'https://github.com/mbusb/multibootusb/blob/master/data/tools/gptmbr.bin'  
> and place it under /usr/share/multibootusb/data/tools  

*works, but only from legacy boot menu.  
uefi grub would not progress into either program. MeThinks because usb was created on bios machine; relevant efi files were not available?  

## (not) [live-grub-stick](https://software.opensuse.org/package/live-grub-stick)  
gdisk, create single partition, type 0700  
'makefs.vfat /dev/sdx#'  
'su -c 'live-grub-stick /path/to/file.iso /dev/sdx#''  
then per instructions, I add subsequent iso's:  
'su -c 'live-grub-stick --isohybrid gparted-live-0.33.0-1-amd64.iso /dev/sdc1''  
**didn't work.**  

## (not) [liveusb-builder](https://github.com/mytbk/liveusb-builder)  
must actually follow instructions.  
udevil from: https://software.opensuse.org/download.html?project=home%3AAndnoVember%3Atest&package=udevil  
aw, **apparently only works with its own list of distributions.**  
`./buildlive --boot /media/boot --root /media/root/ -L`  
yields specific list, which explains the `isoinfo not found` error when pointed directly to an iso.  


