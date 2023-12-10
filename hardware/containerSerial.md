# Accessing USB serial devices in Fedora Silverblue
BY  CHRIS  
2020, April 18  
FEDORA, FOSS  
ref: https://blog.christophersmart.com/2020/04/18/accessing-usb-serial-devices-in-fedora-silverblue/  

One of the things I do a lot on my Fedora machines is talk to devices via USB serial. While a device is correctly detected at /dev/ttyUSB0 and owned by the dialout group, adding myself to that group doesn’t work as it can’t be found. This is because under Silverblue, there are two different group files (/usr/lib/group and /etc/group) with different content.  

There are some easy ways to solve this, for example we can create the matching dialout group or write a udev rule. Let’s take a look!

## On the host with groups

If you try to add yourself to the dialout group it will fail.

```sh
sudo gpasswd -a ${USER} dialout
gpasswd: group 'dialout' does not exist in /etc/group
```
Trying to re-create the group will also fail as it’s already in use.

```sh
sudo groupadd dialout -r -g 18
groupadd: GID '18' already exists
```
So instead, we can simply grab the entry from the OS group file and add it to /etc/group ourselves.

```sh
grep ^dialout: /usr/lib/group |sudo tee -a /etc/group
```

Now we are able to add ourselves to the dialout group!
```sh
sudo gpasswd -a ${USER} dialout
```
Activate that group in our current shell.

```sh
newgrp dialout
```
And now we can use a tool like screen to talk to the device (note you will have needed to install screen with rpm-ostree and rebooted first).

```sh
screen /dev/ttyUSB0 115200
```
And that’s it. We can now talk to USB serial devices on the host.

## Inside a container with udev

Inside a container is a little more tricky as the dialout group is not passed into it. Thus, inside the container the device is owned by nobody and the user will have no permissions to read or write to it.

One way to deal with this and still use the regular toolbox command is to create a udev rule and make yourself the owner of the device on the host, instead of root.

To do this, we create a generic udev rule for all usb-serial devices.

```sh
cat << EOF | sudo tee /etc/udev/rules.d/50-usb-serial.rules
SUBSYSTEM=="tty", SUBSYSTEMS=="usb-serial", OWNER="${USER}"
EOF
```
If you need to create a more specific rule, you can find other bits to match by (like kernel driver, etc) with the udevadm command.

```sh
udevadm info -a -n /dev/ttyUSB0
```
Once you have your rule, reload udev.

```sh
sudo udevadm control --reload-rules
sudo udevadm trigger
```
Now, unplug your serial device and plug it back in. You should notice that it is now owned by your user.

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
And of course, as this is inside a container, you can just dnf install screen or whatever other program you need.

Of course, if you’re happy to create the udev rule then you don’t need to worry about the groups solution on the host.