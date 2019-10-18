# Picture (colorspace):

Set up for desktop use or for kodi (video appliance) [have different approaches](https://docs.google.com/document/d/1jG_KH6GXcyeO6PD1BOyckej9w6nhdVJnliWQqq2zDAY/edit#heading=h.graxpyv5qy37).  
The colorspace of the display decides whether we are trying to scale to rgb full, or rgb limited.  
The Vizio FV551XVT displays a limited spectrum, so that is what we want to send from the PC.

### AVR/TV:
kodi 18 > Denon 1911 > Vizio FV551XVT  
TV: turn off the effects & color shaping & stuff. The PC will drive the bus.  
AVR: Video Mode: Auto: Process video automatically based on the HDMI content  
information. (p.47)  

### PC:
**GPU set to bypass/passthrough**  
The GPU is set to pass the full color range from the application to the display, which avoids unecessary manipulation of the video levels.  The disadvantage is that desktop applications which do NOT manage the colorspace correctly (or at all), end up being displayed incorrectly.

**GPU output set to match the display**
The GPU is set to map the full color range of all applications to a specific range (whether larger or more limited), which ensures that ALL color levels (desktop environment, apps, etc) are displayed consistently, and closer to how they were intended.  The disadvantage is that some color-levels will be scaled/manipulated multiple times prior to being displayed, which may result in poorer gradients in the form of lines or banding.

For a more detailed explanation, see how [kodi addresses colorspace](https://kodi.wiki/view/Video_levels_and_color_space#Notable_Occurrences).

#### App-managed colorspace:

app(kodi)	| gpu	| display
--: | :--: | :--
full	|	limited	| limited  

-   kodi transforms ycbcr to rgb & expands video levels from 16-235 to 0-255
-   GPU compresses video levels from 0-255 to 16-235
-   tv displays correct (limited) video levels

**advantage:** correct levels displayed for both player and desktop  
**disadvantage:** video levels are scaled twice (banding likely).  

#### GPU-managed colorspace

app(kodi)	| gpu	| display
--: | :--: | :--
limited	| full	| limited

-   kodi transforms ycbcr to rgb (but no scaling)
-   GPU leaves video untouched, i.e. pass-through
-   tv displays correct (limited) video levels

**advantage:** color-range preserved, zero scaling  
**disadvantage:** incorrect color display of desktop content (crushed blacks and whites)  

interestingly, despite kodi's recommendation to avoid the extra scaling by leaving the gpu as pass-through,openelec's colorspace recommendation seems to be to have the gpu do the scaling.  The recommendation of app vs. OS control seems to follow that kodi is an app (that can also operate as it's own DE), and openelec is an OS.

## Wayland
[Brad x tells us how](https://www.brad-x.com/2017/08/07/quick-tip-setting-the-color-space-value-in-wayland/) (and [reddit helps us out)](https://www.reddit.com/r/linuxquestions/comments/aj7ojy/has_anyone_successfully_enabled_full_rgb_range_on/elemn0b/), starting with proptest output, ending with an altered gdm.service unit.  

Instead of an altered unit, we will instead create a custom unit to configure the GPU output during boot (prior to login).

1. Gather hardware info  
2. Compose command  
3. Generate systemd-unit  

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
Module = radeon  
connector = 48 #DVI-I-1  
device = /dev/dri/card0  
property = 40 #output_csc  
value = 1 #tvrgb=1  

`proptest -M radeon -D dev/dri/card0 48 connector 40 1`

_/etc/systemd/system/tvRGB.service_
```
[Unit]
Description=Force tv-RGB (16-235) output
DefaultDependencies=no
After=sysinit.target

[Service]
Type=oneshot
ExecStart=/usr/bin/proptest -M radeon -D /dev/dri/card0 48 connector 40 1

[Install]
WantedBy=sysinit.target
```
** **NOTE** **
proptest command conflicts with plymouth boot-splash animation, so  
`spash=silent quiet` must be removed from grub kernel command line for this unit to function properly.

built using: https://www.freedesktop.org/software/systemd/man/systemd.service.html#Examples  
with input from: [https://forums.opensuse.org/showthread.php/537877...]https://forums.opensuse.org/showthread.php/537877-There-is-no-gdm-service-so-where-to-add-gdm-session-exec-line?p=2917186#post2917186

## Xorg
### (nvidia/nouveau):
Nvidia via the nouveau driver doesn’t seem to respond to xorg.conf.d colorspace entries, so we use the intel method: **<< untested >>**
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

/etc/X11/xorg.conf.d/20-nvidia.conf (sets ColorRange for the specified device)  
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
## Notes:
[kodi addresses colorspace](https://kodi.wiki/view/Video_levels_and_color_space#Notable_Occurrences)

test images  
[http://www.lagom.nl/lcd-test/](http://www.lagom.nl/lcd-test/)
[https://ndimitrov.com/wp-content/uploads/2010/07/ndimitrov_calibration_chart.jpg](https://ndimitrov.com/wp-content/uploads/2010/07/ndimitrov_calibration_chart.jpg)  

