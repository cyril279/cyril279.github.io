# workstation: openSUSE | 2019, February

### Getting started:
**packages (util):**  
```
zypper in hplip nfs4-acl-tools git htop iotop
```

**packages (preference):**  
```
zypper in elementary-xfce-icon-theme neofetch
zypper rm gnome-software joe PackageKit
zypper al gnome-software joe PackageKit
```

**packages (multimedia/codecs):**  
https://en.opensuse.org/Additional_package_repositories  
```
zypper ar -f http://ftp.gwdg.de/pub/opensuse/repositories/multimedia:/libs/openSUSE_Tumbleweed/ multimedia:libs
zypper ref
yast repositories > add > [ select as desired ]  
zypper dup --allow-vendor-change
gui:
http://opensuse-community.org/
zypper in kodi kodi.binary-addons-pvr.hts kodi.binary-addons-vfs.rar libdvdcss libdvdnav libdvdread

```
### Configuration:
#### NetworkManager vs. Wicked:  
- for laptop? NetworkManager. full stop.  
- I like the configurability of Wicked (via Yast), but it lacks gnome integration (applet)  
 
**Service switch (to [Wicked])**  
`systemctl status network` #show/verify which service is managing the network, and its status  
`systemctl stop network` #stop the network (& assigned services)  
`systemctl disable NetworkManager`  
`systemctl enable wicked`  
`systemctl start network`  #start the network (& assigned services)  
`systemctl status network`  #show/verify which service is managing the network, and its status  

#### static ip:
Use gateway ip for dns server address (& routing).  

**YAST!**  
Can invoke text-mode gui from terminal, and will help ensure that all is done right.  
`yast`  

**If wicked**, Yast cli. be sure to input interior gateway ip as route and dns server

CLI setup differs per service chosen"  
**If NetworkManager**, ~[three files need to be modified](https://forums.opensuse.org/showthread.php/431523-Configure-Static-Ip-using-the-Terminal?p=2109330#post2109330) if not done via gui.  

> You need to edit three files:  
> _/etc/sysconfig/network/ifcfg-eth0_  
> ``` 
> BOOTPROTO='static'  
> IPADDR='192.168.2.77'  
> MTU='1500'  
> NAME=''  
> NETMASK='255.255.255.0'  
> STARTMODE='auto'  
> USERCONTROL='no'  
> ``` 
> _/etc/sysconfig/network/routes_  
> ``` 
> default 192.168.2.1 - -  
> ```
> _/etc/resolv.conf_  
> ```
> nameserver 192.168.2.1  
> ```

This gem of advice:  
> Another idea, not nearly as geeky or sexy, would be to enter "yast" at that terminal prompt, then use the arrow and tab keys to get to Network Devices -> Network Settings.  
> 
> If you insist on knowing how to do it manually, just look at the contents of the files named above *after* you use Yast to see what it did.  

[Fileshare]: ../html/fileshare.html#acl-setup
[Wicked]: https://doc.opensuse.org/documentation/leap/reference/html/book.opensuse.reference/cha.network.html#sec.network.manconf.using_wicked

# xfce
less graphically demanding on old hardware.  
~~Do this on top of gnome, because I still prefer the minimal presentation of gtk applications.~~ <- no, this just handicaps xfce  
`zypper in -t pattern xfce`  
`sudo zypper in yast2-alternatives`  
in yast > misc > alternatives, switch from gdm to lightdm  
set keyboard shortcut `xfce4-popup-whiskermenu` to super-key  

## Scanner setup:
**CUPS:**  
Printer is easily added & setup via socket/port (verified working), but scanner app does not recognize scanner.

**HPLIP:**  
1. connect HP printer to network  
Involves USB connection (Linux or Windows)  
`hp-setup`
  - assign static IP  
  - assign alias on local machine via `/etc/hosts`  
2. Add/configure printer on local machine  
`hp-setup envy212`  
3. Add scanner via `YaST scanner tool`  
`yast > hardware > scanner`  
assign appropriate driver (hpaio) to newly recognized device

