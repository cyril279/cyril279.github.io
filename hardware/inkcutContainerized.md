# Inkcut + Distrobox
2025/08 revisit   
- Distribution agnostic  
- Immutable-distro friendly  
- Isolated package management  

See [notes](#notes) for details

## Overview:
1. [Create the container](#create-the-container) (into which inkcut will be installed)  
    - Define & Assemble the container  
    - Install inkcut  
2. [Create an inkcut.desktop file](#launching-inkcut-from-the-host)  
Make InkCut conveniently launchable from host machine
2. [Modify USB-serial permissions](#usb-serial-permissions)  
Address 'permission-denied' when sending data to the cutter 

## Create the container
& build/install inkcut

### Define & Assemble the container
```sh
# create directory to isolate our distrobox shenanigans
mkdir $HOME/inkcutBox && cd $_
```
```conf
# Create 'inkcutBox.ini'; container definition file
cat >$HOME/inkcutBox/inkcutBox.ini <<EOL
[inkcutBox]
image=docker.io/library/alpine:3.22
home=$HOME/inkcutBox
pull=true
additional_packages="gcc cups-dev musl-dev linux-headers"
additional_packages="python3-dev pipx py3-qt5"
additional_flags="--env PIPX_HOME=$HOME/inkcutBox/.local/share"
additional_flags="--env PIPX_INKCUT=venvs/inkcut/lib/python*/site-packages/inkcut"
exported_bins="/usr/bin/pipx"
exported_bins_path="$HOME/.local/bin"
EOL
```
```sh
# Assemble/create the container
distrobox-assemble create --file inkcutBox.ini
```
The above command:
- Creates a distrobox container based on Alpine linux 3.22  
(distrobox home located at $HOME/inkcutBox)
- Installs additional packages that are needed to build & install inkcut within the container
- Exports pipx so that it can be called from the host-OS

### Install inkcut
```sh
# Install inkcut, allowing access to the system site-packages dir
pipx install inkcut --system-site-packages
```

### Test proper creation by attempting to launch inkcut
```sh
# Direct launch
distrobox-enter --name inkcutBox -- $HOME/inkcutBox/.local/bin/inkcut
```

Successful launch?  
Great! Let's add an entry/icon for the graphical launcher.  

## Create inkcut.desktop file & icon
The following commands will Create an `inkcut.desktop` file that will make inkcut available as a clickable icon from the app menu of the host machine, just like any other graphical app.

```sh
# copy source icon for system use
distrobox-enter --name inkcutBox -- sh -c \
'cp $PIPX_HOME/$PIPX_INKCUT/res/media/inkcut.svg \
/home/$USER/.local/share/icons'
```
```conf
# Create 'inkcut.desktop' (configured as shown below)
cat >$HOME/.local/share/applications/inkcut.desktop <<EOL
[Desktop Entry]
Name=Inkcut
GenericName=Terminal entering Inkcut
Comment=Terminal entering Inkcut
Categories=Distrobox;System;Utility
Exec=/usr/bin/distrobox-enter inkcutBox -- $HOME/inkcutBox/.local/bin/inkcut
Icon=$HOME/.local/share/icons/inkcut.svg
Keywords=distrobox;
NoDisplay=false
Terminal=false
Type=Application
EOL
```
Within seconds of this file being created, it was available from the app-menu  
(Tested on Gnome).

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

### Distributions/Packages
My current distribution of choice comes with Distrobox, so that's what this revisit uses.  
Toolbox works VERY similarly, and would be fine to use as well.

I chose alpine as the container OS because it's small, and starts with a minimal set of packages installed.  
This is a low-needs project, so the low-profile OS is perfect.

'''
# alt launch commands
distrobox-enter --name inkcutBox -- sh -c '$HOME/.local/bin/inkcut'
/usr/bin/distrobox-enter --name inkcutBox -- sh -c '$HOME/.local/bin/inkcut'
/usr/bin/distrobox-enter --name inkcutBox -- .local/bin/inkcut
```
