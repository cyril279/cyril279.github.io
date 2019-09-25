Start here: (no surprise)  https://wiki.archlinux.org/index.php/PulseAudio/Examples#Set_the_default_output_source

# Default audio device
Setting a specific default audio device  

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
