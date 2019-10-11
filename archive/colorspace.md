# Picture (colorspace):

Set up for desktop use or for kodi (video appliance) [have different approaches](https://docs.google.com/document/d/1jG_KH6GXcyeO6PD1BOyckej9w6nhdVJnliWQqq2zDAY/edit#heading=h.graxpyv5qy37).  
The colorspace of the display decides whether we are trying to scale to rgb full, or rgb limited.  
The Vizio FV551XVT sees a limited spectrum at it’s HDMI ports, so that is what we want to send.

## hardware prep:

kodi 18 > Denon 1911 > Vizio FV551XVT  
TV: turn off the effects & color shaping & stuff. The PC will drive the bus.  
AVR: Video Mode: Auto: Process video automatically based on the HDMI content  
information. (p.47)  

## PC:
For best video playback (appliance setup), your GPU can (and should) be set to output FULL video levels. This sets the gpu to pass through all colorspace data from the player, which avoids unnecessary manipulation of the video levels.

For desktop colorspace to be accurate, the output of the GPU should be set to match the display. This ensures that the colors of all apps will display correctly, but potentially at the cost of overhandling the video levels.

### (nvidia/nouveau):
This combination doesn’t seem to respond to xorg.conf.d colorspace entries, so we use the intel method: **<< untested >>**
[[ ~/.config/autostart/ ]]
[[ /etc/xdg/autostart ]] all users

[remember to make executable](https://debian-administration.org/article/50/Running_applications_automatically_when_X_starts)

set-colorspace.sh
```
#!/bin/sh
xrandr --output HDMIx --set "Broadcast RGB" "Limited 16:235"
```
```
#!/bin/sh  
xrandr --output HDMIx --set "Broadcast RGB" "Full"
```
(replace HDMIx with the appropriate output device, verify by running xrandr).

[ref-openelec](https://openelec.tv/documentation/configuration/configuring-a-custom-xorg-conf#color-space-2) :: [ref-archwiki](https://wiki.archlinux.org/index.php/Intel_graphics#Weathered_colors_.28color_range_problem.29) :: [ref-kodiwiki](https://kodi.wiki/view/Video_levels_and_color_space#Changing_Video_Level_Settings) :: [kodi addresses colorspace](https://docs.google.com/document/d/1jG_KH6GXcyeO6PD1BOyckej9w6nhdVJnliWQqq2zDAY/edit#heading=h.8fmuuqmn0u01)

### (nvidia/nvidia);

-   **YCC** #looks nice
-   **RGB full** #crushes whites and blacks
-   **RGB limited** #does best against calibration methods

/etc/X11/xorg.conf.d/20-nvidia.conf (sets ColorRange specifically for Vizio FV551XVT)  
```
Section "Device"
	Identifier "Device0"
	Driver "nvidia"
	VendorName "NVIDIA Corporation"
	BoardName "GeForce GT 730"
EndSection

Section "Screen"
	Identifier "Screen0"
	Device "Device0"
#	Option "ColorRange" "Full"
	Option "ColorRange" "Limited"
#	Option "ColorSpace" "YCbCr444"
#	Option "ColorSpace" "RGB"
EndSection
```  
# Notes:

## [kodi addresses colorspace](https://kodi.wiki/view/Video_levels_and_color_space#Notable_Occurrences)

**kodi gpu display**

full > limited > limited  

-   kodi transforms ycbcr to rgbv & expands video levels from 16-235 to 0-255
-   GPU compresses video levels from 0-255 to 16-235
-   tv displays limited video levels

**advantage:** correct levels displayed for both player and desktop  
**disadvantage:** video levels are scaled twice (banding likely).  
^^perhaps why libreelec says [avoid to set xorg to YCbCr](https://openelec.tv/documentation/configuration/configuring-a-custom-xorg-conf#color-space)  

**kodi gpu display**

limited > full > limited

-   kodi transforms ycbcr to rgb
-   GPU leaves video untouched, i.e. pass-through
-   tv displays limited video levels

**advantage:** color-range preserved, zero scaling  
**disadvantage:** incorrect color display via desktop (crushed blacks and whites)  

Solution?: To get accurate color display on both kodi and desktop without the extra scaling, allow session (or user?) to set colorspace (no colorspace setting at kernel command-line)  

kodi session (user) can use limited > full > limited  
desktop session (or other user) can use xorg-set colorspace  

test images  
[http://www.lagom.nl/lcd-test/](http://www.lagom.nl/lcd-test/)
[https://ndimitrov.com/wp-content/uploads/2010/07/ndimitrov_calibration_chart.jpg](https://ndimitrov.com/wp-content/uploads/2010/07/ndimitrov_calibration_chart.jpg)  

try/ref:  
[https://www.brad-x.com/2017/08/07/quick-tip-setting-the-color-space-value-in-wayland/](https://www.brad-x.com/2017/08/07/quick-tip-setting-the-color-space-value-in-wayland/)  
[https://kodi.wiki/view/Video_levels_and_color_space](https://kodi.wiki/view/Video_levels_and_color_space)  
[https://bugs.freedesktop.org/show_bug.cgi?id=83226](https://bugs.freedesktop.org/show_bug.cgi?id=83226)  

# Wayland
[Brad x tells us how](https://www.brad-x.com/2017/08/07/quick-tip-setting-the-color-space-value-in-wayland/) [(and reddit helps us out)](https://www.reddit.com/r/linuxquestions/comments/aj7ojy/has_anyone_successfully_enabled_full_rgb_range_on/elemn0b/), starting with proptest output, ending with an altered gdm.service unit.

Module = radeon  
connector = 48 #DVI-I-1  
device = /dev/dri/card0  
property = 40 #output_csc  
value = 1 #tvrgb=1  

```
dubFam@kodi12:/home/cyril> proptest
trying to open device 'i915'...failed
trying to open device 'amdgpu'...failed
trying to open device 'radeon'...done
Connector 46 (DP-1)
[ ... ]
	40 output_csc:
		flags: enum
		enums: bypass=0 tvrgb=1 ycbcr601=2 ycbcr709=3
		value: 0
Connector 48 (DVI-I-1)
[ ... ]
	40 output_csc:
		flags: enum
		enums: bypass=0 tvrgb=1 ycbcr601=2 ycbcr709=3
		value: 0
```
Full output:  
```
dubFam@kodi12:/home/cyril> proptest
trying to open device 'i915'...failed
trying to open device 'amdgpu'...failed
trying to open device 'radeon'...done
Connector 46 (DP-1)
	1 EDID:
		flags: immutable blob
		blobs:

		value:
	2 DPMS:
		flags: enum
		enums: On=0 Standby=1 Suspend=2 Off=3
		value: 0
	5 link-status:
		flags: enum
		enums: Good=0 Bad=1
		value: 0
	6 non-desktop:
		flags: immutable range
		values: 0 1
		value: 0
	4 TILE:
		flags: immutable blob
		blobs:

		value:
	31 coherent:
		flags: range
		values: 0 1
		value: 1
	35 underscan:
		flags: enum
		enums: off=0 on=1 auto=2
		value: 0
	36 underscan hborder:
		flags: range
		values: 0 128
		value: 0
	37 underscan vborder:
		flags: range
		values: 0 128
		value: 0
	39 dither:
		flags: enum
		enums: off=0 on=1
		value: 0
	33 scaling mode:
		flags: enum
		enums: None=0 Full=1 Center=2 Full aspect=3
		value: 0
	38 audio:
		flags: enum
		enums: off=0 on=1 auto=2
		value: 2
	40 output_csc:
		flags: enum
		enums: bypass=0 tvrgb=1 ycbcr601=2 ycbcr709=3
		value: 0
Connector 48 (DVI-I-1)
	1 EDID:
		flags: immutable blob
		blobs:

		value:
			00ffffffffffff0011ee1d0001010101
			00140103807944780a171ba55349a326
			0e474aa7ce0001010101010101010101
			010101010101023a801871382d40582c
			5500baa84200001e000000fd00324d1f
			460f000a202020202020000000ff0055
			50454e414b33333030393837000000fc
			0044454e4f4e2d4156414d500a200102
			02033c71501f13040103900512151420
			000f241e26350f7f073d1ec01507505f
			7e01570600657e00671e00835f00006c
			030c003400a82dc000000000011d0072
			51d01e206e285500baa84200001e011d
			80d0721c1620102c2580baa84200009e
			8c0ad08a20e02d10103e9600baa84200
			00180000000000000000000000000085
	2 DPMS:
		flags: enum
		enums: On=0 Standby=1 Suspend=2 Off=3
		value: 0
	5 link-status:
		flags: enum
		enums: Good=0 Bad=1
		value: 0
	6 non-desktop:
		flags: immutable range
		values: 0 1
		value: 0
	4 TILE:
		flags: immutable blob
		blobs:

		value:
	31 coherent:
		flags: range
		values: 0 1
		value: 1
	35 underscan:
		flags: enum
		enums: off=0 on=1 auto=2
		value: 0
	36 underscan hborder:
		flags: range
		values: 0 128
		value: 0
	37 underscan vborder:
		flags: range
		values: 0 128
		value: 0
	39 dither:
		flags: enum
		enums: off=0 on=1
		value: 0
	33 scaling mode:
		flags: enum
		enums: None=0 Full=1 Center=2 Full aspect=3
		value: 0
	38 audio:
		flags: enum
		enums: off=0 on=1 auto=2
		value: 2
	32 load detection:
		flags: range
		values: 0 1
		value: 1
	40 output_csc:
		flags: enum
		enums: bypass=0 tvrgb=1 ycbcr601=2 ycbcr709=3
		value: 0
CRTC 42
CRTC 44
``` 
