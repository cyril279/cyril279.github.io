# Hardware/Firmware

- [68 keys](68keys.md)
- [BlueTooth Audio (Proprietary profiles, sample-rates)](#audiobt)
- [Hauppauge HVR2250 firmware installation](#hauppauge-hvr2250-firmware-installation)
- [Printing/Cups](cups.md)
- [Cutter/Plotter via linux](#cutterplotter-via-linux)
- [PC: Lenovo T450](#lenovo-t450)
- [Bootable USB media for bare-metal & firmware updates](bootableUSB.md)
- [Harmony, FLIRC, Kodi, and the shutdown dance](HARMONY-FLIRC-KODI.md)
- [Archived information](archive.md)

## AudioBT  
Bluetooth audio tweaks for increased functionality

### BT profiles
[This fork] of pulseaudio-bluetooth-modules adds LDAC, APTX, APTX-HD, AAC support, extended configuration for SBC

OpenSUSE packages
https://build.opensuse.org/package/show/home:sonaj96/pulseaudio-modules-bt
https://software.opensuse.org/package/pulseaudio-modules-bt?search_term=pulseaudio-modules-bt

To verify what you are using:

>When you pair your headphones, choose AD2P profile in sound settings. Then you can check if aptX is used:
`pactl list | grep a2dp_codec`
The response should look something like this:
`bluetooth.a2dp_codec = "APTX"`
The rest of codecs should behave similarly.

[This fork]:https://github.com/EHfive/pulseaudio-modules-bt

### Pipewire: Add sample-rates  
(bluetooth devices sometimes need this)  

Copy the configuration file to user-config space:  
`cp /usr/share/pipewire/pipewire.conf /etc/pipewire/pipewire.conf`

Uncomment and add/edit desired sample rates.  
`default.clock.allowed-rates = [ 44100, 48000 ]`

## Hauppauge HVR2250 firmware installation
https://www.linuxtv.org/wiki/index.php/Hauppauge_WinTV-HVR-2250## HVR2250 firmware installation

You already have the firmware files extracted at:  
`/storage/share/Downloads/hauppauge 2250/`  

so from that directory:  
`cp *fw /lib/firmware`

## Cutter/Plotter via linux
InkCut! 2019/10  
https://codelv.com/projects/inkcut/  

**Installation**  
fedora: (tested working Fedora 37 & 38)  
`dnf in python3-{qt5,pyside2,cups,pip,setuptools,wheel} qt5-qtsvg cups-devel`  
`pip3 install inkcut`  

fedora39: uses python-3.12 which (as of 2023/12) boogers inkcut's python installation.  
Options are to install InkCut into a VM or container (Podman/Distrobox) running something less current (like AlmaLinux)  
[>>Detailed here<<](cutter.md)

opensuse:  
`zypper in python3-{pip,qt5,pyside2,service_identity}`  
`pip3 install git+https://github.com/codelv/inkcut.git`  

**Cutter Setup: PII-60**  

Model	| PII-60
--:	| :--
Max.Cutting Width	| 590mm(23.23in)
Max.Media Loading Width	| 719mm(28.3in)
Max. Cutting Speed	| Up to 600 mm /sec (23.62 ips)
Data Buffer Size	| 4MB
Interfaces	| USB 1.1 & Parallel (Centronics) & Serial (RS-232C,9600 baud)
Commands	| HP-GL, HP-GL/2

**Setup Notes**  
**Serial connection** may return `/dev/ttyS0: Permission denied` unless user added to `dialout` group. [details](https://askubuntu.com/a/210230)  
> **Cutters with a parallel interface** (either a 'real' parallel port or using a built-in parallel-to-USB converter) must be added to your system as a printer before using them from Inkcut. Start your printer configuration utility (e.g. system-config-printer), which at least when connecting via USB should detect the connected cutter. Proceed to add it with the 'Generic' 'Raw Queue' driver.

## Lenovo T450
Laptop, 2019/12

**Bios update**  
- [bios image(iso) from Lenovo](https://support.lenovo.com/us/en/downloads/ds102109)
- [geteltorito.rpm](https://www.rpmfind.net/linux/rpm2html/search.php?query=geteltorito) (fedora.noarch version used successfully)
  (same-as or inside-of `genisoimage`? unverified)

**Install geteltorito**  
`zypper in geteltorito*.noarch.rpm`  

**Convert the (El Torito formatted) ISO to IMG**  
`geteltorito -o bios.img downloaded.iso`  

**Write IMG to USB**  
`dd if=bios.img of=/dev/sdX status=progress`  

## CD/DVD/Blu-ray to .iso
How to create an ISO disk image from a CD-ROM, DVD or Blu-ray disk
https://www.cyberciti.biz/tips/linux-creating-cd-rom-iso-image.html

First get blocksize. I am using /dev/dvdrom or /dev/sr0. Use the grave accent (`cmd`) or ($(cmd)) to perform a command substitution:  
`blocks=$(isosize -d 2048 /dev/sr0)`

Now run dd command and display progress bar while using dd command:  
`sudo dd if=/dev/sr0 of=/tmp/output.iso bs=2048 count=$blocks status=progress`

Untested (for same result):
`dd if=/dev/cdrom1 of=./image.img`  
`img2iso image.img image.iso`  
