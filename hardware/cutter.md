# Inkcut + Distrobox
2025/08 revisit   
- Distribution independent
- Immutable-distro friendly
- Isolated python management.  

See [notes](#notes) for details

## Overview:
1. Create the container (into which inkcut will be installed)  
The [declarative approach](#create-the-container) will create the container and build & install inkcut in one step.  
The [decomposed approach](#decomposed-approach) separates the process, facilitating troubleshooting.
2. [Create an inkcut.desktop file](#launching-inkcut-from-the-host)  
Make InkCut conveniently launchable from host machine
2. [Modify USB-serial permissions](#usb-serial-permissions)  
Address 'permission-denied' when sending data to the cutter 

## Create the container
& build/isntall inkcut

### Create distrobox.ini file/entry
I prefer to use `~/distrobox` directory to store the `distrobox.ini` file and also for the home directory of each container.  

distrobox.ini:
```ini
[inkcutBox]
image=docker.io/library/alpine:3.22
home=/home/cyril/distrobox/inkcutBox
pull=true
start_now=true
additional_packages="gcc cups-dev musl-dev linux-headers"
additional_packages="python3-dev pipx py3-pip py3-qt6"
additional_packages="fastfetch git"
# Build/Install inkcut
init_hooks=pipx install git+https://github.com/codelv/inkcut.git;
# link system PyQt directory to prevent
# qtpy.QtBindingsNotFoundError: No Qt bindings could be found
init_hooks=ln -s /usr/lib/python3.12/site-packages/PyQt6 ~/.local/share/pipx/venvs/inkcut/lib/python3.12/site-packages/;
```
### Assemble the container (also installs inkcut to the container)
```sh
distrobox-assemble create --name inkcutBox
```
### Test proper creation by attempting to launch inkcut from the host
```sh
/usr/bin/distrobox-enter --name inkcutBox -- ~/.local/bin/inkcut
```
Successful launch?  
if no, try [this decomposed approach](#decomposed-approach) to help isolate where things might be going wrong.  
if yes, Great! Let's move on.

## Launching inkcut from the host
The creation of this **`inkcut.desktop`** file will make inkcut available as a clickable icon from the app menu of the host machine, just like any other graphical app.

First, let's verify that we know how to launch inkcut directly from the host.  
This command will vary according to the container (toolbox, distrobox, etc), and will be used in place of `>>run command here<<` on the `Exec` line of the `inkcut.desktop` file that we will create in the following step.  
```sh
#Distrobox
/usr/bin/distrobox-enter -n inkcutBox -- ~/.local/bin/inkcut

#Distrobox; rootful, created at specific path
/usr/bin/distrobox-enter -n inkcutBox -- distrobox/inkcutBox/.local/bin/inkcut

#toolbox
/usr/bin/toolbox run -c inkcutBox inkcut
```

Contents of `~/.local/share/applications/inkcut.desktop` :
```ini
[Desktop Entry]
Name=Inkcut@Alp3.22
GenericName=Terminal entering Inkcut
Comment=Terminal entering Inkcut
Categories=Distrobox;System;Utility
Exec=/usr/bin/distrobox-enter --name inkcutBox -- ~/.local/bin/inkcut
Icon=/home/cyril/.local/share/icons/inkcutIcon.svg
Keywords=distrobox;
NoDisplay=false
Terminal=true
TryExec=/usr/bin/distrobox
Type=Application
```
Within seconds of this file being saved, it was available from the app-menu (tested on Gnome).
[Alternate inkcut.desktop entries](#alternate-inkcutdesktop-contents)  

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
## Decomposed Approach
### Create & enter container, prep environment
```sh
#create container:
distrobox-create \
--name inkcutBox \
--image docker.io/library/alpine:3.22 \
--home ~/distrobox/inkcutBox
```
```sh
#enter container:
distrobox enter inkcutBox
```
```sh
#install prereq. packages to container
sudo apk add gcc git cups-dev musl-dev linux-headers python3-dev pipx py3-{pip,qt6}
```
### Build & install Inkcut
```sh
# Build/Install inkcut
pipx install git+https://github.com/codelv/inkcut.git
```
```sh
# link system PyQt directory to prevent
# qtpy.QtBindingsNotFoundError: No Qt bindings could be found
ln -s /usr/lib/python3.12/site-packages/PyQt6 \
~/.local/share/pipx/venvs/inkcut/lib/python3.12/site-packages/
```
### Test for successful launch
(while still inside container)  
```sh
~/.local/bin/inkcut
```
Successful launch? Let's move onto [launching from the host](#launching-inkcut-from-the-host).


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

### Failure to launch Inkcut because
`qtpy.QtBindingsNotFoundError: No Qt bindings could be found`

This error showed up when my preferred distributions started using `python 3.12.x`  
The solution is to copy (or symbolically link) the PyQt directory from the system location to the local inkcut installation.
```sh
# example
ln -s /usr/lib/site-packages/python312/PyQt6 \
/.local/share/pipx/.../site-packages/python312/
```
### Distributions/Packages
My current distribution of choice comes with Distrobox, so that's what this revisit used.  
Toolbox works VERY similarly, and would be fine to use as well.

I chose alpine as the container OS because it's small, and starts with a minimal set of packages installed.  
This is a low-needs project, and so the low-profile OS is perfect.
### Alternate inkcut.desktop Contents
```ini
[Desktop Entry]
Name=Inkcut@Alp3.22
GenericName=Terminal entering Inkcut
Comment=Terminal entering Inkcut
Categories=Distrobox;System;Utility
Exec=sh -c 'distrobox enter -n inkcutBox -- ~/.local/bin/inkcut'
Icon=/home/cyril/.local/share/icons/inkcutIcon.svg
Keywords=distrobox;
NoDisplay=false
Terminal=false
TryExec=/usr/bin/distrobox
Type=Application
```
```ini
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
```ini
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
