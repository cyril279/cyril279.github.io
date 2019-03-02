# Multi-boot usb
let's have our standard util-iso's on one usb.  
clonezilla, gparted, etc...  

## [MultiBoot USB](https://mbusb.aguslr.com/)  
git clone the project, then from within the folder, prepare the usb.  
per [using the script](https://mbusb.aguslr.com/install.html#using-the-script):  
`./makeUSB.sh -b -e /dev/sdc ext4`

**Get bootable files**  
>Once you have a bootable USB drive, it only remains to copy the bootable files (ISO or kernel) to the pendrive. [...] save them into $mntusb/boot/isos.  

## Windows USB
WoeUSB (gui tool)
Windows USB installation media creator for the gnu/linux platform  
`sudo zypper in WoeUSB`  

## Bootable USB issues:
- GPT not recognised  
- volume/device size not recognized (4gb seems to be the max for some ~2012 devices)  

