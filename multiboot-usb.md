# Multi-boot usb
let's have our standard util iso's on one usb.  
clonezilla, gparted, etc...  

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
