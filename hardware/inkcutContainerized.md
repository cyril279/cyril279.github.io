# Inkcut + Distrobox
2025/08 revisit   
- Distribution agnostic  
- Immutable-distro friendly  
- Isolated python management  

See [notes](#notes) for details

## Overview:
1. [Create the container](#create-the-container) (into which inkcut will be installed)  
    - Assemble the container  
    - Enter container & install inkcut  
    - link system PyQt directory  
    - Export launch-handle to host OS (optional)  
2. [Create an inkcut.desktop file](#launching-inkcut-from-the-host)  
Make InkCut conveniently launchable from host machine
2. [Modify USB-serial permissions](#usb-serial-permissions)  
Address 'permission-denied' when sending data to the cutter 

## Create the container
& build/install inkcut

### Assemble the container
```sh
#create container:
distrobox-create \
--name inkcutBox \
--image docker.io/library/alpine:3.22 \
--home /home/$USER/distrobox/inkcutBox \
--additional-packages "gcc git cups-dev musl-dev linux-headers python3-dev pipx py3-pip py3-qt5"
```
The above command:
- Creates a distrobox container based on Alpine linux 3.22  
(distrobox home located at /home/$USER/distrobox/inkcutBox)
- Installs additional packages that are needed to build & install inkcut within the container

### Enter Container & install inkcut
```sh
# Enter the container
distrobox enter inkcutBox
```
```sh
# Install inkcut && link system PyQt directory to inkcut installation
pipx install git+https://github.com/codelv/inkcut.git \
&& ln -s \
/usr/lib/python3.12/site-packages/PyQt5 \
~/.local/share/pipx/venvs/inkcut/lib/python3.12/site-packages/
```
#### Note: 
Linking the container-system PyQt directory to the inkcut installation environment satisfies `qtpy.QtBindingsNotFoundError: No Qt bindings could be found` error.  

`pipx inject PyQt5` is what should be used here, but hasn't worked for me

### Test launch
```sh
.local/bin/inkcut
```
### Export inkcut to host-OS
...then exit the container  
```sh
#Create handle for easily launching inkcut from the host-os
distrobox-export \
--bin /home/$USER/distrobox/inkcutBox/.local/bin/inkcut \
--export-path /home/$USER/.local/bin
```
```sh
#exit the container
exit
```

## Launching inkcut from the host
Now let's work on how to launch inkcut WITHOUT entering the container.

### Test proper creation by attempting to launch inkcut from the host
```sh
# Direct launch
distrobox-enter --name inkcutBox -- ~/.local/bin/inkcut
```
We can also simply type `inkcut` to a terminal prompt,  
taking advantage of the (conditionally wrapped) `.local/bin/inkcut` file exported from `inkcutBox`

Successful launch?  
Great! Let's add an entry/icon for the graphical launcher.  

### Create inkcut.desktop file & icon
The creation of this `inkcut.desktop` file will make inkcut available as a clickable icon from the app menu of the host machine, just like any other graphical app.

Contents of `~/.local/share/applications/inkcut.desktop` :
```ini
[Desktop Entry]
Name=Inkcut@Alp3.22
GenericName=Terminal entering Inkcut
Comment=Terminal entering Inkcut
Categories=Distrobox;System;Utility
Exec=/usr/bin/distrobox-enter --name inkcutBox -- .local/bin/inkcut
Icon=/home/cyril/.local/share/icons/inkcutIcon.svg
Keywords=distrobox;
NoDisplay=false
Terminal=false
Type=Application
```
Within seconds of this file being saved, it was available from the app-menu (tested on Gnome).

## USB-serial permissions
Once a serial device is configured in inkcut, you may experience a `permission denied ... ttyUSB0` error when attempting to send a job.  
(I use a usb-serial adapter cable that shows up as /dev/ttyUSB0)  

1. ~~Make sure that your user is a member of the dialout group on the host machine~~  
    #in hindsight, I question whether this is needed considering the udev rule that is used for the container workflow.  
2. A **udev-rule** is needed to allow passthrough of serial-device permissions to the container.  
Inkcut will need this to send the job over serial interface to the cutter  

One option is to alter the permisisons of `usb` + `tty` devices to allow `other` to read & write thereto.  
Info on the device was gathered by using `udevadm info -a -n /dev/ttyACM0`

Contents of `/etc/udev/rules.d/50-usb-serial.rules` :  
```sh
SUBSYSTEM=="tty", SUBSYSTEMS=="usb", MODE:="0666", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
```
Another option is to change the owner of the devices (group seems to have no effect)
```sh
KERNEL=="ttyACM[0-9]*", SUBSYSTEMS=="usb", OWNER="cyril", GROUP="dialout", MODE:="0660", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
KERNEL=="ttyUSB[0-9]*", SUBSYSTEMS=="usb", OWNER="cyril", GROUP="dialout", MODE:="0660", ENV{ID_MM_DEVICE_IGNORE}="1", ENV{ID_MM_PORT_IGNORE}="1"
```
Reload udev  
```sh
sudo udevadm control --reload-rules
sudo udevadm trigger
```

Now, unplug your serial device and plug it back in.  
You should notice the change in permissions or ownership (or whatever) both on the host OS and in the container.  
```sh
# Host OS
ls -l /dev/ttyACM0
crw-rw-rw-. 1 cyril dialout 166, 0 Aug 16 09:30 /dev/ttyACM0
```
```sh
# Container
📦[cyril@inkcutBox cyril]$ ls -l /dev/ttyACM0
crw-rw-rw- 1 cyril nobody 166, 0 Aug 16 09:30 /dev/ttyACM0
```

## Notes
### Installing inkcut to a container
Is this necessary? No, but...  
The isolation from the host OS makes the installation MUCH less prone to breaking as a result of updates to the host OS, or packaging & configuration conficts.
Once the needs of the distrobox  have been sorted, the declarative distrobox.ini captures everything needed to recreate the fully-functional container.
The distrobox approach works exactly the same on a LARGE number of linux distributions.
Containerized apps (flatpak, distrobox, docker, etc) are considered good practice even if the system is mutable.

### pipx who?
Attempts to use `pip install someThing` trigger a warning suggesting to either install python stuff using the core package manager, or using `pipx` - a tool that creates and works inside a virtual environment.  
Isolation is tha way nowadays.

### Distributions/Packages
My current distribution of choice comes with Distrobox, so that's what this revisit used.  
Toolbox works VERY similarly, and would be fine to use as well.

I chose alpine as the container OS because it's small, and starts with a minimal set of packages installed.  
This is a low-needs project, and so the low-profile OS is perfect.
