 # InkCut in a container
For those who prefer to use inkcut on a machine running a very-up-to-date (or immutable) distribution, this is a reliable way to isolate the specific needs of inkcut's sparsely maintained codebase while maintaining seamless integration with the host.  

The inkcut application is found & run the same way as every other package on the system.

Overview:
- Create (& enter) container
- Install prereq packages
- Install InkCut (& test)
- Make InkCut conveniently launchable from host machine
- Address access/group limitations for actually connecting to the cutter

## Installation
My container installations have been on **Almalinux 9** via toolbox, and  **openSUSE leap 15** via docker (distrobox makes it all quite easy).  The overall process should be similar for any distribution/container, but the prerequisite packages will be different.

Once inside the container, we install prerequisite packages, then install inkcut, then test.

```
#packages for almalinux 9:
dnf in python3-{qt5,qt5-devel,cups,pip,setuptools,devel} qt5-qtsvg cups-devel
#packages for openSUSE leap 15:
zypper in python3-{pip,qt5,pyside2,service_identity,cups}
#install inkcut
pip3 install inkcut
#test
inkcut
```
## Running inkcut from the host
First, let's verify that we know how to run inkcut directly from the host.  
This command will vary according to the container (toolbox, distrobox, etc).  
```
#Distrobox
/usr/bin/distrobox-enter  -n alma9  --   inkcut
#toolbox
/usr/bin/toolbox run -c alma9 inkcut
```
Replace "alma9" with your container name  
This command will be used on the "exec" line of the application desktop file that we will create in the next step.

Now that we can successfully launch InkCut from the host, Create an inkcut.desktop file so that the inkcut application is available from app menu of the host machine.

Create a `inkcut.desktop` file at `~/.local/share/applications` with the following contents:
```
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
