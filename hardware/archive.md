# Hardware/Firmware (archived info)

- [Colorspace](#colorspace)
- [Set default device output (Audio/Video)](#set-default-device-output)
- [xorg.mouse](#xorgmouse)
- [PC: Dell Inspiron 14z 5423](#dell-inspiron-14z-5423)

## Colorspace
Force tv-RGB output via GPU: [[ original ](colorspace.md)] [[ Brad-remix ](colorspace_brad.md)]

**GPU set to bypass/passthrough**  
The GPU is set to pass the full color range from the application to the display, which avoids unecessary manipulation of the video levels.  The disadvantage is that desktop applications which do NOT manage the colorspace correctly (or at all), end up being displayed incorrectly.

**GPU output set to match the display**  
The GPU is set to map the full color range of all applications to a specific range (whether larger or more limited), which ensures that ALL color levels (desktop environment, apps, etc) are displayed consistently, and closer to how they were intended.  The disadvantage is that some color-levels will be scaled/manipulated multiple times prior to being displayed, which may result in poorer gradients in the form of lines or banding.

## Set default device output
[**Video**](defaultDevice.md#video): work (not) in progress  

**Audio:**  
Helps if the device is already configured in yast.  

**Yast unable to configure card due to snd-hda-intel module?**  
  in ***/etc/modprobe.d/50-sound.conf*** , change:  
  `options snd slots=snd-hda-intel` to `options snd-hda-intel enable=1 index=0`

**Setting a specific default audio device**  
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
see: ['touchpad issue' notes](14z5423.md#touchpad-issue-too-sensitive-moves-cursor-as-i-am-lifting-finger)  
also: [libinput.md](libinput.md)  
