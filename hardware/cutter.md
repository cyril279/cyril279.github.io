# InkCut in a container
**Challenge**  
An increasing number of distributions ship with **python3.11 or later**, which fouls the inkcut installation.  

**Solution**  
Installing inkcut to a container provides a reliable way to isolate the specific needs of inkcut's sparsely maintained codebase while maintaining close integration with the host OS.  
With the approach outlined below, inkcut is accessed and launched the same way as every other graphical package on the system.  

**Bonus**  
This method also applies to immutable distributions where container/sandbox apps are 'the way'  

## Overview:
1. [Create the container](#create-container) (into which we will install inkcut)
2. Enter the container and install packages that will be needed to build inkcut
2. [Build (& test) inkcut](#install-inkcut)
2. [Create an inkcut.desktop file](#launching-inkcut-from-the-host)  
Make InkCut conveniently launchable from host machine
2. [Create a udev rule](#usb-serial-permissions)  
Address access/group limitations for actually connecting to the cutter 

## Create container
**Note**: Each container-image version was chosen specifically for python = 3.10.x

### openSUSE Leap15
```sh
#create container:
distrobox-create --name inkcutBox --image registry.opensuse.org/opensuse/leap:15

#enter container:
distrobox enter inkcutBox

#install prereq. packages to container
sudo zypper install python3-{pip,qt5,service_identity,cups}
```

### Alpine 3.16
```sh
#create container:
distrobox-create --name inkcutBox --image alpine:3.18

#enter container:
distrobox enter inkcutBox

#install prereq. packages to container
sudo apk add gcc python3-dev musl-dev linux-headers py3-{pip,pycups,qt5}
```

### Almalinux 9
```sh
#create container:
distrobox-create --name inkcutBox --image quay.io/toolbx-images/almalinux-toolbox:9

#enter container:
distrobox enter inkcutBox

#install prereq. packages to container
sudo dnf install python3-{qt5,qt5-devel,cups,pip,setuptools,devel} qt5-qtsvg cups-devel
```

## Install Inkcut
While still inside the container
```sh
# Build/Install inkcut
pip install inkcut

# Test for successful launch
.local/bin/inkcut
```
Successful launch? Let's move on.


## Launching inkcut from the host
The creation of this **inkcut.desktop** file will make inkcut available as a clickable icon from the app menu of the host machine, just like any other graphical app.

First, let's verify that we know how to launch inkcut directly from the host.  
This command will vary according to the container (toolbox, distrobox, etc), and will be used in place of `>>run command here<<` on the `Exec` line of the `inkcut.desktop` file that we will create in the following step.  
```sh
#Distrobox
/usr/bin/distrobox-enter -n inkcutBox -- .local/bin/inkcut

#toolbox
/usr/bin/toolbox run -c inkcutBox inkcut
```

Contents of `~/.local/share/applications/inkcut.desktop` :
```conf
[Desktop Entry]
Type=Application
Name=Inkcut
GenericName=Inkcut
Comment=Open-source 2D plotting software
Exec=>>run command here<<
Icon=
Terminal=false
Categories=Graphics;Office;
MimeType=image/svg+xml;
Keywords=plotter;cutter;vinyl;cnc;2D;
```

Alternate Contents of `~/.local/share/applications/inkcut.desktop` :
```conf
[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec=toolbox run -c inkcutBox inkcut
Name=inkcut
Comment=Software for your cutter
Keywords=cutter;plotter;
Icon=
```
Within seconds of this file being saved, it was available from the app-menu (tested on Gnome).

## USB-serial permissions
Once a serial device is configured in inkcut, you may experience a `permission denied ... ttyUSB0` error when attempting to send a job.  
(I use a usb-serial adapter cable that shows up as /dev/ttyUSB0)  

1. ~~Make sure that your user is a member of the dialout group on the host machine~~  
    #in hindsight, I question whether this is needed considering the udev rule that is used for the container workflow.  
2. A **udev-rule** is needed to allow passthrough of serial-device permissions to the container.  
Inkcut will need this to send the job to the cutter  

Contents of `/etc/udev/rules.d/50-usb-serial.rules` :  
```sh
SUBSYSTEM=="tty", SUBSYSTEMS=="usb-serial", OWNER="${USER}"
```

Reload udev  
```sh
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Now, unplug your serial device and plug it back in. You should notice that it is now owned by your user, not root.  
```sh
ls -l /dev/ttyUSB0
crw-rw----. 1 csmart dialout 188, 0 Apr 18 20:53 /dev/ttyUSB0
```

It should also be the same inside the toolbox container now.  
```sh
[21:03 csmart ~]$ toolbox enter
⬢[csmart@toolbox ~]$ ls -l /dev/ttyUSB0 
crw-rw----. 1 csmart nobody 188, 0 Apr 18 20:53 /dev/ttyUSB0
```  
**Profit!**  
ref: https://blog.christophersmart.com/2020/04/18/accessing-usb-serial-devices-in-fedora-silverblue/  
ref: [Accessing usb serial devices in fedora silverblue](containerSerial.md#inside-a-container-with-udev)  

post-installation container size comparison
```sh
cyril@x1c6:~> podman ps --size
CONTAINER ID  IMAGE                                           PORTS        NAMES       SIZE
43296ed867e2  registry.opensuse.org/opensuse/leap:15     ...  inkcutLeap   1.46GB (virtual 1.7GB)
ddd81161f33f  quay.io/toolbx-images/alpine-toolbox:3.16  ...  inkcutAlpine 771MB (virtual 982MB)
70fae8d15555  quay.io/toolbx-images/almalinux-toolbox:9  ...  inkcutAlma   1.29GB (virtual 1.88GB)
```