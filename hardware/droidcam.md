## Because installing droidcam on a secure distro is a bear

Must first get a standing v4l2loopback installation, and loaded module.  
Without that, there is no need to even install droidcam.  
regarding the laptop issues, let's first get rid of the v4l2loopback-kmod and akmod... everything pre-packaged. dnf rm that shit.  

Installation of v4l2...  
 1) `sudo dnf in v4l2loopback dkms rpm-build openssl libappindicator-gtk3 v4l-utils android-tools`
 3) [grab this script](https://gist.github.com/Underknowledge/78bdf079469f3f5eb4d1dfb9419cc149)
 and run it.
 4) reboot and use the password, like the script output tells you.
 5) run the script again, which signs, builds & loads the module.

```
sudo modprobe videodev 
sudo modprobe v4l2loopback video_nr=9 devices=1 card_label="Droidcam"
v4l2loopback-ctl set-caps "video/x-raw, format=I420, width=1920, height=1080" /dev/video9
```
successful? then in another terminal: `sudo dracut -f`  

Continue only if v4l2loopback loads.

Droidcam installation:  
during `./install dkms`, problem loading unsigned module into service.  
per https://github.com/umlaeute/v4l2loopback/issues/394#issuecomment-813611110  

grab 51-android-udev.rules [from here](https://github.com/M0Rf30/android-udev-rules/blob/master/51-android.rules), and save the file to `/etc/udev/rules.d/`  
https://github.com/M0Rf30/android-udev-rules/blob/master/51-android.rules  
follow the directions on the readme.md  

 2) sudo ./install-client
 
 now droidcam runs, but what about the video resolution? see "info".  
 
[forum conversation of my existing struggle with this](https://forums.opensuse.org/showthread.php/545656-v4l2loopback-resolution-How-to-store-configuration-across-reboots)

The complete process, I do not fully grasp.  
There is something about the followup to updating the kernel as well.  
Some module needs to be rebuilt, but then do we have to go through the entire signature thing again?  

`v4l2-ctl -d /dev/video9 --all` shows the status of /dev/video9

somewhere along the line, things work the way they did on opensuse.  
The appearance of native fedora packages is... misleading?  
It seems that without droidcam involved at all, I need to be able to get v4l2loopback installed and loadable.  

info: modinfo v4l2loopback:  
```
cyril@fedora ~
> $ modinfo v4l2loopback
filename:       /lib/modules/5.11.17-300.fc34.x86_64/extra/v4l2loopback.ko.xz
license:        GPL
author:         Vasily Levin, IOhannes m zmoelnig <zmoelnig@iem.at>,Stefan Diewald,Anton Novikovet al.
description:    V4L2 loopback video device
depends:        videodev
retpoline:      Y
name:           v4l2loopback
vermagic:       5.11.17-300.fc34.x86_64 SMP mod_unload 
sig_id:         PKCS#7
signer:         fedora_signing_key
sig_key:        5B:24:F0:9F:1A:76:24:60:B0:93:BA:E1:70:30:2C:CF:4D:D2:70:CC
sig_hashalgo:   sha256
signature:      51:7F:6E:AB:7E:25:08:FD:7C:FB:36:4B:CA:F2:55:1D:E2:8F:14:11:
		74:A6:C1:4C:9C:9C:16:63:38:EB:73:88:B7:EA:90:52:92:2C:A4:50:
		A0:D4:61:CE:C2:42:3B:5D:B4:8F:C1:8B:19:D3:25:71:58:C5:84:21:
		42:58:3B:88:BA:6F:AE:D7:4E:AC:DF:D1:5A:26:41:40:DF:80:C9:D9:
		DD:8C:01:C0:23:2A:A3:68:D7:C7:69:E5:1A:CE:87:77:37:A2:B5:35:
		B9:E6:29:FC:C6:A3:C9:B9:91:61:42:49:6E:FA:4C:F5:31:F3:C6:CF:
		DC:59:A4:8C:FF:27:75:3A:03:83:F5:0B:65:9C:33:AF:14:83:A3:77:
		5B:AB:E0:DF:3F:0A:57:9E:E5:03:6D:C9:3B:A0:26:E1:2A:B1:9B:F7:
		B8:9A:99:C1:8C:D0:5B:19:69:03:6A:E6:95:DD:2A:4F:AC:F1:8B:D2:
		86:EA:40:45:8B:DC:3E:11:0F:BB:74:2E:DD:89:53:22:17:E0:DB:98:
		E5:0B:C5:69:30:D4:48:B6:ED:55:D4:47:D2:3B:CF:5A:56:87:97:1B:
		D5:DB:E1:C4:E0:01:3C:DC:43:F8:1B:D4:F2:D8:19:1D:5E:CB:24:17:
		80:6A:B1:5A:AC:27:4A:5B:A2:8E:E1:76:77:02:A9:EB
parm:           debug:debugging level (higher values == more verbose) (int)
parm:           max_buffers:how many buffers should be allocated (int)
parm:           max_openers:how many users can open loopback device (int)
parm:           devices:how many devices should be created (int)
parm:           video_nr:video device numbers (-1=auto, 0=/dev/video0, etc.) (array of int)
parm:           card_label:card labels for every device (array of charp)
parm:           exclusive_caps:whether to announce OUTPUT/CAPTURE capabilities exclusively or not (array of bool)
parm:           max_width:maximum frame width (int)
parm:           max_height:maximum frame height (int)
```

```
sudo modprobe videodev 
sudo modprobe v4l2loopback video_nr=9 devices=1 card_label="Droidcam"
v4l2loopback-ctl set-caps "video/x-raw, format=I420, width=1280, height=720" /dev/video9
```
successful? then in another terminal: `sudo dracut -f`  

untried_01:  
```
sudo modprobe videodev 
sudo modprobe v4l2loopback video_nr=9 card_label="Droidcam"
sudo modprobe v4l2loopback max_width=1920 max_height=1080
```

untried_02:  
/etc/modprobe.d/v4l2loopback.conf  
```
options v4l2loopback video_nr=9
options v4l2loopback card_label="Droidcam"
options v4l2loopback max_width=1920
optoins v4l2loopback max_height=1080
```

/etc/modules-load.d/v4l2loopback.conf  
```
v4l2loopback
```

Installed on 12500:  
```
cyril@fedora ~/workbench/github/cyril279.github.io 
> $ rpm -qav | grep v4l
libv4l-1.20.0-3.fc34.x86_64
v4l2loopback-0.12.5-3.fc34.noarch
akmod-v4l2loopback-0.12.5-3.fc34.x86_64
kmod-v4l2loopback-5.11.17-300.fc34.x86_64-0.12.5-3.fc34.x86_64
v4l-utils-1.20.0-3.fc34.x86_64
```

latest:  
`sudo dnf rm kmod-v4l2loopback`  
Everything (seems to) still works.  
started with:  
`sudo modprobe v4l2loopback video_nr=9 devices=1 card_label="Droidcam" max_width=1920 max_height=1080`  
which (seemed to) load videodev (since internally defined as a dependency?)
