# NVIDIA
note (2018/12/12): A hardware incompatibility in between an EVGA gt-730 and the DELL optiplex 3010 caused me to go radeon. Wishing I had figured this out sooner.

I get the best kodi-video playback when using Nvidia proprietary drivers, whether downloaded directly from nvidia and installed the hard way, or from RPMfusion.  

## Nvidia (but nouveau)

- Functions generally well, but hardware acceleration options were lacking, and tweak-yield didn't justify the effort.  
- Some television-stations play slightly choppy under nouveau (w/out hardware acceleration)  

`sudo dnf install mesa-vdpau-drivers libva-vdpau-driver libvdpau` # hasn't helped, but I gave up before pressing it.

## Nvidia (via NVIDIA)
**Installing the proprietary driver directly from Nvidia**  

 - creates a precarious situation regarding kernel support (and so is poorly suited for Fedora.)
 - disallows secure-boot (unless unwelcome signing ritual)
 - not wayland compatible

I had previously blamed some audio issues on the proprietary drivers, but since then, I have found lightdm to be the culprit.

## [NVIDIA (via rpmfusion)](https://rpmfusion.org/Howto/NVIDIA#Current_GeForce.2FQuadro.2FTesla)
**proprietary driver installation via rpmfusion repositories**

**Benefit:**  
beautifuller picture, easier control of colorspace (than nouveau)

**Hardware:**  
EVGA GT 730, 64 bit interface, 2gb ddr3, passively cooled.

**Installation:**  
```
sudo dnf in \
xorg-x11-drv-nvidia \
xorg-x11-drv-nvidia-cuda \
akmod-nvidia \
libva-vdpau-driver \
libvdpau
```

**Tweaks:**  
colorspace control file for gt430/denon/vizio:
```
## /etc/X11/xorg.conf.d/20-nvidia.conf

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
#	 Option "ColorSpace" "YCbCr444"
	Option "ColorSpace" "RGB"
EndSection
```

