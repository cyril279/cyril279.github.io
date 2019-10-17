# Default output device
Ensuring output to the correct devices (audio & video) upon resume from suspend, or when display is disconnected and reconnected.

## Audio
Setting a specific default audio device  
start here: (no surprise)  https://wiki.archlinux.org/index.php/PulseAudio/Examples#Set_the_default_output_source

Pre-req's: `alsa-utils pulseaudio-utils`

### Determine desired device name
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
### Set desired output as default
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

### References
https://forums.linuxmint.com/viewtopic.php?t=288517  
https://rastating.github.io/setting-default-audio-device-in-ubuntu-18-04/  

or this? tries `pacmd list-cards`  
https://forums.linuxmint.com/viewtopic.php?t=295237#p1645250 

## Video
Resume issues. Is this handled by x? do we need xrandr tricks? or does resume get information from KMS settings?  
2019/09/27: finding out that Dell's onboard video is stubbornly biased toward vga. I can't get a status on the hdmi port no matter what I try.  

### KMS
kernel mode setting is the earliest point that we can specify the output.  
It is not obvious what effect this may have on a graphical system resuming from suspend, but let's start there.  

kms [force mode method #1](https://wiki.archlinux.org/index.php/Kernel_mode_setting#Forcing_modes_and_EDID), backed up by [this other blog post](http://blog.fraggod.net/2017/10/11/force-enable-hdmi-to-specific-mode-in-linux-framebuffer-console.html).  
1. With everything connected (and displaying) as desired, browse `/sys/class/drm/` to find the card notation that you will need. example: `/sys/class/drm/card0/card0-HDMI-A-1/`  
2. `drm_kms_helper.edid_firmware=edid/1920x1080.bin` and `video=HDMI-A-1:1920x1080@60e` to `GRUB_CMDLINE_LINUX_DEFAULT`of `/etc/defaut/grub`
3. or `nomodeset video=HDMI1:1920x1080@60` Which would set the virtual terminal to 1920x1080, which is 1080p... And use the first HDMI port at that mode. [ ref ](https://ubuntuforums.org/showthread.php?t=2294043&p=13353935#post13353935)
4. or `video=VGA-1:d drm_kms_helper.edid_firmware=edid/1920x1080.bin video=HDMI-A-1:1920x1080@60e` 
certain changes require update of initramfs via `dracut -f`  
for optiplex3010, try: uefi>maintenance>serr messaging [off]  
[Cannot output to HDMI-A-1... cannot even status HDMI-A-1](https://forums.opensuse.org/showthread.php/537671-Cannot-output-to-HDMI-A-1-cannot-even-status-HDMI-A-1)

### xrandr
`xrandr --verbose` to get the name of the output and a working mode line

 
