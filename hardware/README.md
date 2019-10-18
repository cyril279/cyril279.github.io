# Hardware/Firmware

- [Colorspace](#colorspace)
- [Set default device output (Audio/Video)](#set-default-device-output)
- [xorg.mouse](#xorgmouse)
- [Hauppauge HVR2250 firmware installation](#hauppauge-hvr2250-firmware-installation)
- [Cutter/Plotter via linux](#cutterplotter-via-linux)
- [PC: Lenovo T450](#lenovo-t450)
- [PC: Dell Inspiron 14z 5423](#dell-inspiron-14z-5423)
- [USB (Bootable & MultiBoot)](#usb-bootable--multiboot)

## Colorspace
Force tv-RGB output via GPU: [[ original ](colorspace.md)] [[ Brad-remix ](colorspace_brad.md)]

**GPU set to bypass/passthrough**  
The GPU is set to pass the full color range from the application to the display, which avoids unecessary manipulation of the video levels.  The disadvantage is that desktop applications which do NOT manage the colorspace correctly (or at all), end up being displayed incorrectly.

**GPU output set to match the display**  
The GPU is set to map the full color range of all applications to a specific range (whether larger or more limited), which ensures that ALL color levels (desktop environment, apps, etc) are displayed consistently, and closer to how they were intended.  The disadvantage is that some color-levels will be scaled/manipulated multiple times prior to being displayed, which may result in poorer gradients in the form of lines or banding.

## Set default device output
[**Video**](defaultDevice.md#video): work (not) in progress  

**Audio:**  
Setting a specific default audio device  

Pre-req's: `alsa-utils pulseaudio-utils`

**Determine desired device name**  
- Setup audio as desired, and play a song or video.
- `pacmd list-sinks` (example output):
    ```
    1 sink(s) available.
    * index: 8
        name: <alsa_output.pci-0000_00_1b.0.hdmi-stereo>
        driver: <module-alsa-card.c>
        flags: HARDWARE DECIBEL_VOLUME LATENCY DYNAMIC_LATENCY
        state: RUNNING
    [ ... ]
    ```
**Set desired output as default**  
- Edit `/etc/pulse/default.pa`  
- Scroll to  
  ```
  ### Make some devices default
  #set-default-sink output
  #set-default-source input  
  ```
- Change  
  `#set-default-sink output`  
  to:  
  `set-default-sink alsa_output.pci-0000_00_1b.0.hdmi-stereo`

## xorg.mouse
get mouse name:  
`egrep "Name|Handlers" /proc/bus/input/devices | egrep -B1 'Handlers.*mouse'`

https://unix.stackexchange.com/questions/58117/determine-xinput-device-manufacturer-and-model  
https://linus.haxx.se/2013/03/07/mouse-button-mapping-in-xorg-conf/  
https://fedoraproject.org/wiki/Input_device_configuration  

_/etc/X11/xorg.conf.d/10-ankermouse.conf_
```
Section "InputClass"
    Identifier       "pointer catchall"
    MatchProduct     "2.4G Wireless Mouse"
    MatchVendor      "MOSART_Semi."
    MatchIsPointer   "true"
    Option           "ButtonMapping" "1 2 3 4 5 6 7 8 2"
EndSection
```
xed is used to determine how the mouse buttons are seen by the system.  
I want button_9 to function the same as button_2, so the ButtonMapping list has “2” in both the second and ninth position. 

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
`zypper in python3-{pip,qt5,pyside2,service_identity}`  
`pip3 install git+https://github.com/codelv/inkcut.git`  

**Cutter: PII-60**  

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

## Dell Inspiron 14z 5423
Linux? yes, let's...

There is a 32GB mSATA ssd that the machine uses as fast cache for a 500GB hdd.  
The configuration is seen by linux as a RAID config, and can be turned off/didabled several ways:  
1. `sudo dmraid -E -r /dev/sda`
https://askubuntu.com/questions/190689/only-sdb-shows-up-when-installing-12-04-on-a-new-dell-inspiron-14z  
2. Alternately:  
> If you have the Intel Smart Response Technology:
Deactivate it from within Windows using the GUI,  
Change the SATA mode in the BIOS from RAID to normal.

#### touchpad issue: too sensitive, moves cursor as I am lifting finger.
**Update 2019/10**  
Libinput does not have sufficient control of this hardware, and I am less interested in going backwards to using `xf86-input-synaptics` driver just to remedy this. This is a Dell hardware limitation, We're done here.  
see: [['touchpad issue' notes](14z5423.md#touchpad-issue-too-sensitive-moves-cursor-as-i-am-lifting-finger)]  
see also: [[libinput.md](libinput.md)]  

## USB (Bootable & MultiBoot)
[Creating bootable media for bare-metal & firmware updates](bootableUSB.md)
