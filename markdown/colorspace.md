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

> Written with [StackEdit](https://stackedit.io/).
<!--stackedit_data:
eyJoaXN0b3J5IjpbMTEyMTUyNTAzOV19
-->