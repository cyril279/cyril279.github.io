## Running sparsely-maintained inkcut in a forward-leaning linux distribution...
Fedora 39 ships with python-3.12 which trips-up inkcut (valid 2023/12).

**Solution #1 (preferred)**  
Installing/running inkcut from within a toolbox provides the best integration with the host, but requires some handy-work to ensure that the relevant serial permissions are passed to the container. 

**Solution #2**  
Installing inkcut to a VM works without permissions workarounds, with 2 caveats:  
1) The files that we want to use in inkcut have to be explicitly shared with the VM for each edit  
2) The USB interface must be passed-through to the VM each time it is run  
The isolation of a VM works against the productivity of this method.  

## Procedure:
### Create (& enter) a toolbox using AlmaLinux9 image (RHEL for the people)  
ref: https://github.com/toolbx-images/images  
```sh
toolbox create --image quay.io/toolbx-images/almalinux-toolbox:9 alma9
toolbox enter alma9
```
### Install prerequisite software per inkcut-installation directions for fedora37/38  
```sh
dnf in python3-{qt5,qt5-devel,cups,pip,setuptools,devel} qt5-qtsvg cups-devel
```   
### Install inkcut (& test)  
```sh
pip3 install inkcut
```  
### Create inkcut.desktop file on host machine (allows to launch inkcut graphically from host machine)  
.local/share/applications/inkcut.desktop  
```sh
[Desktop Entry]
Version=1.0
Type=Application
Terminal=true
Exec=toolbox run -c alma9 inkcut
Name=inkcut
Comment=Software for your cutter
Keywords=cutter;plotter;
Icon=
```  
### Create udev rule that makes $user the owner of `/dev/ttyUSB0`  
to allow passthrough of serial-device permissions to container  

ref: https://blog.christophersmart.com/2020/04/18/accessing-usb-serial-devices-in-fedora-silverblue/  
ref: [Accessing usb serial devices in fedora silverblue](containerSerial.md#inside-a-container-with-udev)  
/etc/udev/rules.d/50-usb-serial.rules  
```sh
SUBSYSTEM=="tty", SUBSYSTEMS=="usb-serial", OWNER="${USER}"
```  
Once you have your rule, reload udev.  
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
